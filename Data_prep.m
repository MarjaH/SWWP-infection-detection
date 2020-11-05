%% Pine segmentation 
% Data preparation
% 1. HS read and RGB composite
% 2. Pot Detection
% 3. use trained classifier to segment image
% 4. create Pines, Flags, X_coord, Y_coord

% Inputs:   - Hypercube binary file
%           - TC (trained classifier, output from
%           Create_VegPix_classifier.m)
% Outputs:  - RGB image
%           - Detected pots (radii, centers, Pots mask)
%           - Pines (matrix with reflectance of all pine pixels)
%           - Flags (vector, same length as Pines, indicating individual plants)
%           - X_coord,Y_coord (matrix, same length as Pines, indicating the
%           spatial position of every pixel)


% Dependencies: - enviread - Felix Totir (2020). ENVI file reader/writer (https://www.mathworks.com/matlabcentral/fileexchange/27172-envi-file-reader-writer), MATLAB Central File Exchange. Retrieved October 7, 2020.
%               - rad2ref
%               - CircDet
%               - createCirclesMask - Brett Shoelson (2020). createCirclesMask.m (https://www.mathworks.com/matlabcentral/fileexchange/47905-createcirclesmask-m), MATLAB Central File Exchange. Retrieved October 7, 2020.

% Marja Haagsma - marja_haagsma@hotmail.com
% January 2019

%% Inputs
clc; clear; close all

% String of hypercube binary file (no need to specify the .hdr-file)
Data='';
date='';   % date of the HSI, this string is used for naming the output file
% load trained classifier 'TC', output from Create_VegPix_classifier.m, 'TC_5023_0503.mat'
load('')

%% 1. HS read and RGB composite

[HS,info]=enviread(Data);  % returns hypercube and wavelength string
[H,W,D]=size(HS);

% extract wavelength information from string to a vector
wv=strsplit(info.wavelength(2:end-1),',');
wavelengths=str2double(wv);

% visualize hypercube with RGB composite
wv_R=wv2bnd(670,wavelengths);
wv_G=wv2bnd(540,wavelengths);
wv_B=wv2bnd(480,wavelengths);
vis_lim(:,1)=[0 0 0];
vis_lim(:,2)=[0.2 0.2 0.2];    
RGB=plotRGB(HS,wv_R,wv_G,wv_B,vis_lim);

%% 2. Pot Detection

[centers,radii,Pot]=CircDet(RGB,0.99,0.05);
% save 'centers','radii','Pot')

%% 3. Use trained classifier to segment the image

% reshape hyperspectral image
HS_reshape=reshape(HS,[],D);

% predict label for each row (i.e. each pixel)
Pred=predict(TC,HS_reshape);

% shape the result back to the original array size
Pred_array=reshape(Pred,H,[]);

% filter out small areas
Pine_mask=bwareaopen(Pred_array,100);

% save 'Pine_mask'

%% 4. Extract spectral information for pixels identified by Pine_mask and Pot

% create now mask by combining Pine and Pot mask
HS_maskp=Pine_mask.*Pot;

% apply Pine and Pot mask to the hypercube
HS_mask=HS.*HS_maskp;

% Create empty matrix for storing all the spectral signatures per pixel
% first find number of pixels
Pixel_N=length(find(Pine_mask.*Pot));
T=zeros(Pixel_N,D);
iii=1;  % counter variable

for i=1:60%length(centers) % iterate through all pots 
    i
    % For every pot create a mask
    Circle_mask=createCirclesMask(RGB,centers(i,:),radii(i));
    % Adjust for random added columns
    Circle_mask(:,W+1:end)=[];
    % Create array with only pine pixels for assigned pot
    HS_p=HS_maskp.*Circle_mask;
    % get x and y coordinate for vegetation pixels in this pot
    [Y,X]=find(HS_p(:,:,1));
    for ii=1:length(Y) % iterate through the number of pixels in a pot-pine mask
        % For all the pixels present place them in the Pines-matrix and assign
        % flag variable (F)in Flags-vector
        Pines(iii,:)=squeeze(HS(Y(ii),X(ii),:));
        Flags(iii,1)=i;
        Y_coord(iii)=Y(ii);
        X_coord(iii)=X(ii);
        iii=iii+1;
    end
end

Pines(iii:end,:)=[];    % get rid of extra insertions

% save(['PinesFlags_',date,'.mat'], 'Pines','Flags','X_coord','Y_coord')
