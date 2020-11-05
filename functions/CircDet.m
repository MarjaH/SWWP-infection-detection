function [centers,radii,PotMask] = CircDet(RGB,Sens,Edge)
% This function is specified for the use in the OSU greenhouse experiment
% input is the RGB or any other type of 3 band composite
% The sensitivity and egde parameters in the AOI_circles function can be
% tweeked

% Output is a pot mask
% 
% DEPENDENCIES: - AOI_circles()
%               - CreateCircleMask()
%
% Marja Haagsma - marja_haagsma@hotmail.com
% November 2018

%% Check input arguments

% RGB needs to be a 3-D matrix with third dimension of the size 3

% Sens is sensitivity parameter between [0 1] for this application [0.95
% 1.00]

% Edge is edge detection parameter between [0 1] for this application ~0.05

%%
[H,W,D]=size(RGB);
 
[centers,radii]=AOI_circles(RGB,Sens,Edge);

% manually delete circle in mesh
man_del=input('Do you want to manually delete the circles in the mesh? [Y/N] ','s');


if man_del=='Y'
    mid_left=input('Give left boundary for mid section ');
    mid_right=input('Give right boundary for mid section ');
    right_end=input('Give right end boundary ');
    del_cir=find(or(and(centers(:,1)>mid_left,centers(:,1)<mid_right),centers(:,1)>right_end));
    centers(del_cir,:)=[];
    radii(del_cir)=[];
    figure()
    imshow(RGB)
    h=viscircles(centers,radii);
end

% manually add circles
man_add=input('Do you want to manually add circles? [Y/N] ','s');
if man_add=='Y'
    x_cir=input('X coordinate of circle(s) ');
    y_cir=input('Y coordinate of circle(s) ');
    r_cir=input('Radius of circle(s) ');
    centers=vertcat(centers,[x_cir,y_cir]);
    radii=vertcat(radii,r_cir);
    figure()
    imshow(RGB)
    h=viscircles(centers,radii);
end

%create Pot mask
PotMask=createCirclesMask(RGB,centers,radii);
PotMask(:,W+1:end)=[]; % the line above creates a matrix where the x dimension is too big
%Sort circles to line up with numbering of pots.
centers=horzcat(centers,radii);
centers=sortrows(centers,-1);    % sorted in x
centers_t=zeros(length(centers),3);

% sorting in y (per 5 plants in the column)
for i=1:length(centers)/5
    centers_t(1+5*(i-1):5+5*(i-1),:)=sortrows(centers(1+5*(i-1):5+5*(i-1),:),-2);
end
centers=centers_t(:,1:2);
radii=centers_t(:,3);

end

