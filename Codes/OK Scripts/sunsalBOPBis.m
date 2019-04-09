function [imgOut] = sunsalBOPBis(D, gt, EMAP_im, edges)
opts.slowMode = true;

for i=1:size(EMAP_im,1)
    for j=1:size(EMAP_im,2)
        imgOut(i,j) = 0;
    end
end
lambda = 10e-5;
mu_AL = 0.01;
mu = 10*mean(lambda(:)) + mu_AL;
mus=[];
[UF,SF] = svd(double(D)'*double(D));
sF = diag(SF);
limit=10;
mus(1)=mu;
IF{1}=UF*diag(1./(sF+mus(1)))*UF';
for i=1:limit
    mus(i+1)=mu*(2^i);
    IF{i+1}=UF*diag(1./(sF+mus(i+1)))*UF';
end
for i=1:limit
    mus(i+1+limit)=mu/(2^i);
    IF{i+1+limit}=UF*diag(1./(sF+mus(i+1+limit)))*UF';
end

for i=1:size(EMAP_im,1)
    %     fprintf('loading : %d from %d \n', i, size(gt,1));
    for j=1:size(EMAP_im,2)
        if(gt(i,j)~=0)
            Y = reshape(EMAP_im(i,j,:), size(EMAP_im,3), 1);
            [X,res_p,res_d] = sunsalOp(D,IF,mus, Y, 'lambda', lambda, 'POSITIVITY','yes');
            [a,b] = find(X == max(X), 1);
            imgOut(i,j) = find(edges>=a,1);
        end
    end
end