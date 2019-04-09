function EMAP = EMAPwithoutPCA(I)
% Auteur : ZA3
% Calculer EMAP en se basant sur les attributs :
%     - Surface et lambda variant de 50 à 500 avec un pas de 50
%     - Ecart-type et lambda variant de 2.5% à 20% avec un pas de 2.5%
% Entrées :
%     - I : image 2D ou 3D
%     - PC : nombre de composantes principales à garder
im = uint8(scaledata(I, 0, 255));
EAP_a = attribute_profile(im(:,:,1), 'a', [50:50:500]);
EAP_s = attribute_profile(im(:,:,1), 's', [0.025:0.025:0.2]);
for i=2:size(I,3)
    AP_a_pci = attribute_profile(im(:,:,i), 'a', [50:50:500]);
    EAP_a = cat(3, EAP_a, AP_a_pci);
    AP_s_pci = attribute_profile(im(:,:,i), 's', [0.025:0.025:0.2]);
    EAP_s = cat(3, EAP_s, AP_s_pci);
end
fprintf('EAP surface %d \n', size(EAP_a,3));
fprintf('EAP écart %d \n', size(EAP_s,3));
EMAP = cat(3, EAP_a, EAP_s);
end