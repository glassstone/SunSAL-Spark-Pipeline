from __future__ import division
from itertools import compress
from io import BytesIO
from decimal import *
import scipy.io
import scipy.linalg
import scipy.sparse
import numpy
# import boto3
import time
import sys

# Input
args = sys.argv[1:]
# S3 bucket
bucket = args[0]
# 2D hyperspectral image containing d bands x n pixels
hsi1 = args[1]
hsiFile1 = hsi1 + '.mat'
# Vector of n labels
labels1 = args[2]
labelsFile1 = labels1 + '.mat'
# 2D hyperspectral image containing d bands x n pixels
hsi2 = args[3]
hsiFile2 = hsi2 + '.mat'
# Vector of n labels
labels2 = args[4]
labelsFile2 = labels2 + '.mat'
# Name of file to be saved
save = args[5]
saveLabels = args[6]

# Loading X: 2D matrix of d dimensions x n pixels
# X1 = numpy.array(scipy.io.loadmat(BytesIO(boto3.client('s3').get_object(Bucket=bucket, Key=hsiFile1)['Body'].read()))[hsi1])
# X2 = numpy.array(scipy.io.loadmat(BytesIO(boto3.client('s3').get_object(Bucket=bucket, Key=hsiFile2)['Body'].read()))[hsi2])
X1 = numpy.array(scipy.io.loadmat(hsiFile1)[hsi1])
X2 = numpy.array(scipy.io.loadmat(hsiFile2)[hsi2])

# Loading Y: array of n labels
# Y1 = numpy.array(scipy.io.loadmat(BytesIO(boto3.client('s3').get_object(Bucket=bucket, Key=labelsFile1)['Body'].read()))[labels1])
# Y2 = numpy.array(scipy.io.loadmat(BytesIO(boto3.client('s3').get_object(Bucket=bucket, Key=labelsFile2)['Body'].read()))[labels2])
Y1 = numpy.array(scipy.io.loadmat(labelsFile1)[labels1])
Y2 = numpy.array(scipy.io.loadmat(labelsFile2)[labels2])

Xrst = numpy.concatenate((X1,X2), axis=1)
Yrst = numpy.concatenate((Y1,Y2), axis=0)

scipy.io.savemat(save+'.mat', {save:Xrst})
# data = open(save+'.mat', 'rb')
# boto3.resource('s3').Bucket(bucket).put_object(Key=save+'.mat', Body=data)

scipy.io.savemat(saveLabels+'.mat', {saveLabels:Yrst})
# data = open(saveLabels+'.mat', 'rb')
# boto3.resource('s3').Bucket(bucket).put_object(Key=saveLabels+'.mat', Body=data)