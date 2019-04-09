function I2d = to2d(I)
% Author: Rania ZAATOUR
%
% Université de Tunis El Manar, Institut Supérieur d'Informatique El Manar.
% LR16ES06 Laboratoire de recherche en Informatique, Modélisation et
% Traitement de l'Information et de la Connaissance (LIMTIC).
% 2 Rue Abou Raihane Bayrouni, 2080, l'Ariana, Tunisie.
% 
% --------------
%
% to2d converts a 3D matrix (m x n x p) into a 2D matrix (p x m*n)

% if (ndims(I) ~= 3)
%     error('Input must be a 3D image.');
% end

[h, w, b] = size(I);

I2d = reshape(I(:,:,1)', h*w, 1).';
for i=2:b
    I2d = cat(1,I2d,reshape(I(:,:,i)', h*w, 1).');
end

return;