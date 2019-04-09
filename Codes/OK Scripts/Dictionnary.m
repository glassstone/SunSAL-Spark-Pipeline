function [D, edges, mask] = Dictionnary(input, gt, pourcentage)
% Author: Rania ZAATOUR
%
% Université de Tunis El Manar, Institut Supérieur d'Informatique El Manar.
% LR16ES06 Laboratoire de recherche en Informatique, Modélisation et
% Traitement de l'Information et de la Connaissance (LIMTIC).
% 2 Rue Abou Raihane Bayrouni, 2080, l'Ariana, Tunisie.
% 
% --------------
%
% Dictionnary builds the dictionary based on the classes in the ground
% truth and on the given percentage.
%
% Input:
%    - input: 3D (reduced) image or its EMAP
%    - gt: groundtruth
%    - percentage: percentage of each class in the dictionary
%
% Output:
%    - D: the built dictionary
%    - edges: limit of each class in the dictionary
%    - mask: of the pixels used to build the dictionary

% initialisation du masque à 0
for i=1:size(gt,1)
    for j=1:size(gt,2)
        mask(i,j) = 0;
    end
end

for i=1:max(gt(:)) % parcourir les classes
    jmax = round(length(find(gt(:) == i))*(pourcentage/100));
    if(i>1)
        edges = cat(1, edges, jmax + edges(length(edges)));
    end
    for j=1:jmax % nombre d'exmples par classe
        [row col] = randomSelect(gt, i);
        
        % Pour s'assurer de ne pas choisir le même pixel 2 fois.
        while mask(row,col) == 1;
            [row col] = randomSelect(gt, i);
        end
        mask(row,col) = 1;
        
        if((i == 1) && (j == 1))
            D = reshape(input(row,col,:), size(input(row,col,:),3), 1);
            % Ajout de l'EMAP du pixel défiini par (row, col) au
            % dictionnaire. Dans ce cas, c'est une initialisation.
            edges = jmax;
        else
            D = cat(2, D, reshape(input(row,col,:), size(input(row,col,:),3), 1));
            % Ajout de l'EMAP du pixel défiini par (row, col) au
            % dictionnaire.
            
        end
    end
end