function [indexes, edges] = DictionnaryInitializationByNb(gt, nbExamples)
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
        edges = cat(1, edges, nbExamples + edges(length(edges)));
    end
    for j=1:nbExamples % nombre d'exmples par classe
        [row col] = randomSelect(gt, i);
        
        % Pour s'assurer de ne pas choisir le même pixel 2 fois.
        while mask(row,col) == 1;
            [row col] = randomSelect(gt, i);
        end
        mask(row,col) = 1;
        
        if((i == 1) && (j == 1))
            indexes(1,1)=row;
            indexes(2,1)=col;
            edges = nbExamples;
        else
            indexes(1,size(indexes,2)+1)=row;
            indexes(2,size(indexes,2))=col;
        end
    end
end