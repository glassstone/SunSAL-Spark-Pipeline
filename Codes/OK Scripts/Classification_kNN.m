function [rst, OA, AA, AR, accuracies] = Classification_kNN(im, gt, emap, pct, indexes)
% Author: Rania ZAATOUR
%
% Université de Tunis El Manar, Institut Supérieur d'Informatique El Manar.
% LR16ES06 Laboratoire de recherche en Informatique, Modélisation et
% Traitement de l'Information et de la Connaissance (LIMTIC).
% 2 Rue Abou Raihane Bayrouni, 2080, l'Ariana, Tunisie.
%
% --------------
%
% Classification_kNN classifies a given image using the k-NN classifier
% with or without the use of the morphological profile EMAP, and assesses
% the efficiency of the obtained result.
%
% Input:
%    - im: 3D m x n x p (reduced) image
%    - gt: 2D (m x n) groundtruth
%    - emap: 0 if without EMAP, else 1
%    - pct: 0 if the model is learnt using samples of given indexes, else
%           the percentage of each class to use in the learning process
%    - indexes: of pixels to learn the model
%
% Output:
%    - rst: classification result
%    - OA: overall accuracy
%    - AA: average accuracy
%    - AR: average reliability
%    - accuracies: per-class accuracies

if emap==1
    im = EMAP(im);
end

[w, h, d] = size(im);

if pct>0
    indexes = DictionnaryInitialization(gt, pct);
end

nb_indexes = size(indexes,2);
X = zeros(nb_indexes,d);
for i = 1:nb_indexes
    X(i,:) =  reshape(im(indexes(1,i),indexes(2,i),:),1,d);
end
Y = zeros(nb_indexes,1);
for i =1:size(indexes,2)
    Y(i) =  gt(indexes(1,i),indexes(2,i))';
end

% learn the model
model = fitcknn(X,Y);

% Predicts the labels of the given data based on the model learnt by k-NN
rst = predict(model,to2d(im)');
rst = to3d(rst',w,h);

for i=1:w
    for j=1:h
        if(gt(i,j)==0)
            rst(i,j)=0;
        end
    end
end

[OA, AA, AR, accuracies] = ConfusionMatrix(gt, rst);