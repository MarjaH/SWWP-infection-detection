function [lam] = lam_lam_log(X,label,option,bands)
%create logarithmic lambda-lambda VI's per  1) pixel
%                                           2) label

% lambda-lambda is the normalized differential index for all possible
% wavelengths. The logarithmic version is a variation. Instead of using the
% reflectance value, we take the log of the inverse of the reflectance

% DEPENDENCIES: none

% Marja Haagsma - marja_haagsma@hotmail.com
% March 2018

%% Check input

%   X: check if X is a numeric variable
%   X: check if 2-D or 3-D matrix, if 3-D matrix reshape to 2-D matrix
if ~exist('X','var')||~isnumeric(X), error('X matrix is a required argument'); end
[H0,W0,D0]=size(X);
if D0>1, X=reshape(X,[H0*W0,D0]); elseif W0==1, X=squeeze(X); end
[H,W]=size(X);

%   label: check if label (if present) is intended to be the label, or that
%   the second argument is actually the 'option'. If so, if there is a
%   third argument, then this one should be bands and not option and the
%   second argument should be option.
%   If label is present and numeric it has to be a vector of the size H (or H0*W0)
if exist('label','var')&&~isnumeric(label)
    if exist('option','var')
        bands=option;
    end
    option=label; clear label; 
end
if exist('label','var')&&~isequal(length(label),H), error('Every entry (pixel) needs a label, size of label is not equal to the number of pixels'); end

%   option: if option is present, output should be 'band-band' in x-y
%   coordinates, 'spatial' in x-y coordinates, or 'spectral' for 2-D matrix (rows are pots and columns are the possible band-band combinations).
if ~exist('option','var')||(strcmp(option,'band-band')||strcmp(option,'spatial')||strcmp(option,'spectral'))==0
    option='band-band';     % default option
    message='option input is invalid, default option "band-band" is chosen';
    disp(message)
end

%   bands: only if option is 'spatial' the lam-lam for only the assigned
%   bands is calculated and spatially delivered (for visualization
%   purposes) should include 2 values; eg [3 7]
if exist('bands','var')&&~isequal(length(bands),2), error('bands argument needs two inputs, eg [3 7]'); end
    
%% Calculate lambda-lambda

if ~exist('label','var')    % 1) if label does not exist do per pixel calc
    if exist('bands','var')     % if bands exist, only calculate lam_lam for the assigned bands
        lam(1,1,:)=(log(1./X(:,bands(1)))-log(1./X(:,bands(2))))./(log(1./X(:,bands(1)))+log(1./X(:,bands(2))));
    else
        for i=1:H               % loop through original height dimension of 3-D
            for j=1:W
                lam(j,:,i)=(log(1./X(i,j))-log(1./X(i,:)))./(log(1./X(i,j))+log(1./X(i,:)));
            end
        end
    end
else                        % 2) if label does exist do per label calc
    F=unique(label);        % determines which unique labels are present
    for i=1:length(F)
        XX=nanmean(X(label==F(i),:),1);
        for j=1:length(XX)
            lam(j,:,i)=(log(1./XX(j))-log(1./XX(:)))./(log(1./XX(j))+log(1./XX(:)));
        end
    end
end

%% Now check what the required output form is, indicated by 'option'

if strcmp(option,'band-band')
    % do nothing
elseif strcmp(option,'spatial')
    % reshape cube to: where x and y are spatial indices and z is the lam-lam
    % z is of size D^2 where the first index is band1-band1, second index
    % band1-band2, third index band1-band3, etc...., untill the D-th index,
    % then D+1 is band2-band1, D+2 is band2-band2, etc. 
    if ~exist('bands','var')
        lam_new=zeros(H0,W0,W^2);
        b=W^2;
    else
        b=1;
    end
        for i=1:W0  % use original width dimension to transform back
            a=lam(:,:,1+H0*(i-1):H0+H0*(i-1));    % use original height dimension
            % now transform a (a 3-D matrix to a 2-D matrix, where columns are
            % stacked on top of eachother
            a_r=reshape(a,b,H0);  % where W is the dimension that indicates the number of bands
            a_t=a_r';   % transpose a_r to get pixels in rows and lam-lams in the columns
            % Now reshape this matrix to a 3-D matrix where the rows remain and
            % the columns are put in the third dimension, leaving 1 column.
            a_rt=reshape(a_t,H0,1,b);
            lam_new(:,i,:)=a_rt;
        end
    lam=lam_new;
elseif strcmp(option,'spectral')
    % reshape cube to: 2-D matrix where rows are spatial unit (pot or
    % pixel) and columns are the possible band-band combinations,note that
    % the cube is halved since it is symmetric over the diagonal.
    if ~exist('bands','var')
        lam_new=zeros(H0,W*(W/2-0.5));
        b=W^2/2;
    else
        b=1;
    end
        for i=1:H0
%               a=tril(lam(:,:,i),-1);  % only extract the lower diagonal half of the matrix
%             % now transform this 2-D matrix to a 1-D vector where (1,1) is
%             % the combination between 1-2, (1,2) is 1-3, (1,W-1) is 2-3,
%             % (1,W+1) is 2-4, (1,2W-2) 3-4 etc.
            a=lam(:,:,i);
            % create a mask to only extract the value from the lower
            % diagonal
            mask=tril(true(size(a)),-1);
%             a_r=[];
%             for ii=1:W
%                 aa=a(:,ii);
%                 aa=aa(find(aa))';
%                 a_r=[a_r aa];
%             end
            
            lam_new(i,:)=a(mask)';
        end
     lam=lam_new;
end

end    