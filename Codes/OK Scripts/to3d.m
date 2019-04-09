function I3d = to3d(I, h, w)
% Author: Rania ZAATOUR
%
% Université de Tunis El Manar, Institut Supérieur d'Informatique El Manar.
% LR16ES06 Laboratoire de recherche en Informatique, Modélisation et
% Traitement de l'Information et de la Connaissance (LIMTIC).
% 2 Rue Abou Raihane Bayrouni, 2080, l'Ariana, Tunisie.
% 
% --------------
%
% to3d converts a 2D matrix (p x m*n) to a 3D matrix (m x n x p)

if (ndims(I) ~= 2)
    error('Input must be a 2D matrix.');
end

b = size(I,1);

I3d = reshape(I(1,:).', w, h, 1).'; 
for i=2:b
    I3d = cat(3, I3d, reshape(I(i,:).', w, h, 1).');
end