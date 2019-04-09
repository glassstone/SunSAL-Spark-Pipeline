function [rst, OA, AA, AR, accuracies] = Classification_SUnSAL(im, gt, emap, pct, indexes, edges)
% Author: Rania ZAATOUR
%
% Université de Tunis El Manar, Institut Supérieur d'Informatique El Manar.
% LR16ES06 Laboratoire de recherche en Informatique, Modélisation et
% Traitement de l'Information et de la Connaissance (LIMTIC).
% 2 Rue Abou Raihane Bayrouni, 2080, l'Ariana, Tunisie.
% 
% --------------
%
% Classification_SUnSAL classifies a given image using the sparse 
% representation-based classifier SUnSAL, with or without the use of the
% morphological profile EMAP, and assesses the efficiency of the obtained
% result.
%
% Input:
%    - im: 3D (reduced) image
%    - gt: 2D (m x n) groundtruth
%    - emap: 0 if without EMAP, else 1 
%    - pct: 0 if the dictionary is built according to given indexes and
%           edges, else the percentage of each class in the dictionary
%    - indexes: of pixels to build the dictionary
%    - edges: used by the sparse classifier to identify the class of each
%             classified pixel
%
% Output:
%    - rst: classification result
%    - OA: overall accuracy
%    - AA: average accuracy
%    - AR: average reliability
%    - accuracies: per-class accuracies

if emap==1
    im = EMAP (im, pctVariance);
end

if pct>0
    [D, edges] = Dictionnary(im, gt, pct);
else
    D = InitializedDictionnary(im, indexes);
end

rst = sunsalBOPBis(D, gt, im, edges);
[OA, AA, AR, accuracies] = ConfusionMatrix(gt, rst);