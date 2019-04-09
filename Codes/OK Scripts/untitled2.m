
data = load('../../Data/Salinas.mat');
salinas = data.salinas; 

salinas_reduced = PCAnb(salinas, 5)

salinas_emap = EMAP(salinas_reduced)
%% Uncomment to show image
% img = load('../../Data/Salinas_gt.mat').salinas_gt
% figure(1);
% imshow(img, []);
% 
% %