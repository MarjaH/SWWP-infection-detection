function [rr] = ref_ratio(rf,option)
%% Reflectance ratio of wavelengths
% Feature calculation for a hypercube

% input is a single spectra, a vector
% output is reflectance ratio matrix, note that the associated wavelengths are
% a combination of the rf(i) and rf(:). Output is a 2-D matrix where
% rr(i,i) is always 1 and rr is symetrical over the diagonal

% DEPENDENCIES: -

% Marja Haagsma - marja_haagsma@hotmail.com
% November 2018


for i=1:length(rf)
    rr(i,:)=rf(i)./rf;
end

if exist('option','var')&&strcmp(option,'spectral')   %Then output a vector for feature extraction
    rr_new=[];
    for i=1:length(rf)
        a=rr(:,i);
        rr_new=[rr_new a'];
    end
    rr=rr_new;
end

end
