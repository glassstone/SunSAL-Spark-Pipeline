function [D, mask, edges] = DictionnaryNb(EMAP_im, gt, nbExemples)
% Auteur : ZA3
% G�n�rer un dictionnaire � partir de l'EMAP d'une image
% Entr�es :
%    - EMAP_im : EMAP de l'image qu'on souhaite classifier
%    - gt : l'image "ground truth"
%    - nbExamples : nombre d'exemples par classe
% Sortie :
%    - D : le dictionnaire ayant (nbExamples * nbClasses) pour nombre de
%    colonnes et le nombre d'images que g�n�re l'EMAP pour nombre de lignes
%    - mask : masque indiaquant les pixels utilis�s pour apprendre le
%    dictionnaire
% Pour s�lectionner ce pixel, il suffit d'appeler I(row,col)

% initialisation du masque � 0
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
        
        % Pour s'assurer de ne pas choisir le m�me pixel 2 fois.
        while mask(row,col) == 1;
            [row col] = randomSelect(gt, i);
        end
        mask(row,col) = 1;
        
        if((i == 1) && (j == 1))
            D = reshape(EMAP_im(row,col,:), size(EMAP_im(row,col,:),3), 1);
            % Ajout de l'EMAP du pixel d�fiini par (row, col) au
            % dictionnaire. Dans ce cas, c'est une initialisation.
            edges = nbExemples;
        else
            D = cat(2, D, reshape(EMAP_im(row,col,:), size(EMAP_im(row,col,:),3), 1));
            % Ajout de l'EMAP du pixel d�fiini par (row, col) au
            % dictionnaire.
            
        end
    end
end