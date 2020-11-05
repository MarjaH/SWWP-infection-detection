%% Function to find the center and radius of all the circles
% it uses the imfindcircles function from the imaging_toolbox.
% After all the circles + extra circles are found, the extra circles need
% to be eliminated.
% 1. Circles that are too close to another circle (duplicates)
% 2. Circles that are in between circles (overlapping)
% 3. Circles outside the area of plants (outside)
% It turns out that usually the duplicate and overlapping circles are
% produced later in the proces and have therefore a higher number, that's
% why when we look at circles with centers too close together we throw away
% the circle with the higher number.

% Marja Haagsma - marja_haagsma@hotmail.com
% July 2018


function [centers,radii]=AOI_circles(RGB,Sens,Edge);

% Edge threshold
[centers6,radii6]=imfindcircles(RGB,[60 73],'ObjectPolarity','dark',...
    'Sensitivity',Sens,'EdgeThreshold',Edge); %0.98, 0.02
% where [  ] is the range of radius that we expect
% When you increase the sensitivity more circles are found
% when edgethreshold is lowered more circles are found


% check for extra circles
figure()
imshow(RGB)
h=viscircles(centers6,radii6);

% Calculate the distance matrix
D=pdist(centers6);
Z=squareform(D);

Z_0=1000*ones(length(centers6));
Z_0=tril(Z_0);  % introduce a helper matrix so the next statement is only 
                % looking at the top half (diagonal0 of the matrix

% Find duplicates, category 1 and 2  
[A,B]=find((Z+Z_0)<130);    % Where A is the small number of the pair, and B 
                            % is the big number of the pair
                            % 120 is an arbirtrary number chosen for this
                            % image, but you can change this. 

% Find outside circles, category 3
% the minimum distance to the closest cirkel is bigger than 180

Z(Z==0)=nan;
Inside=min(Z);
I_i=find(Inside>180);   % returns the index, hence the circel number
I_v=Inside(Inside>180); % returns the distance

% Combine circles identified through 1, 2, and 3

Delete_Circles=vertcat(B,I_i');
                            
%To check whether you found duplicates we should plot them
d=viscircles(centers6(Delete_Circles,:),radii6(Delete_Circles,:),'Color','b');

% Now delete the circles
centers=centers6;
centers(Delete_Circles,:)=[];
radii=radii6;
radii(Delete_Circles,:)=[];

% Filter again for circles outside the scene (sometimes multiple circles
% are detected here and the max distance is not larger than 180 because of
% replicate faulty circles
% Calculate the distance matrix
D=pdist(centers);
Z=squareform(D);
Z_0=1000*ones(length(centers));
Z_0=tril(Z_0);  % introduce a helper matrix so the next statement is only 
                % looking at the top half (diagonal0 of the matrix
% Find outside circles, category 3
% the minimum distance to the closest cirkel is bigger than 180
Z(Z==0)=nan;
Inside=min(Z);
I_i=find(Inside>170);   % returns the index, hence the circel number
I_v=Inside(Inside>170); % returns the distance
%To check whether you found duplicates we should plot them
h=viscircles(centers,radii);
d=viscircles(centers(I_i,:),radii(I_i,:),'Color','b');

% Delete cirlces in the middle and outside of the image

% Delete circles again
centers(I_i,:)=[];
radii(I_i,:)=[];

% Plot new circles
figure()
imshow(RGB)
d=viscircles(centers,radii);