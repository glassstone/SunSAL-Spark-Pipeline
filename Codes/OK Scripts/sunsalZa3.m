function [imgOut] = sunsalZa3(D, gt, EMAP_im, edges)
opts.slowMode = true;

for i=1:size(EMAP_im,1)
    for j=1:size(EMAP_im,2)
            imgOut(i,j) = 0;
    end
end

% Parcourir l'EMAP de l'image qu'on souhaite classifier pixel par pixel
for i=1:size(EMAP_im,1)
    %fprintf('loading : %d from %d \n', i, size(gt,1));
    for j=1:size(EMAP_im,2)
        if(gt(i,j) ~= 0)
            Y = reshape(EMAP_im(i,j,:), size(EMAP_im,3), 1);
            lambda = 10e-5;
            [X,res_p,res_d] = sunsal(D, Y, 'lambda', lambda, 'POSITIVITY','yes');
            [a,b] = find(X == max(X), 1);
            imgOut(i,j) = find(edges>=a,1);
        end
    end
end