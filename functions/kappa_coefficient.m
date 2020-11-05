function [ kappa ] = kappa_coefficient(CM)
% Determines the Cohen's kappa coefficient for a confusionmatrix.
% DEPENDENCIES: none

% Marja Haagsma - marja_haagsma@hotmail.com
% November 2018
%   CM is the confusion matrix
n=sum(sum(CM));         % total number of observations

OA=sum(diag(CM))/n;     % Observed Agreement (overall accuracy)

H=0;                    % support variable
for i=1:length(CM)
    h=(sum(CM(:,i))*sum(CM(i,:)))/n;
    H=H+h;
end
EA=H/n;

kappa=(OA-EA)/(1-EA);

end

