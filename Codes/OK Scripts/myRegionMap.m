function [RM, nbRegions] = myRegionMap(im)
% Author: Rania ZAATOUR
%
% Université de Tunis El Manar, Institut Supérieur d'Informatique El Manar.
% LR16ES06 Laboratoire de recherche en Informatique, Modélisation et
% Traitement de l'Information et de la Connaissance (LIMTIC).
% 2 Rue Abou Raihane Bayrouni, 2080, l'Ariana, Tunisie.
% 
% --------------
%
% myRegionMap genrates a region from based on the original HSI reduced with
% PCA to the first PCs keeping 98% of the total variance.
%
% Input:
%    - im: 3D image (m x n x p)
%
% Output:
%    - RM region map
%    - nbRegions: number of obtained regions

% reduce the image using PCA to the first PCs keeping 98% of the variance
r_pca = PCApct(im, 99);

% Amplitude Fusion
% for each i,j, compute the square root of the squares of i,j's values
% along the bands
fusion = zeros(size(r_pca,1),size(r_pca,2));
for i=1:size(r_pca,1)
    for j=1:size(r_pca,2)
        for k=1:size(r_pca,3)
            fusion(i,j) = fusion(i,j) + r_pca(i,j,k)^2;       
        end
        fusion(i,j) = sqrt(fusion(i,j));
    end
end

% Normalization (from 0 to 1)
nomalized = mat2gray(fusion);

% OTSU: automatic thresholding
thresholded = nomalized > graythresh(nomalized);

% Mathematical Morphology (To customize)
morph_processed = bwmorph(thresholded,'erode');
morph_processed = bwmorph(morph_processed,'clean');
morph_processed = bwmorph(morph_processed,'dilate');
morph_processed = bwmorph(morph_processed,'clean');

% Labelization 
[RM, nbRegions] = bwlabel(morph_processed, 4);