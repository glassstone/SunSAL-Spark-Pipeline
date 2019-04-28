import transplant
from scipy.io import loadmat

class HyperSpectralClassifier:

    eng = None  #Matlab Engine
    hsi = None  #HyperSpectralImage

    def __init__(self, hyperspectral_image):
        self.hsi = hyperspectral_image
        self.eng = transplant.Matlab()

    def pca_nb(self, A, nb_pc):
        return self.eng.PCAnb(A.astype(float), nb_pc)

    def pca_pct(self, A, pct):
        return self.eng.PCAnb(A.astype(float), pct)

    def emap(self, A):
        return self.eng.EMAP(A)

    def dictionnary(self, X, y, pct):
        return self.eng.Dictionnary(X, y, pct)

    def sunsal(self, D, A):
        return self.eng.sunsal(D, A)

    def classify(self):
        return

    def fit(self):
        X = self.hsi.X
        y = self.hsi.y
        X_pc = self.pca_nb(X, 10)
        emap = X_pc     # self.emap(X_pc)
        D, edges, mask = self.dictionnary(emap, y, 50)
        emap = emap.reshape(emap.shape[2], -1)
        out = self.sunsal(D, emap)
        print("done")


class HyperSpectralImage:

    X = None    # HyperSpectral Image
    y = None    # Ground Truth

    def __init__(self, map_prefix, dict_entry_prefix):
        self.X = loadmat('Data/%s.mat' % map_prefix)[dict_entry_prefix]
        self.y = loadmat('Data/%s_gt.mat' % map_prefix)[dict_entry_prefix + '_gt']


if __name__ == '__main__':
    hsi = HyperSpectralImage('Salinas', 'salinas')
    classifier = HyperSpectralClassifier(hsi)
    classifier.fit()
