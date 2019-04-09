function [OA, AA, AR, accuracies] = ConfusionMatrix(gt, rst)
% Author: Rania ZAATOUR
%
% Université de Tunis El Manar, Institut Supérieur d'Informatique El Manar.
% LR16ES06 Laboratoire de recherche en Informatique, Modélisation et
% Traitement de l'Information et de la Connaissance (LIMTIC).
% 2 Rue Abou Raihane Bayrouni, 2080, l'Ariana, Tunisie.
% 
% --------------
%
% ConfusionMatrix assesses the efficiency of a classification.
%
% Input:
%    - gt: 2D (m x n) groundtruth
%    - rst: 2D (m x n) classification result
%
% Output:
%    - OA: overall accuracy
%    - AA: average accuracy
%    - AR: average reliability
%    - accuracies: per-class accuracies

rel = [];Acc = []; 
for i=1:max(gt(:))
    for j=1:max(gt(:))
        matrixNbPixels(i,j) = 0;
        matrixPourcentage(i,j) = 0;
    end
end
        
for i=1:max(gt(:))
    ind_gt = find(gt(:) == i); 
    for ind_selected=1:length(ind_gt)
        [row col] = ind2sub(size(gt), ind_gt(ind_selected));
        if(rst(row,col) ~= 0)
            matrixNbPixels(i,rst(row,col)) = matrixNbPixels(i,rst(row,col)) + 1;
        end
    end
end

for i=1:size(matrixNbPixels,1)
    for j=1:size(matrixNbPixels,2)
        total = length(find(gt(:) == i));
        matrixPourcentage(i,j) = (matrixNbPixels(i,j)*100)/total;
    end
end

Acc = diag(matrixPourcentage); 
AA = trace(matrixPourcentage)/max(gt(:));
OA = trace(matrixNbPixels)/sum(matrixNbPixels(:))*100;

for i=1:size(matrixNbPixels,2) 
    rel(i) = (matrixNbPixels(i,i)/sum(matrixNbPixels(:,i)))*100;
end
AR = (sum(rel)/size(matrixNbPixels, 1));  
accuracies = diag(matrixPourcentage)';