function [D, mask, edges] = DictionnaryNb(EMAP_im, gt, nbExemples)
% Auteur : ZA3
% Générer un dictionnaire à partir de l'EMAP d'une image
% Entrées :
%    - EMAP_im : EMAP de l'image qu'on souhaite classifier
%    - gt : l'image "ground truth"
%    - nbExamples : nombre d'exemples par classe
% Sortie :
%    - D : le dictionnaire ayant (nbExamples * nbClasses) pour nombre de
%    colonnes et le nombre d'images que génère l'EMAP pour nombre de lignes
%    - mask : masque indiaquant les pixels utilisés pour apprendre le
%    dictionnaire
% Pour sélectionner ce pixel, il suffit d'appeler I(row,col)

% initialisation du masque à 0
for i=1:size(gt,1)
    for j=1:size(gt,2)
        mask(i,j) = 0;
    end
end

for i=1:max(gt(:)) % parcourir les classes
    if(i>1)
        edges = cat(1, edges, nbExemples + edges(length(edges)));
    end
    for j=1:nbExemples % nombre d'exmples par classe
        [row col] = randomSelect(gt, i);
        
        % Pour s'assurer de ne pas choisir le même pixel 2 fois.
        while mask(row,col) == 1;
            [row col] = randomSelect(gt, i);
        end
        mask(row,col) = 1;
        
        if((i == 1) && (j == 1))
            D = reshape(EMAP_im(row,col,:), size(EMAP_im(row,col,:),3), 1);
            % Ajout de l'EMAP du pixel défiini par (row, col) au
            % dictionnaire. Dans ce cas, c'est une initialisation.
            edges = nbExemples;
        else
            D = cat(2, D, reshape(EMAP_im(row,col,:), size(EMAP_im(row,col,:),3), 1));
            % Ajout de l'EMAP du pixel défiini par (row, col) au
            % dictionnaire.
            
        end
    end
end