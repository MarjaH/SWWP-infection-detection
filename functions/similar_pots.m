function [index_obs,index_label] = similar_pots(pot_obs,pot_label)
%FIND the indices in the matrix for two matrices where the pot/individuals
%label correspond.

% find pots in observed vector which are not present in label vector and
% vice versa
C=[setdiff(pot_obs,pot_label);setdiff(pot_label,pot_obs)];
% all pots in vector C should be removed from either the observed or the
% labeled pots

% create a helper vector with all the present pots in the two vectors
% combined
X=unique([pot_label;pot_obs]);
% the pots found in vector C are removed from vector X to create a new
% vector with the pots available in both vectors
for i=1:length(C)
    X(X==C(i))=[];
end

% now the indices/location of the pots in the observed and labeled pots are
% found
index_obs=zeros(length(X),1);
index_label=zeros(length(X),1);

for i=1:length(X)
    index_obs(i)=find(pot_obs==X(i));
    index_label(i)=find(pot_label==X(i));
end

end

