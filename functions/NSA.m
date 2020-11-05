function [rk,id_rest] = NSA(p,BD)
%% The New Search Algorithm
% Input:
%   - p-values and
%   - Bhattacharya distance
% Output:
%   - rnk       final rank of the features
%   - id_rest   features that did not make the minimum criteria

% Marja Haagsma - marja_haagsma@hotmail.com
% October 2020

%% first rank both input parameters
[~,rankp]=sort(p,'ascend');
BD(isnan(BD))=-inf;     % since this vector will be sorted with 'descend', otherwise the nan's will be ranked first 
[~,rankBD]=sort(BD,'descend');

%% loop through all positions
rk=[];
t=1;

for i=1:length(p)
    x=rankp(i);                 % feature ranked i-th according to p
    xx=find(rankBD==x);         % ranking in BD of feature x
    y=rankBD(i);                % feature ranked i-th according to BD
    yy=find(rankp==y);          % ranking in p of feature y
    if xx<yy                    % if true then x should come before y
        if ~ismember(x,rk)      % test is x is already in the final rnk vector
            rk(t)=x; t=t+1;     % if not, then fill the next opening with x
        end
        if ~ismember(y,rk)      % test is y is already in the final rnk vector
            rk(t)=y; t=t+1;     % if not, then fill the next opening with y
        end
    else                        % else y comes before x
        if ~ismember(y,rk)
            rk(t)=y; t=t+1;
        end
        if ~ismember(x,rk)
            rk(t)=x; t=t+1;
        end
    end
end

%% test for minimum criteria
pmax=nanmedian(p);
BDmin=nanmedian(BD);

t=1;
for i=1:length(p)
    tmp=rk(i);
    if BD(tmp)>BDmin & p(tmp)<pmax
        rk_new(t)=tmp;
        t=t+1;
    end
end
rk=rk_new;

%% create vector for unranked features
t=1;
id_rest=[];

for i=1:length(p)
    if ~ismember(i,rk) % test whether feature i exists in rk
        id_rest(t)=i;   % if not, then record feature number in id_rest vector
        t=t+1;
    end
end

end

