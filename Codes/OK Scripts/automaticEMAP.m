function EMAP = automaticEMAP(im)
% Author: Rania ZAATOUR
%
% Université de Tunis El Manar, Institut Supérieur d'Informatique El Manar.
% LR16ES06 Laboratoire de recherche en Informatique, Modélisation et
% Traitement de l'Information et de la Connaissance (LIMTIC).
% 2 Rue Abou Raihane Bayrouni, 2080, l'Ariana, Tunisie.
% 
% --------------
%
% automaticEMAP computes the EMAP with automatic thresholds.
%
% Input:
%     - im: 3D (reduced) image
%
% Output:
%     - EMAP: built profile
%
% Morphological attribute profile:
%
%    -------------------------Automatic thresholds-------------------------
%    [PROFILE SL] = morphological_attribute_profile(I, T, A, MET, M ,S)
%    [PROFILE SL] = morphological_attribute_profile(I, T, A, MET, M ,S, F)
%    [PROFILE SL] = morphological_attribute_profile(I, T, A, MET, M ,S, F, P)
%
%  INPUT
%    ***************************Mandatory parameters**************************
%      I:  2D input image. Data type supported: uint8, uint16.
%      T:  Tree representation. String.
%          Trees supported:
%              Min-tree:       'min-tree';
%              Max-tree:       'max_tree';
%              Tree of shapes: 'ToS';
%      A:  Attribute type. String.
%          Attribute supported:
%              Area: 'a', 'area';
%              Length of the diagonal of the bounding box: 'd', 'diagonal';
%              Moment of inertia: 'i', 'inertia';
%              Standard deviation: 's', 'std'.
%              Variance: 'v', 'variance';
%              Sharpness: 'shp', 'sharpness';
%              Rectangularity: 'r', 'rectangularity';
%      MET:  Method for selecting the thresholds. String.
%              Either 'manual' or 'automatic'
%    -------------------------MET='automatic'-------------------------
%      M:  Measure. String.
%          Measure supported:
%              Sum of the gray levels: 'grayvalues';
%              Sum of the number of pixels: 'pixels';
%              Sum of the number of regions: 'regions';
%      S:  Strategy.
%              Either String ('error') or Scalar (>0) .
%      N:  Answer of the decison. Scalar.
%    ***************************Optional parameters**************************
%      F:  Filtering rule. String.
%          Rules supported:
%              Min: 'min';
%              Max: 'max';
%              Direct: 'direct'(default for attributes 'a', 'd').
%              Sub: 'sub' (default for attributes 'i', 's').
%      P:  Print on screen. String. Either 'off' (default) or 'on'.
%
%  OUTPUT
%      PROFILE: Array of 2D images of the same data type of the input image.
%                 If 'min-tree' then PROFILE = Thickening profile ;
%                 If 'max_tree' then PROFILE = Thinning profile ;
%                 If 'ToS'      then PROFILE = Self-dual profile ;
%      SL:      Selected values of lambda. Array of double.

f1 = uint8(scaledata(im(:,:,1), 0, 255));
[AP_a_min_raw_f1, SL_a_min] = morphological_attribute_profile(f1, 'min-tree', 'a', 'automatic', 'pixels', 'error');
EAP_a = AP_a_min_raw_f1(:,:,size(AP_a_min_raw_f1,3));
if size(AP_a_min_raw_f1,3)-1>1
    for i=(size(AP_a_min_raw_f1,3)-1):-1:2
        EAP_a = cat(3, EAP_a, AP_a_min_raw_f1(:,:,i));
    end
end
[AP_a_max_f1, SL_a_max] = morphological_attribute_profile(f1, 'max-tree', 'a', 'automatic', 'pixels', 'error');
EAP_a = cat(3, EAP_a, AP_a_max_f1);

[AP_s_min_raw_f1, SL_s_min] = morphological_attribute_profile(f1, 'min-tree', 's', 'automatic', 'pixels', 'error');
EAP_s = AP_s_min_raw_f1(:,:,size(AP_s_min_raw_f1,3));
if size(AP_s_min_raw_f1,3)-1>1
    for i=(size(AP_s_min_raw_f1,3)-1):-1:2
        EAP_s = cat(3, EAP_s, AP_s_min_raw_f1(:,:,i));
    end
end
[AP_s_max_f1, SL_s_max] = morphological_attribute_profile(f1, 'max-tree', 's', 'automatic', 'pixels', 'error');
EAP_s = cat(3, EAP_s, AP_s_max_f1);

for i=2:size(im,3)
    fi = uint8(scaledata(im(:,:,i), 0, 255)); 
    
    [AP_a_min_raw_fi, SL_a_min] = morphological_attribute_profile(fi, 'min-tree', 'a', 'automatic', 'pixels', 'error');
    AP_a_fi = AP_a_min_raw_fi(:,:,size(AP_a_min_raw_fi,3));
    if size(AP_a_min_raw_fi,3)-1>1
        for i=(size(AP_a_min_raw_fi,3)-1):-1:2
            AP_a_fi = cat(3, AP_a_fi, AP_a_min_raw_fi(:,:,i));
        end
    end
    [AP_a_max_fi, SL_a_max] = morphological_attribute_profile(fi, 'max-tree', 'a', 'automatic', 'pixels', 'error');
    AP_a_fi = cat(3, AP_a_fi, AP_a_max_fi);
    EAP_a = cat(3, EAP_a, AP_a_fi);
    
    [AP_s_min_raw_fi, SL_s_min] = morphological_attribute_profile(fi, 'min-tree', 's', 'automatic', 'pixels', 'error');
    AP_s_fi = AP_s_min_raw_fi(:,:,size(AP_s_min_raw_fi,3));
    if size(AP_s_min_raw_fi,3)-1>1
        for i=(size(AP_s_min_raw_fi,3)-1):-1:2
            AP_s_fi = cat(3, AP_s_fi, AP_s_min_raw_fi(:,:,i));
        end
    end
    [AP_s_max_fi, SL_s_max] = morphological_attribute_profile(fi, 'max-tree', 's', 'automatic', 'pixels', 'error');
    AP_s_fi = cat(3, AP_s_fi, AP_s_max_fi);
    EAP_s = cat(3, EAP_s, AP_s_fi);
    
end
EMAP = cat(3, EAP_a, EAP_s);%, ESDAP_s);%, ESDAP_i, ESDAP_v, ESDAP_p, ESDAP_r, ESDAP_d);