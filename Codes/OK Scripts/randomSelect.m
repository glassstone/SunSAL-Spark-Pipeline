function [row col] = randomSelect(I, ndg)
% Auteur : ZA3
% Sélectionner aléatoirement un pixel de I ayant le niveau de gris ndg
% Entrées :
%     - I : image 2D en niveaux de gris dans ce cas
%     - ndg : niveau de gris en entier
% Sortie :
%     - row : la ligne du pixel
%     - col : la colonne du pixel
% Pour sélectionner ce pixel, il suffit d'appeler I(row,col)

ind = find(I(:) == ndg); 
% Les indices linéaires des pixels ayant ndg pour niveau de gris
% càd en parcourant la matrice (l'image) colonne par colonne

ind_selected = ind(randi(length(ind))); 
% Sélectionner aléatoirement l'un des indices
[row col] = ind2sub(size(I), ind_selected); 