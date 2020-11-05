%% Classification and feature statistics

% This script will classify the hypercube for the specified classes. An SVM 
% learner with linear kernel is used. The predicted accuracy is the 10-fold 
% predicted accuracy.
% This is repeated n times. 
% And the statistics per feature are calculated, ie p-value and
% bhattacharyya distance

% Computation steps:
% 1. load data
% 2. prepare data for classification
% 3. classify 
% 4. prepare output data
% 5. classify for vigor assessment
% 6. classify for infection using single VI's
% 7. Calculate p-values and BD-values

% Input:  
%           - FCube
%           - FeatList
%           - pots
%           - target class labels
%               - Treatment_Family.csv
%               - Vigor_assessment.csv

% Output:   - AUCall, AUC, Acc, AccAll, AllLab, CM, Lab, Labhat,kappa, Pot,
%             Cube, SVM
%           - statistical measures of p-values (and bhattacharyya
%           distance)

% Dependencies: - Classify_SVMlin
%               - similar_pots
%               - kappa_coefficient
%               - bhattacharyya


% Marja Haagsma - marja_haagsma@hotmail.com
% January, 2019

%% Inputs
dates={'03_16','03_23','03_30','04_06','04_12','04_26','05_01','05_03','05_11','05_23','06_06','06_13','07_09','08_03','09_05','10_16'};
n=19;                   % number of repetitions for the 10-fold cross-validation

Treat_File='';         % Path and file name of 'Treatment_Family.csv'
PathName='';           % Where FCubes files are stored
VA_File='';            % Path and file name of 'Vigor_assessment.csv'

%% 1. load data
% load class labels
TreatTable=readtable(Treat_File);
Treat=table2array(TreatTable);

for i=1:length(dates)
    % load FCubes for each date
    load([PathName,'\FCubes_',dates{i},'.mat'])    
    %% 2. prepare data
    [idx_obs,idx_lb]=similar_pots(pots,Treat(:,1));    % find the index for pots that are in both the HSI and Treat vector
    pots=pots(idx_obs);
    label=Treat((idx_lb),2);
    Lab{i}=label;
    Pot{i}=pots;
    Cube{i}=FCube(idx_obs,:);
    
    %% 3. Classify
     TD=[FCube(idx_obs,272:542) FCube(idx_obs,544:627) label];       % for using median and VI for classification (272:542 and 544:627)
    [labelhat,classificationSVM,AllLabel,AUC]=Classify_SVMlin(TD,n);
    
    %% 4. Prepare output data
    Labhat{i}=labelhat;
    AllLab{i}=AllLabel;
    AUCall{i}=AUC;
    AUC(i)=mean(AUC);
    CM{i}=confusionmat(label,labelhat);
    Acc(i)=sum(diag(CM{i}))/length(label);
    kappa(i)=kappa_coefficient(CM{i});
    for j=1:n
        AccAll(i,j)=length(find(AllLabel(:,j)-label==0))/length(pots);       
    end
    SVM{i}=classificationSVM;
    
end

% save('Prediction.mat','AUCall','AUC','Acc','AccAll','CM','Lab','Labhat','Pot','SVM','kappa')
clear AUCall AUC Acc AccAll CM Labhat SVM kappa
%% 5. classify for vigor classes

% load vigor assessment data
VATable=readtable(VA_File);
VA=table2array(VATable);
pots_VA=VA(:,1);
dates_VA={'03_30','05_03','05_11','05_23','10_16'};

for i=1:length(dates_VA)
    % find dates index that corresponds with dates_VA(i) 
    idx=find(strcmp(dates,dates_VA{i}));    % Use this index in the Cube variable
    FCube=Cube{idx};
    pots=Pot{idx};
    if i==5                     % column 6 does not coincide with HSI, and so for the 5th date we need to look at column 7
        label=VA(:,8);
    else
        label=VA(:,i+2);
    end
    
    for j=1:length(pots)
        if length(find(pots(j)==pots_VA))   % if pots(j) exists in pots_VA         
            label_new(j)=label(find(pots(j)==pots_VA));          % then take the label from label-vector
        else
            label_new(j)=0;                        
        end                            
    end
    label=label_new';
%     label(label==2)=3;  % for merging classes 2&3
    TD=[FCube(:,272:542) FCube(:,544:627) label];  % use median and VI's to train classifier
    [labelhat,classificationSVM,AllLabel,AUC]=Classify_SVMlin(TD,n);
    
    Labhat{i}=labelhat;
    AllLab{i}=AllLabel;
    AUCall{i}=AUC;
    CM{i}=confusionmat(label,labelhat);
    Acc(i)=sum(diag(CM{i}))/length(label);
    kappa(i)=kappa_coefficient(CM{i});
    for j=1:n
        AccAll(i,j)=length(find(AllLabel(:,j)-label==0))/length(pots);       
    end
    SVM{i}=classificationSVM;
    LabVA{i}=label;
    PotVA{i}=pots;   
    clear label_new
    
end    
    
% save('Prediction_VA.mat','Acc','kappa','CM','Labhat','LabVA','PotVA','AllLab','AUCall','SVM')    
clear Acc kappa CM Labhat AllLab AUCall SVM
%% 6. Calculate p-values and BD-values

% first for infection detection
for i=1:length(dates)
    FCube=Cube{i};
    label=Lab{i};
    [~,p(i,:)]=ttest2(FCube(label==0,:),FCube(label==1,:));
    for j=1:length(FCube(1,:))
        if all(FCube(:,j)==1)
            BD(i,j)=nan;
        else
            BD(i,j)=bhattacharyya(FCube(label==0,j),FCube(label==1,j));
        end
    end
end

% save('p&BD_values.mat','p','BD')

% now for vigor separation
for i=1:length(dates_VA)
    idx=find(strcmp(dates,dates_VA{i}));    % Use this index in the Cube variable
    FCube=Cube{idx};
    label=LabVA{i};
    for j=1:length(FCube(1,:))
        pVA(i,j)=anova1(FCube(:,j),label,'off');
    end
end

% save('p_values_VA.mat','pVA')

%% 7. Classify for infectin using single VI's

for i=1:length(dates)
    label=Lab{i};
    FCube=Cube{i};
    for j=1:84
        TD=[FCube(:,543+j) label];
        labelhat=Classify_SVMlin(TD,1);
        CMtemp=confusionmat(label,labelhat);
        Acc_VI(i,j)=sum(diag(CMtemp))/length(label);
    end
end

% save('Acc_VI.mat','Acc_VI')
