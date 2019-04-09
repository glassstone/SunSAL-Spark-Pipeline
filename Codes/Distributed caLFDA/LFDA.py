from __future__ import division
from itertools import compress
from decimal import *
import scipy.io
import scipy.linalg
import scipy.sparse
import numpy
import time
import sys

# Input
args = sys.argv[1:]
# 2D hyperspectral image containing d bands x n pixels
hsi = args[0]
hsiFile = hsi + '.mat'
# Vector of n labels
labels = args[1]
labelsFile = labels + '.mat'
# Name of file to be saved
save = args[2]
# Reduced dimension
r = int(args[3])
# Optimization: 0 or 1
optimize = int(args[4])
# Maximum number of pixels per class
if len(args)<6:
	MAX_PER_CLASS = 5000
else:
	MAX_PER_CLASS = int(args[5])
# number of nearest neighbors used
if len(args)<7:
	kNN = 7
else:
	kNN = int(args[6])
# Type of metric in the embedding space ('weighted' weighted eigenvectors (default), 'orthonormalized' orthonormalized or 'plain')
if len(args)<8:
	metric = "weighted"
else:
	metric = int(args[7])

# load X: 2D matrix of d bands x n pixels
I = scipy.io.loadmat(hsiFile)[hsi]
[d,n] = I.shape
X = numpy.matrix(numpy.zeros(shape=(d, n)))
X[:] = I[:]

# load labels array: 1 x n pixels
Y = numpy.transpose(scipy.io.loadmat(labelsFile)[labels])

start = time.time()

# Initialize d x d matrices of between classes and within classes variances to zero
tSb = numpy.zeros(shape=(d,d))
tSw = numpy.zeros(shape=(d,d))

# Try to reduce memory consumption
if(optimize == 1):
	classes = {}
	maxClasses = numpy.amax(Y) + 1
	classes[maxClasses] = 0
	for i in range(n):
		if Y[0,i] not in classes:
			classes[Y[0,i]] = 1
		else:
			if classes[Y[0,i]] == MAX_PER_CLASS:
				if classes[maxClasses] == MAX_PER_CLASS:
					maxClasses += 1
					classes[maxClasses] = 0
				classes[maxClasses] += 1
				Y[0,i] = maxClasses
			else:
				classes[Y[0,i]] += 1

for c in numpy.unique(Y):
	#print(c)
	Xc = X[:,numpy.argwhere(Y==c)[:, 1]]
	nc = Xc.shape[1]
	#print(nc)
	Xc2 = numpy.sum(numpy.power(Xc, 2), axis=0)
	# start of intervention
	distance2 = numpy.tile(Xc2,(nc,1))
	distance2 = distance2 + numpy.tile(Xc2.T,(1,nc))
	distance2 = numpy.array(distance2 - 2 * Xc.T * Xc)
	Sorted = numpy.zeros(shape=(distance2.shape[0], distance2.shape[1]))
	Sorted[:] = distance2[:]
	Sorted.sort(0)
	kNNdist2 = numpy.matrix(Sorted[kNN,:])
	sigma = numpy.sqrt(kNNdist2)
	localscale = numpy.array(sigma.T * sigma)
	flag = localscale!=0
	A = numpy.zeros(shape=(nc,nc))
	A[flag] = numpy.exp(-distance2[flag] / localscale[flag])
	Xc1 = numpy.sum(Xc, axis=1)
	G = Xc * numpy.multiply(numpy.tile(numpy.sum(numpy.matrix(A), axis=1),(1, d)), Xc.T) - Xc * A * Xc.T
	tSb = tSb + G/n + Xc * Xc.T * (1-nc/n) + Xc1 * Xc1.T / n
	tSw = tSw + G/nc

X1 = numpy.sum(X, axis=1)
tSb = tSb - X1 * X1.T /n -tSw

tSb = (tSb + tSb.T) / 2
tSw = (tSw + tSw.T) / 2

if(r==d):
	eigval, eigvec = scipy.linalg.eig(tSb, tSw)
else:
	eigval, eigvec = scipy.sparse.linalg.eigs(A=tSb, M=tSw, k=r, which='LM')


sort_eigval_index = numpy.argsort(eigval)
eigval.sort()
#○print(eigval.astype(numpy.dtype('Float64')))
T0 = eigvec[:,sort_eigval_index[::-1]]

if(metric == "weighted"):
	T = numpy.multiply(T0, numpy.tile(numpy.sqrt(eigval[::-1]),(d,1)))
if(metric == "orthonormalized"):
	T = scipy.linalg.qr(T0)
	T = T[0]
if(metric == "case"):
	T = T0

Z = T.T * X

scipy.io.savemat(save+'.mat', {save:Z})

end = time.time()

print(end-start)
