function r_im_3D = PCAnb(im, r)
% Author: Rania ZAATOUR
%
% Université de Tunis El Manar, Institut Supérieur d'Informatique El Manar.
% LR16ES06 Laboratoire de recherche en Informatique, Modélisation et
% Traitement de l'Information et de la Connaissance (LIMTIC).
% 2 Rue Abou Raihane Bayrouni, 2080, l'Ariana, Tunisie.
% 
% PCAnb reduces an image im to its first r principle components.
%
% Input:
%    - im: 3D image (m x n x p)
%    - r: number of the first principle components to keep
%
% Output:
%    - r_im_3D: 3D reduced image (m x n x r)

if (ndims(im) ~= 3)
    error('Input must be a 3D image.');
end

[h, w, b] = size(im);
p = h*w;

% Transform the 3D image into 2D
I = reshape(im(:,:,1)', p, 1).';
for i=2:b
    I = cat(1,I,reshape(im(:,:,i)', p, 1).');
end

% Remove the data mean
u = mean(I.').';
I = I - repmat(u, 1, p);

% Compute covariance matrix
C = (I*I.')/p;

% Find eigenvalues of covariance matrix
[V, D] = eigs(C, r);

% Transform data
r_im_2D = V.'*I;

% Transform the 2D reduced image into 3D
r_im_3D = reshape(r_im_2D(1,:).', w, h, 1).';
for i=2:r
    r_im_3D = cat(3, r_im_3D, reshape(r_im_2D(i,:).', w, h, 1).');
end