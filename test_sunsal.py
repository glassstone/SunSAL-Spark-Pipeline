import numpy as np

from scipy.io import loadmat

MAP_PREFIX = "Salinas"
DICT_ENTRY_PREFIX = "salinas" # Usually It's the map name camelcased

data = loadmat('Data/%s.mat'%(MAP_PREFIX))[DICT_ENTRY_PREFIX]
data_gt = loadmat('Data/%s_gt.mat'%(MAP_PREFIX))[DICT_ENTRY_PREFIX+'_gt']

length, width, channel = data.shape

from sklearn.preprocessing import OneHotEncoder

X = data.reshape(-1, channel)
enc = OneHotEncoder(sparse=False)
y = enc.fit_transform(data_gt.reshape(-1, 1))

def sample_data(X, y, p=0.001):
    total_size = X.shape[0]
    import math
    sample_size = math.floor(total_size * p)
    idxs = np.random.randint(total_size, size=sample_size)
    return X[idxs], y[idxs]

X_sample, y_sample = sample_data(X, y)

from sunsal import SunSALClassifier

clf = SunSALClassifier()
clf.fit(X_sample, y_sample)
