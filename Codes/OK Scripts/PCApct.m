function [r_im_3D, nbPC, V] = PCApct(im, pct)
% Authot: Rania ZAATOUR
%
% Université de Tunis El Manar, Institut Supérieur d'Informatique El Manar.
% LR16ES06 Laboratoire de recherche en Informatique, Modélisation et
% Traitement de l'Information et de la Connaissance (LIMTIC).
% 2 Rue Abou Raihane Bayrouni, 2080, l'Ariana, Tunisie.
% 
% PCApct reduces an image im to its first nbPC principle components keeping
% pct % of the total variance in the data.
%
% Input:
%    - im: 3D image (m x n x p)
%    - pct: percentage of the total variance to keep
%
% Output:
%    - r_im_3D: 3D reduced image (m x n x r)
%    - nbPC: number of kept principle components
%    - V: transformation matrix (r x p)

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

% Eigen-Decomposition
[v e] = eig(C);

% Arranging eigenvalues
e1=flipud(diag(e))';

% Search for PCs keeping percentage
cumulative_sum = (cumsum(e1/(ones(b,1)'*e1')*100))';
nbPC = find(cumulative_sum>=pct, 1);
fprintf('q %d, percentage %d \n', nbPC, cumulative_sum(nbPC));

% Find eigenvalues of covariance matrix
[V, D] = eigs(C, nbPC);

% Reduce the data
r_im_2D = V.'*I;

% Transform the 2D reduced image into 3D
r_im_3D = reshape(r_im_2D(1,:).', w, h, 1).';
for i=2:nbPC
    r_im_3D = cat(3, r_im_3D, reshape(r_im_2D(i,:).', w, h, 1).');
end