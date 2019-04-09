function [row col] = randomSelect(I, ndg)
% Auteur : ZA3
% S�lectionner al�atoirement un pixel de I ayant le niveau de gris ndg
% Entr�es :
%     - I : image 2D en niveaux de gris dans ce cas
%     - ndg : niveau de gris en entier
% Sortie :
%     - row : la ligne du pixel
%     - col : la colonne du pixel
% Pour s�lectionner ce pixel, il suffit d'appeler I(row,col)

ind = find(I(:) == ndg); 
% Les indices lin�aires des pixels ayant ndg pour niveau de gris
% c�d en parcourant la matrice (l'image) colonne par colonne

ind_selected = ind(randi(length(ind))); 
% S�lectionner al�atoirement l'un des indices
[row col] = ind2sub(size(I), ind_selected); 