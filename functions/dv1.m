function dv = dv1(X,wv,option,label,class)
%% First derivative for feature calculation
% The input is a reflectance matrix, either 2-D or 3-D
% The second input is a wavelength vector
% The third option input is "mean", "median", or "all", this is a required argument
% The fourth input is the label vector [optional], for every pixel in the X
% matrix a label input to average these inputs
% The class argument [optional] is to only consider pixels with the class
% label.

% The output is a first derivative matrix, in the same format as the input
% (2-D or 3-D)

% DEPENDENCIES: non

% Marja Haagsma - marja_haagsma@hotmail.com
% November 2018

%% Check arguments

%   X: check if X is a numeric variable
%   X: check if 2-D or 3-D matrix, if 3-D matrix reshape to 2-D matrix

if ~exist('X','var')||~isnumeric(X), error('X matrix is a required argument'); end
[H,W,D]=size(X);
if D>1, X=reshape(X,[H*W,D]);
end
 [H1,W1]=size(X);
%   wv: check if wv is double and the same size as the
%   band parameter of matrix X, else error

if ~exist('wv','var')||~isnumeric(wv)||~isequal(length(wv),length(X(1,:))), error('Wavelength is a required numeric input of the same size as the band dimension of matrix X'); end

%   option: either 'mean', 'median' or 'all' --> variable is not optional

if ~exist('option','var')||~ischar(option), error('choose either "mean", "median" or "all"'); end
if (strcmp(option,'mean')||strcmp(option,'median')||strcmp(option,'all'))==0,error('choose either "mean", "median" or "all"');end

%   label: label matrix or vector needs to be the same size as X. 
%   labels, for example treatment or family. label can be a matrix or a
%   vector. When it's a matrix it's reshaped to a vector. If label does not
%   exist a default label is used (all ones).

if exist('label','var')
    [Hl,Wl]=size(label);    % this would be the case for a 3-D X input
    if Wl>1, label=reshape(label,[Hl*Wl,1]); end; end
if exist('label','var')&&~isequal(length(label),H1),error('Label has to be the same size as X or Cannot specify a class when there is no label vector');end
if ~exist('label','var'),label=ones(H1,1); end

%   class: only apply calculations to specified 'class'
%   Check if class is present in label vector.

if exist('class','var')&&any(~ismember(class,label)), error('Specified class is absent in label vector'); end
        
%% Derivatives

F=unique(label);    % determine which unique labels are present

if exist('class','var') %if class is a variable there will only be one calculation
    F=class;
end

% For every label class this snippet is repeated
for i=1:length(F)
    flag=F(i);
    XX=X(label==flag,:);
    for ii=1:length(wv)-1
        if strcmp(option,'all')
            dv(:,ii)=(XX(:,ii+1)-XX(:,ii))./(wv(ii+1)-wv(ii));
        elseif strcmp(option,'mean')
            XXX=mean(XX);
            dv(i,ii)=(XXX(ii+1)-XXX(ii))/(wv(ii+1)-wv(ii));       
        elseif strcmp(option,'median')
            XXX=median(XX);
            dv(i,ii)=(XXX(ii+1)-XXX(ii))/(wv(ii+1)-wv(ii));  
        end
    end
end
   
%% Determine output format (either 2-D or 3-D) (only for 'all' option)
if D>1  %if original third dimension is bigger than 1, then the original matrix was 3-D
    dv_n=zeros(H,W,D-1);
    for i=1:W
        a=dv(1+H*(i-1):H+H*(i-1),:); % use original height dimension to determine which pixels go in the ith column
        % now reshape this matrix to [H,1,D-1]
        a_r=reshape(a,H,1,D-1);
        % now place this 3-D matrix in the ith column
        dv_n(:,i,:)=a_r;
    end
    dv=dv_n;
end

end

