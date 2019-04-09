function ESDMAP = automaticESDMAP(reducedIm)
% Author: Rania ZAATOUR
%
% Université de Tunis El Manar, Institut Supérieur d'Informatique El Manar.
% LR16ES06 Laboratoire de recherche en Informatique, Modélisation et
% Traitement de l'Information et de la Connaissance (LIMTIC).
% 2 Rue Abou Raihane Bayrouni, 2080, l'Ariana, Tunisie.
% 
% --------------
%
% automaticESDMAP compute the ESDMAP with automatic thresholds
%
% Input:
%     - I: 3D (reduced) image
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

f1 = uint8(scaledata(reducedIm(:,:,1), 0, 255));
[ESDAP_a, SL_a] = morphological_attribute_profile(f1, 'ToS', 'a', 'automatic', 'pixels', 'error');
%SL_a
[ESDAP_s, SL_s] = morphological_attribute_profile(f1, 'ToS', 's', 'automatic', 'pixels', 'error');
%SL_s
%ESDAP_i = morphological_attribute_profile(f1, 'ToS', 'i', 'automatic', 'grayvalues', 'error');
%ESDAP_v = morphological_attribute_profile(f1, 'ToS', 'v', 'automatic', 'grayvalues', 'error');
%ESDAP_p = morphological_attribute_profile(f1, 'ToS', 'shp', 'automatic', 'grayvalues', 'error');
%ESDAP_r = morphological_attribute_profile(f1, 'ToS', 'r', 'automatic', 'grayvalues', 'error');
%ESDAP_d = morphological_attribute_profile(f1, 'ToS', 'd', 'automatic', 'grayvalues', 'error');
for i=2:size(reducedIm,3)
    fi = uint8(scaledata(reducedIm(:,:,i), 0, 255));
    [SDAP_a_fi, SL_a_fi] = morphological_attribute_profile(fi, 'ToS', 'a', 'automatic', 'pixels', 'error');
    %SL_a_fi
    [SDAP_s_fi, SL_s_fi] = morphological_attribute_profile(fi, 'ToS', 's', 'automatic', 'pixels', 'error');
    %SL_s_fi
    %SDAP_i_fi = morphological_attribute_profile(fi, 'ToS', 'i', 'automatic', 'grayvalues', 'error');
    %SDAP_v_fi = morphological_attribute_profile(fi, 'ToS', 'v', 'automatic', 'grayvalues', 'error');
    %SDAP_p_fi = morphological_attribute_profile(fi, 'ToS', 'shp', 'automatic', 'grayvalues', 'error');
    %SDAP_r_fi = morphological_attribute_profile(fi, 'ToS', 'r', 'automatic', 'grayvalues', 'error');
    %SDAP_d_fi = morphological_attribute_profile(fi, 'ToS', 'd', 'automatic', 'grayvalues', 'error');
    
    ESDAP_a = cat(3, ESDAP_a, SDAP_a_fi);
    ESDAP_s = cat(3, ESDAP_s, SDAP_s_fi);
    %ESDAP_i = cat(3, ESDAP_i, SDAP_i_fi);
    %ESDAP_v = cat(3, ESDAP_v, SDAP_v_fi);
    %ESDAP_p = cat(3, ESDAP_p, SDAP_p_fi);
    %ESDAP_r = cat(3, ESDAP_r, SDAP_r_fi);
    %ESDAP_d = cat(3, ESDAP_d, SDAP_d_fi);
end
ESDMAP = cat(3, ESDAP_s);%, ESDAP_s);%, ESDAP_i, ESDAP_v, ESDAP_p, ESDAP_r, ESDAP_d);