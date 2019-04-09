from __future__ import division
from collections import defaultdict
from itertools import compress
from io import BytesIO
from decimal import *
from numpy import * 
import sys
import time
import numpy
import scipy.io
import scipy.linalg
import scipy.sparse
import scipy.sparse.linalg

import boto3
from pyspark import SparkConf, SparkContext
from pyspark.accumulators import AccumulatorParam

# Custom accumulator class  
class NdarrayAccumulatorParam(AccumulatorParam):
    def zero(self, initial):
        return numpy.array(numpy.zeros(initial.shape))
    def addInPlace(self, x, y):
        x += y
        return x

# Treatments to apply to every class
def PerClassTreatment(Xc,n):
	global tSb
	global tSw
	[d,nc] = Xc.shape
	Xc2 = numpy.matrix(numpy.sum(numpy.power(Xc, 2), axis=0))
	distance2 = numpy.tile(Xc2,(nc,1))
	distance2 = distance2 + numpy.tile(Xc2.T,(1,nc))
	distance2 = numpy.array(distance2 - 2 * numpy.dot(Xc.T, Xc))
	Sorted = numpy.zeros(shape=(distance2.shape[0], distance2.shape[1]))
	Sorted[:] = distance2[:]
	Sorted.sort(0)
	kNNdist2 = numpy.matrix(Sorted[7,:])
	sigma = numpy.sqrt(kNNdist2)
	localscale = numpy.array(sigma.T * sigma)
	flag = localscale!=0
	A = numpy.zeros(shape=(nc,nc))
	A[flag] = numpy.exp(-distance2[flag] / localscale[flag])
	Xc1 = numpy.sum(Xc, axis=1)
	G = Xc * numpy.multiply(numpy.tile(numpy.sum(numpy.matrix(A), axis=1),(1, d)), Xc.T) - numpy.dot(Xc, numpy.dot(A, Xc.T))
	tSb+=G/n + numpy.dot(Xc, Xc.T) * (1-nc/n) + numpy.dot(Xc1, Xc1.T)/ n
	tSw+=G/nc

# Optimisation of LFDA
# Transforming the data into lists of samples' information grouped by class
def grouping(X,Y,nMax,n,optimize):
	# dataByClass is a dictionary where (key = class label) and (value = list of corresponding samples).
	dataByClass = defaultdict(list)
	# maxClasses is the actual number of classes.
	maxClasses = numpy.amax(Y)
	if(optimize == 1):
		# classes is a dictionary where (key = class label) and (value = number of samples).
		classes = {}
		# maxClasses' value will change through the processing to account for the newly-defined sub-classes containing at most nMax samples.
		maxClasses += 1
		classes[maxClasses] = 0
		for i in range(n):
			if Y[i,0] not in classes:
				classes[Y[i,0]] = 1
				dataByClass[Y[i,0]].append(X[i,:])
			else:
				if classes[Y[i,0]] == nMax:
					if classes[maxClasses] == nMax:
						maxClasses += 1
						classes[maxClasses] = 0
					classes[maxClasses] += 1
					dataByClass[maxClasses].append(X[i,:])
				else:
					classes[Y[i,0]] += 1
					dataByClass[Y[i,0]].append(X[i,:])
	else:
		# If no optimization is required, the process is reduced to grouping the samples by their actual class labels.
		for i in range(n):
			dataByClass[Y[i,0]].append(X[i,:])
	# We transform the dictionary into a list that can be distributed using sc.parallelize
	rst = []
	for i in range(maxClasses+1):
		rst.append(dataByClass[i])
	return rst
	
if __name__ == "__main__":
	start = time.time()

	# Input
	args = sys.argv[1:]
	# S3 bucket
	bucket = args[0]
	# 2D hyperspectral image containing d bands x n pixels
	hsi = args[1]
	hsiFile = hsi + '.mat'
	# Vector of n labels
	labels = args[2]
	labelsFile = labels + '.mat'
	# Name of file to be saved
	save = args[3]
	# Reduced dimension
	r = int(args[4])
	# Optimization: 0 or 1
	optimize = int(args[5])
	# Maximum number of pixels per class
	if len(args)<7:
		nMax = 5000
	else:
		nMax = int(args[6])
	# number of nearest neighbors used
	if len(args)<8:
		kNN = 7
	else:
		kNN = int(args[7])
	# Type of metric in the embedding space
	# 'weighted' weighted eigenvectors (default), 'orthonormalized' orthonormalized or 'plain'
	if len(args)<9:
		metric = "weighted"
	else:
		metric = int(args[8])
	
	# Loading X: 2D matrix of d dimensions x n pixels
	X = numpy.array(scipy.io.loadmat(BytesIO(boto3.client('s3').get_object(Bucket=bucket, Key=hsiFile)['Body'].read()))[hsi])
	[d,n] = X.shape

	# Loading Y: array of n labels
	Y = numpy.array(scipy.io.loadmat(BytesIO(boto3.client('s3').get_object(Bucket=bucket, Key=labelsFile)['Body'].read()))[labels])
	
	endLoading = time.time()
	print(endLoading - start)
	
	data = grouping(X.T,Y,nMax,n,optimize)

	print(time.time() - endLoading)

	startWork = time.time()
	
	# Creating spark context  
	sc = SparkContext(conf=SparkConf().setAppName("Distributed opLFDA"))
	
	# Initializing tSb and tSw as accumulators, shared variables that can be accumulated
	tSb = sc.accumulator(numpy.zeros(shape=(d,d)), NdarrayAccumulatorParam())
	tSw = sc.accumulator(numpy.zeros(shape=(d,d)), NdarrayAccumulatorParam())

	# Create RDD from "data" matrix 
	rdd = sc.parallelize(data)
	
	# The result is (label in integer, [1st dimension, ..., dth dimension]) 
	rawData = rdd.map(lambda x : (numpy.matrix(x)))

	# Apply perClassTreatment to every class (// every entry in the RDD) in order to fill tSb and tSw
	processed = rawData.foreach(lambda x : PerClassTreatment(numpy.transpose(x).astype(float), n))
	
	print(time.time() - startWork)
	
	tSb = tSb.value
	tSw = tSw.value
	
	X1 = numpy.matrix(numpy.sum(X, axis=1).astype(double)).T
	tSb = tSb - numpy.dot(X1,X1.T) /n - tSw
	
	tSb = (tSb + tSb.T) / 2
	tSw = (tSw + tSw.T) / 2

	if(r==d):
		eigval, eigvec = scipy.linalg.eig(tSb, tSw)
	else:
		eigval, eigvec = scipy.sparse.linalg.eigs(A=tSb, M=tSw, k=r, which='LM')
	
	sort_eigval_index = numpy.argsort(eigval)
	eigval.sort()
	T0 = eigvec[:,sort_eigval_index[::-1]]

	if(metric == "weighted"):
		T = numpy.multiply(T0, numpy.tile(numpy.sqrt(eigval[::-1]),(d,1)))
	if(metric == "orthonormalized"):
		T = scipy.linalg.qr(T0)
		T = T[0]
	if(metric == "case"):
		T = T0

	Z = numpy.asarray(numpy.dot(T.T, X))

	endWork = time.time()
	print(endWork - startWork)
	
	startSave = time.time()
	scipy.io.savemat(save+'.mat', {save:Z})
	data = open(save+'.mat', 'rb')
	boto3.resource('s3').Bucket(bucket).put_object(Key=save+'.mat', Body=data)
	endSave = time.time()
	print(endSave-startSave)
	
	end = time.time()
	print(end - start)