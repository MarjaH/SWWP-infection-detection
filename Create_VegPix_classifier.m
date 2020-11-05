%% Create vegetation classifier (mask) 
% uses hypercubes from dates 20180503 and 20180523 to create a segmentation classifier

% Inputs:   - Three masks manually created in GIMP 2
%               - 05_03_Mask_background.png
%               - 05_23_Mask_75.png
%               - 05_23_Mask_background_75.png
%           - Two hypercubes
%               - 20180503_SWWP
%               - 20180523_SWWP

% Outputs:  - TC
% Dependencies: - enviread

% Marja Haagsma - marja_haagsma@hotmail.com
% January 2019

%% Inputs
HSdata0503='20180503_SWWP';                 % hyperspectral imagery for 20180503
BG_mask0503='05_03_Mask_background.png';    % background mask for 20180503
HSdata0523='20180523_SWWP';                 % hyperspectral imagery for 20180523
BG_mask0523='05_23_Mask_background_75.png'; % background mask for 20180523
Veg_mask0523='05_23_Mask_75.png';           % pixel-vegetation mask for 20180523

%% Extract pixels from hypercube on date 0503
[HS0503,info]=enviread(HSdata0503);             % load hypercube
BG_Mask=imread(BG_mask0503);                    % read the background masked created in GIMP
M_BG=imbinarize(BG_Mask(:,:,1));                % the loaded images are in 3 uint8, we need a binary image

[row_BG,col_BG]=find(M_BG);                     % find indices of masked pixels (where values==1)

n=4000;                                         % number of pixels to use
Y=randperm(length(row_BG),n);                   % pick random indices from the available pixels

for i=1:length(Y)                               % use the random indices to draw the spectrum from that location
    BG(i,:)=squeeze(HS0503(row_BG(Y(i)),col_BG(Y(i)),:));
end

% Put the spectral signatures in the Training data matrix and add labels to
% the last column
TD0503=BG;
[H,W]=size(TD0503);
TD0503(1:n,W+1)=0;                              % since this hypercube only contributes to background

clear BG

%% Extract pixels from hypercube on date 0523
[HS0523,info]=enviread(HSdata0523);             % load hypercube
Mask=imread(Veg_mask0523);                      % read the vegetation mask created in GIMP
BG_Mask=imread(BG_mask0523);                    % read the background mask created in GIMP

M=imbinarize(Mask(:,:,1));                      % the loaded images are in 3 uint8, we need a binary image
M_BG=imbinarize(BG_Mask(:,:,1));

[row_M,col_M]=find(M);                          % find indices of masked pixels
[row_BG,col_BG]=find(M_BG);

n=6000;                                         % number of pixels 
X=randperm(length(row_M),n);                    % pick random indices from the available pixels
Y=randperm(length(row_BG),n);

for i=1:length(X)                               % use the random indices to draw the spectrum from that position
    Veg(i,:)=squeeze(HS0523(row_M(X(i)),col_M(X(i)),:));
end

for i=1:length(Y)
    BG(i,:)=squeeze(HS0523(row_BG(Y(i)),col_BG(Y(i)),:));
end

% combine the two classes and add labels
TD0523=[Veg;BG];
[H,W]=size(TD0523);
TD0523(1:n,W+1)=1;         

clear BG Veg

% final training data
TD=[TD0523;TD0503];                             

%% train Classifier
TC=fitcsvm(TD(:,1:end-1),TD(:,end),'KernelFunction','polynomial',...
    'PolynomialOrder',3,'KernelScale','auto','BoxConstraint',1,...
    'Standardize',true,'ClassNames',[0;1]);