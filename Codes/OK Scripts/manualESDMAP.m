function ESDMAP = manualESDMAP(reducedIm)
% Auteur : ZA3
% Compute Extended Self Dual Multi-Attribute Profile ESDMAP with manual
% thresholds
% Input:
%     - I : 3D reduced image
%
% Morphological attribute profile: 
% 
%    -------------------------Manual thresholds----------------------------
%    PROFILE = morphological_attribute_profile(I, T, A, MET, L)
%    PROFILE = morphological_attribute_profile(I, T, A, MET, L, F)
%    PROFILE = morphological_attribute_profile(I, T, A, MET, L, F, P)
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
%    -------------------------MET='manual'----------------------------
%      L:  Values of lambda. Array of double.
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

f1 = uint8(scaledata(reducedIm(:,:,1), 0, 255));
ESDAP_a = morphological_attribute_profile(f1, 'ToS', 'a', 'manual', [50:50:500]);
%ESDAP_a = morphological_attribute_profile(f1, 'ToS', 'a', 'manual', [20:20:200]);
ESDAP_s = morphological_attribute_profile(f1, 'ToS', 's', 'manual', [0.025:0.025:0.2]);
for i=2:size(reducedIm,3)
    fi = uint8(scaledata(reducedIm(:,:,i), 0, 255));
    SDAP_a_pci = morphological_attribute_profile(fi, 'ToS', 'a', 'manual', [50:50:500]);
    %SDAP_a_pci = morphological_attribute_profile(fi, 'ToS', 'a', 'manual', [20:20:200]);
    ESDAP_a = cat(3, ESDAP_a, SDAP_a_pci);
    SDAP_s_pci = morphological_attribute_profile(fi, 'ToS', 's', 'manual', [0.025:0.025:0.2]);
    ESDAP_s = cat(3, ESDAP_s, SDAP_s_pci);
end

% ESDAP_a = morphological_attribute_profile(f1, 'ToS', 'a', 'manual', [50,100,500,2000]);
% ESDAP_s = morphological_attribute_profile(f1, 'ToS', 's', 'manual', [5:5:20]);
% for i=2:size(reducedIm,3)
%     fi = uint8(scaledata(reducedIm(:,:,i), 0, 255));
%     SDAP_a_pci = morphological_attribute_profile(fi, 'ToS', 'a', 'manual', [50,100,500,2000]);
%     ESDAP_a = cat(3, ESDAP_a, SDAP_a_pci);
%     SDAP_s_pci = morphological_attribute_profile(fi, 'ToS', 's', 'manual', [5:5:20]);
%     ESDAP_s = cat(3, ESDAP_s, SDAP_s_pci);
% end

fprintf('ESDAP surface %d \n', size(ESDAP_a,3));
fprintf('ESDAP écart %d \n', size(ESDAP_s,3));
ESDMAP = cat(3, ESDAP_a, ESDAP_s);