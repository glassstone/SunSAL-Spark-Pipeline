function EMAP = EMAP(reduced_im)
% Author: Rania ZAATOUR
%
% Université de Tunis El Manar, Institut Supérieur d'Informatique El Manar.
% LR16ES06 Laboratoire de recherche en Informatique, Modélisation et
% Traitement de l'Information et de la Connaissance (LIMTIC).
% 2 Rue Abou Raihane Bayrouni, 2080, l'Ariana, Tunisie.
% 
% --------------
%
% EMAP computs the EMAP of reduced_im using the following attributes and
% thresholds:
%     - Area: lambda in [100, 500, 1000, 5000]
%     - Standard deviation: lambda in [20, 30, 40, 50]
%
% Input :
%     - reduced_im: 3D image/reduced image
%
% Output:
%     - EMAP: 3D built profile

b1 = uint8(scaledata(reduced_im(:,:,1), 0, 255));
EAP_a = attribute_profile(b1, 'a', [100, 500, 1000, 5000]);
EAP_s = attribute_profile(b1, 's', [20, 30, 40, 50]);
for i=2:size(reduced_im,3)
    bi = uint8(scaledata(reduced_im(:,:,i), 0, 255));
    AP_a_pci = attribute_profile(bi, 'a', [100, 500, 1000, 5000]);
    EAP_a = cat(3, EAP_a, AP_a_pci);
    AP_s_pci = attribute_profile(bi, 's', [20, 30, 40, 50]);
    EAP_s = cat(3, EAP_s, AP_s_pci);
end
EMAP = cat(3, EAP_a, EAP_s);


% b1 = uint8(scaledata(reducedIm(:,:,1), 0, 255));
% EAP_a = attribute_profile(b1, 'a', [50:50:500]);
% EAP_s = attribute_profile(b1, 's', [0.025:0.025:0.2]);
% for i=2:size(reducedIm,3)
%     bi = uint8(scaledata(reducedIm(:,:,i), 0, 255));
%     AP_a_pci = attribute_profile(bi, 'a', [50:50:500]);
%     EAP_a = cat(3, EAP_a, AP_a_pci);
%     AP_s_pci = attribute_profile(bi, 's', [0.025:0.025:0.2]);
%     EAP_s = cat(3, EAP_s, AP_s_pci);
% end
% fprintf('EAP surface %d \n', size(EAP_a,3));
% fprintf('EAP écart %d \n', size(EAP_s,3));
% EMAP = cat(3, EAP_a, EAP_s);