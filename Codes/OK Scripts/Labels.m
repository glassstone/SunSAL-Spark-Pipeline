function l = Labels(gt)
% Author: Za3
% HSIto2d converts a 3D HSI (m x n x p) to a 2D matrix (p X m*n)

if (ndims(gt) ~= 2)
    error('Input image must be a 2D matrix.');
end

[h, w] = size(gt);

l = reshape(gt', h*w, 1);