function EMAP = EMAPwithPCA(I, r)
% Auteur : ZA3
% Calculer EMAP en se basant sur les attributs :
%     - Surface et lambda variant de 50 à 500 avec un pas de 50
%     - Ecart-type et lambda variant de 2.5% à 20% avec un pas de 2.5%
% Entrées :
%     - I : image 2D ou 3D
%     - PC : nombre de composantes principales à garder
    
if (ndims(I) == 3)
    I2D = hyperConvert2d(I);
    [pct] = simplePCA(I2D, r);
    pc1 = uint8(scaledata(hyperConvert3d(pct(1,:), size(I,1), size(I,2), 1), 0, 255));
    EAP_a = attribute_profile(pc1, 'a', [50:50:500]);
    EAP_s = attribute_profile(pc1, 's', [0.025:0.025:0.2]);
    if (r>=2)
        for i=2:r
            pci = uint8(scaledata(hyperConvert3d(pct(i,:), size(I,1), size(I,2), 1), 0, 255));
            AP_a_pci = attribute_profile(pci, 'a', [50:50:500]);
            EAP_a = cat(3, EAP_a, AP_a_pci);
            AP_s_pci = attribute_profile(pci, 's', [0.025:0.025:0.2]);
            EAP_s = cat(3, EAP_s, AP_s_pci);
        end
    end
else
    pc1 = im2uint16(I);
    EAP_a = attribute_profile(pc1, 'a', [50:50:500]);
    EAP_s = attribute_profile(pc1, 's', [0.025:0.025:0.2]);
    if (r>=2)
        for i=2:PC
            pci = im2uint16(I);
            AP_a_pci = attribute_profile(pci, 'a', [50:50:500]);
            EAP_a = cat(3, EAP_a, AP_a_pci);
            AP_s_pci = attribute_profile(pci, 's', [0.025:0.025:0.2]);
            EAP_s = cat(3, EAP_s, AP_s_pci);
        end
    end
end
fprintf('EAP surface %d \n', size(EAP_a,3));
fprintf('EAP écart %d \n', size(EAP_s,3));
EMAP = cat(3, EAP_a, EAP_s);