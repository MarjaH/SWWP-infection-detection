%% Script for analysis, figures, and tables in manuscript 
% Using hyperspectral imagery to detect an invasive fungal pathogen and symptom severity in Pinus strobiformis seedlings of different genotypes 

% 1. Classification accuracy distribution over time
% 2. Infection detection by HSI AND percentage of vigor-impacted seedlings
% 3. Classification accuracy per family. And explain FN and FP in error. 
% 4. Correlation between mortality rate and accuracy AND vigor rate and
%    accuracy. Data points are families
% 5. p-values per wavelength over time
% 6. p and BC vs classification accuracy per VI
% 7. scatter plot of identified VI's using 'new search algorithm'
% 8. scatter plot for NSA for early and late time
% 9. results of NSA for entire feature set
% 10. feature identification for vigor class separation & multinomial
%    regression
% 11. confusionmatrix for VA
% 12. confusionmatrix for VA merged


% Marja Haagsma - marja_haagsma@hotmail.com
% October 2020

clc; clear; close all
%% Inputs
wv=[399.184,401.416,403.648,405.880,408.112,410.344,412.576,414.808,417.040,419.272,421.504,423.736,425.968,428.199,430.431,432.663,434.895,437.127,439.359,441.591,443.823,446.055,448.287,450.519,452.751,454.983,457.215,459.447,461.679,463.911,466.142,468.374,470.606,472.838,475.070,477.302,479.534,481.766,483.998,486.230,488.462,490.694,492.926,495.158,497.390,499.622,501.854,504.085,506.317,508.549,510.781,513.013,515.245,517.477,519.709,521.941,524.173,526.405,528.637,530.869,533.101,535.333,537.565,539.797,542.028,544.260,546.492,548.724,550.956,553.188,555.420,557.652,559.884,562.116,564.348,566.580,568.812,571.044,573.276,575.508,577.740,579.971,582.203,584.435,586.667,588.899,591.131,593.363,595.595,597.827,600.059,602.291,604.523,606.755,608.987,611.219,613.451,615.683,617.914,620.146,622.378,624.610,626.842,629.074,631.306,633.538,635.770,638.002,640.234,642.466,644.698,646.930,649.162,651.394,653.625,655.857,658.089,660.321,662.553,664.785,667.017,669.249,671.481,673.713,675.945,678.177,680.409,682.641,684.873,687.105,689.337,691.568,693.800,696.032,698.264,700.496,702.728,704.960,707.192,709.424,711.656,713.888,716.120,718.352,720.584,722.816,725.048,727.280,729.511,731.743,733.975,736.207,738.439,740.671,742.903,745.135,747.367,749.599,751.831,754.063,756.295,758.527,760.759,762.991,765.223,767.454,769.686,771.918,774.150,776.382,778.614,780.846,783.078,785.310,787.542,789.774,792.006,794.238,796.470,798.702,800.934,803.166,805.397,807.629,809.861,812.093,814.325,816.557,818.789,821.021,823.253,825.485,827.717,829.949,832.181,834.413,836.645,838.877,841.109,843.340,845.572,847.804,850.036,852.268,854.500,856.732,858.964,861.196,863.428,865.660,867.892,870.124,872.356,874.588,876.820,879.051,881.283,883.515,885.747,887.979,890.211,892.443,894.675,896.907,899.139,901.371,903.603,905.835,908.067,910.299,912.531,914.763,916.994,919.226,921.458,923.690,925.922,928.154,930.386,932.618,934.850,937.082,939.314,941.546,943.778,946.010,948.242,950.474,952.706,954.937,957.169,959.401,961.633,963.865,966.097,968.329,970.561,972.793,975.025,977.257,979.489,981.721,983.953,986.185,988.417,990.649,992.880,995.112,997.344,999.576,1001.81];
DOY=[75 82 89 96 102 116 121 123 131 143 157 164 190 220 248 289];  % day of year for the HSI
dates={'03_16','03_23','03_30','04_06','04_12','04_26','05_01','05_03','05_11','05_23','06_06','06_13','07_09','08_03','09_05','10_16'};
dates_VA={'03_30','05_03','05_11','05_23','10_16'}; % dates that coincide with Vigor Assessments

Pred_Inf='';   % path and file name ('Prediction.mat') of the results from the infection classification 'Classification_Infection.m' 
VA_File='';            % path and file name of 'Vigor_assessment.csv'
Treat_File='';         % path and file name of 'Treatment_Family.csv'
p_BD='';  % path and file name containing p and BD values for infection from 'Classification_Infection.m' script
FCube_FeatList=''; % path and file containing a FCube and most importantly the Feature-list
Acc_VI_File=''; % path and file containing the classification accuracy for infection detection using sinle VI's, resutl from 'Classification_Infection.m' 'Acc_VI'
p_VA=''; % path and name of the file containing p-values for one-way ANOVA for Vigor assessment classes, outcome from 'Classification_Infection.m' script. 'p_values_VA.mat'
Pathname_FCubes='';   % path where the FCubes are stored.
Pred_VA='';    % path and name of file containing vigor assessment classification from 'Classification_Infection.m' script
Pred_VA_merged=''; % path and name of file containing vigor assessment classification for classes 2&3 merged from 'Classification_Infection.m' script
%% 1.
load(Pred_Inf)    % load the results from infection classification
    % includes: AUCall, Acc, AccAll, AllLab, CM, Lab, Labhat, kappa
    
AccAll=AccAll.*100; % for percentages

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure()
b1=boxplot(AccAll','PlotStyle','compact','Positions',DOY,'Color','r');
ylim([75 95])
xlim([min(DOY)-5 max(DOY)+5])
set(gca,'XTick',100:50:300)
ticklabel={'100','150','200','250','300'};
set(gca,'XTickLabel',ticklabel)
ylabel('Classification Accuracy [%]')
xlabel('Time [Day Of Year]')
grid on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2. 
VATable=readtable(VA_File);
VA=table2array(VATable);
Y_VA=VA(:,2:end);
% per column calculate how many per class there are (in ratio)
for j=1:7
    R(1,j)=length(find(Y_VA(:,j)==1))/length(Y_VA(:,j));  % ratio of seedlings in class 1
    R(2,j)=length(find(Y_VA(:,j)==2))/length(Y_VA(:,j));  % class 2
    R(3,j)=length(find(Y_VA(:,j)==3))/length(Y_VA(:,j));  % class 3
    R(4,j)=length(find(Y_VA(:,j)==8))/length(Y_VA(:,j));  % class 4
end
IS=(1-R(1,:))*100;  % ratio of impacted seedlings (class >= 2)
varname=VATable.Properties.VariableNames(2:end);
for i=1:length(varname)
    temp=varname{i};
    DOYsev(i)=str2num(temp(4:end)); % day of year of the visual assessment
end
   
% calculate success of infection detection by HSI
for i=1:16
    CMnow=CM{i};    % confusionmatrix from classification results
    Rec(i)=CMnow(2,2)/sum(CMnow(2,:));  % recall (success of infection detection) = true positive/(true positive+false negative)
end
Rec=Rec'.*100;  % change ratio to percentages, and transpose to prepare for visualization

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure()
s1=scatter(DOYsev,IS,'filled','d'); hold on     % scatter Impacted Seedlings
s2=scatter(DOY,Rec,'filled','r');               % scatter HSI infection detection 
ylim([0 95])
xlim([min(DOYsev)-5 max(DOY)+5])
set(gca,'XTick',100:50:300)
ticklabel={'100','150','200','250','300'};
set(gca,'XTickLabel',ticklabel)
ylabel('Percentage of infected seedlings [%]')
xlabel('Time [Day Of Year]')
legend([s1 s2],'Impacted seedlings (Vigor class >= 2','Infection detection by HSI','Location','southeast')
grid on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3.

% load class labels
TreatTable=readtable(Treat_File);
Treat=table2array(TreatTable);

for i=1:length(dates)
    X=Labhat{i};   % predicted labels for this date
    Y=Lab{i};   % true labels for this date
    P=Pot{i};   % pots for this date
    c=ismember(Treat(:,1),P);
    famvec=Treat(find(c),3); % family vector for this date
    for ii=1:length(unique(famvec))
        Xfam=X(famvec==ii); % predicted labels for this family
        Yfam=Y(famvec==ii); % true labels for this family
        CMfam=confusionmat(Yfam,Xfam);  % construct the confusion matrix
        OAfam(ii,i)=sum(diag(CMfam))/length(Xfam);  % calculate the overall accuracy for this family
        FNfam(ii,i)=CMfam(2,1)/sum(CMfam(:));       % false negative percentage for this family
        FPfam(ii,i)=CMfam(1,2)/sum(CMfam(:));       % false positive percentage for this family
    end
end
clear X

OAmean=mean(OAfam')';       % mean overall accuracy over 16 dates
FN=mean(FNfam');            % mean false negative over 16 dates
FP=mean(FPfam');            % mean false positive over 16 dates

% order families based and mortality rate
potvec_VA=VA(:,1);
famvec_VA=Treat(find(ismember(Treat(:,1),potvec_VA)),3);
for i=1:length(unique(famvec_VA))
    temp=Y_VA(find(famvec_VA==i),end);
    MR(i)=length(find(temp==4))/length(temp);        % Mortality Rate
    NIS(i)=length(find(temp==1))/length(temp);       % Non-Impacted Seedlings rate
end

% construct matrix with OA, FN, and FP to construct stacked bar-plot
[~,ord]=sort(MR); % order is based on mortality rate
X(:,1)=OAmean(ord);
X(:,2)=FN(ord);
X(:,3)=FP(ord);
X=X.*100;   % convert to percentage

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure()
bar(X,'stacked')
legend('Classification Accuracy','False Negatives','False Positives','Location','northeastoutside')
ylabel('Percentage of seedlings [%]')    
ylim([60 100])
labels={'A','B','C','D','E','F','G','H','I','J'};
set(gca,'XTickLabel',labels)
xlabel({'Family';'low mortality rate                    high mortality rate'})
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4.  

MR=MR(ord)';
NIS=NIS(ord)';

R_MR=corr(MR,X(:,1))^2;     % Pearson's R for Mortality rate vs classification accuracy
R_NIS=corr(NIS,X(:,1))^2;   % Pearson's R for Non-Impacted Seedlings rate vs classification accuracy

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure()
subplot(1,2,1)
s=scatter(MR,X(:,1),'filled'); hold on
xlabel('Mortality rate per family')
ylabel('Classification Accuracy per family [%]')
fitline=polyfit(MR,X(:,1),1);
xin=(min(MR):0.001:max(MR));
yout=polyval(fitline,xin);
p=plot(xin,yout,'k','LineWidth',2);
legend(p,['R^2 = ',num2str(round(R_MR,2))],'Location','southeast')
set(gca,'YTick',[70 80 90 100])

% add title and allign to left
t=title('a');
set(t,'horizontalAlignment','left')
set(t,'units','normalized')
h1=get(t,'position');
set(t,'position',[0 h1(2) h1(3)])

subplot(1,2,2)
s=scatter(NIS,X(:,1),'filled'); hold on
xlabel('Vigorous rate per family')
ylabel('Classification Accuracy per family [%]')
fitline=polyfit(NIS,X(:,1),1);
xin=(min(NIS):0.001:max(NIS));
yout=polyval(fitline,xin);
p=plot(xin,yout,'k','LineWidth',2);
set(gca,'YTick',[70 80 90 100])
legend(p,['R^2 = ',num2str(round(R_NIS,2))],'Location','northeast')

% add title and allign to left
t=title('b');
set(t,'horizontalAlignment','left')
set(t,'units','normalized')
h1=get(t,'position');
set(t,'position',[0 h1(2) h1(3)])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5.
% load result from 2-sample t-test for wavelengths to assessment relative
% importance among wavelengths to distinguish inoculated from control
% seedlings
load(p_BD)
WV=p(:,272:542);    % use the median reflectance

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure()
d=log10(WV);
mn=min(d(:));
rng=max(d(:))-mn;
d=1+63*(d-mn)/rng;              % self scale data
mx=1+63*(log10(0.05)-mn)/rng;   % is threshold (p<0.05) where value is significant
d(d>mx)=nan;                    % set non-significant values to nan
im=imagesc(wv,1:1:16,d);        % plot data
caxis([1 mx])                   % color axis limits
hC=colorbar;
L=[1e-18 1e-15 1e-12 1e-9 1e-6 1e-3];
l=1+63*(log10(L)-mn)/rng;       % tick mark positions
set(hC,'Ytick',l,'YTicklabel',L);
set(im,'AlphaData',~isnan(d))   % nan values to white
ylabel(hC,'p-value')
ylabel('Dates')
xlabel('Wavelengths [nm]')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 6.
% load the classification accuracy for single VI's
load(Acc_VI_File);
Acc_VI=Acc;
% Featlist name
load(FCube_FeatList)

pVI_ave=mean(p(:,544:627)); % The p-values for vegetation indices
pVI_avelog=log10(pVI_ave);
Acc_ave=mean(Acc_VI).*100;
VIBD_ave=mean(BD(:,544:627));   % the BD-values for vegetation indices

VI_type=[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 ...
    2 2 2 3 3 3 3 3 3 4 4 4 5 5 5 5 5 5 5 5 6 6 6 7 7 7 7 7 7 2 2 3 4 4 ...
    4 5 5 8 8 2 8 2 2 1 1 6 6 8 8 8 8]; % vector for type of VI's, from 'VI_Calculator.m'

VI_list=FeatList(544:627);  % get the VI names 

cmap=cbrewer('qual','Set2',length(unique(VI_type)));   % create colormap to color code scatter for VI-type class

% first the p-value ranking
% Spearman's rank test
[xrank,temp]=sort(pVI_avelog);
yrank=Acc_ave(temp);
rho_p_all=corr(xrank(1:36)',yrank(1:36)','Type','Spearman') % first 36 VI's are taken because this is the number of ranked VI's using the 'new search algorithm'

% Pearson's correlation 
R_squared_p_all=corr(pVI_avelog',Acc_ave')^2

% now the BD ranking
% Spearman's rank test
[xrank,temp]=sort(VIBD_ave,'descend');
yrank=Acc_ave(temp);
rho_BD_all=corr(xrank(1:36)',yrank(1:36)','Type','Spearman')    % first 36 VI's are taken because this is the number of ranked VI's using the 'new search algorithm'

% Pearson's correlation 
R_squared_BD_all=corr(VIBD_ave',Acc_ave')^2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure()
subplot(1,2,1)
gscatter(pVI_avelog,Acc_ave,VI_type',cmap,[],20); hold on
p1=polyfit(pVI_avelog,Acc_ave,1);
x1=0:-1:-18;
y1=polyval(p1,x1);
pl=plot(x1,y1,'--','Color',[0.3 0.3 0.3],'LineWidth',2);
ylim([50 85])
xlim([-18 0.5])
xlabel('p-value')
ylabel('Classification accuracy [%]')
L=[1e-16 1e-12 1e-8 1e-4 1e-0];
l=-16:4:0;
set(gca,'XTick',l,'XTicklabel',L)
colormap(cmap);
legend('Structural','Chlorophyll','Carotenoid','Xanthophyll','RGB indices','Misc','Fluorescence','Red-Edge',['R^2 = ',num2str(round(R_squared_p_all,2))])
legend('Location','southwest')
uistack(pl,'bottom')

% add title and allign to left
t=title('a');
set(t,'horizontalAlignment','left')
set(t,'units','normalized')
h1=get(t,'position');
set(t,'position',[0 h1(2) h1(3)])

% Create textarrow
annotation('textarrow',[0.216666666666667 0.184782608695652],...
    [0.877095238095239 0.876190476190476],'String',{'PRI'});

% Create textarrow
annotation('textarrow',[0.342391304347826 0.310507246376812],...
    [0.893285714285716 0.892380952380953],'String',{'PRIn'});

% Create textarrow
annotation('textarrow',[0.150724637681159 0.15036231884058],...
    [0.744761904761905 0.854285714285716],'String',{'PRI570'});

subplot(1,2,2)
gscatter(VIBD_ave,Acc_ave,VI_type',cmap,[],20); hold on
p1=polyfit(VIBD_ave,Acc_ave,1);
x1=0:0.01:1;
y1=polyval(p1,x1);
pl=plot(x1,y1,'--','Color',[0.3 0.3 0.3],'LineWidth',2);
ylim([50 85])
xlabel('BD-value')
ylabel('Classification accuracy [%]')

colormap(cmap);
legend('Structural','Chlorophyll','Carotenoid','Xanthophyll','RGB indices','Misc','Fluorescence','Red-Edge',['R^2 = ',num2str(round(R_squared_BD_all,2))])
legend('Location','southeast')
uistack(pl,'bottom')

% add title and allign to left
t=title('b');
set(t,'horizontalAlignment','left')
set(t,'units','normalized')
h1=get(t,'position');
set(t,'position',[0 h1(2) h1(3)])

% Create textarrow
annotation('textarrow',[0.803623188405797 0.780797101449276],...
    [0.881904761904762 0.879047619047622],'String',{'PRI'});

% Create textarrow
annotation('textarrow',[0.849637681159421 0.849275362318841],...
    [0.822809523809529 0.876190476190477],'String',{'PRIn'});

% Create textarrow
annotation('textarrow',[0.72463768115942 0.754347826086957],...
    [0.88 0.88],'String',{'PRI570'});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 7.
[rnk,id_rest]=NSA(pVI_ave,VIBD_ave);    % apply new search algorithm

[Acc_rest,sortrest]=sort(Acc_ave(id_rest),'descend');   % create new vectors to sort Acc_ave for unranked features to visualize 
A=[Acc_ave(rnk) Acc_rest];                              % create vecotr for rank of accuracy
VI_type_sort=[VI_type(rnk) VI_type(sortrest)];          % create the order for the class of VI's

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure()
scatter(1:1:length(pVI_ave),A,[],[0.3 0.3 0.3],'o'); hold on
s1=gscatter(1:1:length(rnk),Acc_ave(rnk),VI_type_sort(1:length(rnk)),cmap,[],22);
xlabel('New Search Algorithm rank')
ylabel('Classification accuracy [%]')
legend('Unranked')
rho=corr((1:1:length(rnk))',Acc_ave(rnk)','Type','Spearman')
ylim([50 85])
box on

% Create textarrow
annotation('textarrow',[0.228782287822878 0.186346863468635],...
    [0.946581196581197 0.903846153846154],'String',{'PRIn'});

% Create textarrow
annotation('textarrow',[0.328413284132841 0.267527675276753],...
    [0.876068376068376 0.873931623931624],'String',{'PRI'});

% Create textarrow
annotation('textarrow',[0.18450184501845 0.169741697416974],...
    [0.677350427350427 0.865384615384615],'String',{'PRI570'});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 8.
% early time
p_early=mean(p(1:4,544:627));
BD_early=mean(BD(1:4,544:627));
Acc_early=mean(Acc(1:4,:)).*100;

[rank_early,id_rest_early]=NSA(p_early,BD_early);

[Acc_rest_early,sortrest_early]=sort(Acc_early(id_rest_early),'descend');
A_early=[Acc_early(rank_early) Acc_rest_early];
VI_type_early=[VI_type(rank_early) VI_type(sortrest_early)];

% late time
p_late=mean(p(13:16,544:627));
BD_late=mean(BD(13:16,544:627));
Acc_late=mean(Acc(13:16,:)).*100;

[rank_late,id_rest_late]=NSA(p_late,BD_late);

[Acc_rest_late,sortrest_late]=sort(Acc_late(id_rest_late),'descend');
A_late=[Acc_late(rank_late) Acc_rest_late];
VI_type_late=[VI_type(rank_late) VI_type(sortrest_late)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure()
subplot(1,2,1)
scatter(1:1:length(p_early),A_early,[],[0.3 0.3 0.3],'o'); hold on
s1=gscatter(1:1:length(rank_early),Acc_early(rank_early),VI_type_early(1:length(rank_early)),cmap,[],22);
xlabel('New Search Algorithm rank')
ylabel('Classification accuracy [%]')
legend('Unranked','Location','southwest')
rho=corr((1:1:length(rank_early))',Acc_early(rank_early)','Type','Spearman')
ylim([40 90])
xlim([-5 90])
box on

t=title('a: Early time');
set(t,'horizontalAlignment','left')
set(t,'units','normalized')
h1=get(t,'position');
set(t,'position',[0 h1(2) h1(3)])

% Create textarrow
annotation('textarrow',[0.150316926704206 0.150830010336838],...
    [0.646335661835455 0.77038481338607],'String',{'        PRI570'});

% Create textarrow
annotation('textarrow',[0.23083790171344 0.163110862206001],...
    [0.83081220374768 0.799044503338083],'String',{'PRIn'});

subplot(1,2,2)
scatter(1:1:length(p_late),A_late,[],[0.3 0.3 0.3],'o'); hold on
s1=gscatter(1:1:length(rank_late),Acc_late(rank_late),VI_type_late(1:length(rank_late)),cmap,[],22);
xlabel('New Search Algorithm rank')
ylabel('Classification accuracy [%]')
legend('Unranked','Location','southwest')
rho=corr((1:1:length(rank_late))',Acc_late(rank_late)','Type','Spearman')
ylim([40 90])
xlim([-5 90])
box on

t=title('b: Late time');
set(t,'horizontalAlignment','left')
set(t,'units','normalized')
h1=get(t,'position');
set(t,'position',[0 h1(2) h1(3)])

% Create textarrow
annotation('textarrow',[0.645689655172414 0.604310344827586],...
    [0.877505567928731 0.853006681514477],'String',{'PSRI'});

% Create textarrow
annotation('textarrow',[0.590086206896552 0.590948275862069],...
    [0.705013363028953 0.815144766146993],'String',{'GI'});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 9.
% p-value
p_ave=mean(p);
p_early=mean(p(1:4,:));
p_late=mean(p(13:end,:));

% BC coefficient
BD_ave=mean(BD);  
BD_early=mean(BD(1:4,:));  
BD_late=mean(BD(13:end,:)); 

[rnk_all,~]=NSA(p_ave,BD_ave);
[rnk_early,~]=NSA(p_early,BD_early);
[rnk_late,~]=NSA(p_late,BD_late);

FeatList(rnk_all(1:6))
FeatList(rnk_early(1:6))
FeatList(rnk_late(1:6))

%% 10.
% load p-value for vigor-class separation
load(p_VA)
[minval,id]=min(mean(p));
% load prediction_VA 
load(Pred_VA)

All=[];
All_label=[];
Pot_try=[];
for i=1:length(dates_VA)
    load([Pathname_FCubes,'\FCubes_',dates_VA{i},'.mat'])
    [idx_obs,idx_lb]=similar_pots(pots,Treat(:,1)); 
    FCube=FCube(idx_obs,:);
    Pot_try=[Pot_try;pots(idx_obs)];
    All=[All;FCube];
    All_label=[All_label;LabVA{i}];
    Cube{i}=FCube;
end

X=All(:,id);
Y=All_label;

% find pots of interest (POI), ones that change from 1 to 2 in the next
% assessment
% find index of pots that have 1 on the present date and >1 on the next
% date

T1=[];
T0=[];
label=[];
for i=1:length(dates_VA)-1
    X1=LabVA{i};  % symptom sev for i
    X2=LabVA{i+1};    % symptom sev for i+1
    P1=PotVA{i};   % pots for i
    P2=PotVA{i+1}; % pots for i+1
    [idx1,idx2]=similar_pots(P1,P2);    % similar pots for the two dates
    X1=X1(idx1);    % adjust for missing pots in i+1
    X2=X2(idx2);    % adjust for missing pots in i
    P1=P1(idx1);    % pot vector present on both dates
    idx=find(X1==1&X2>1);   % find index for pre-symptomatic observations
    idx0=find(X1==0);
    Pot_of_interest=P1(idx); % these are the pot numbers for which we need to get the true and predicted labels.
    POI{i}=Pot_of_interest;
end


plen=0;
id1=[];
for i=1:4
    por=PotVA{i};
    p1=POI{i};
    for j=1:length(p1)
        % find where in por p1(i) exists
        id(j)=find(por==p1(j));
    end
    id=id+plen;
    id1=[id1;id'];
    plen=plen+length(por);  % how many pots came before
    clear id
end

% create a new class
Y(Y>1)=Y(Y>1)+1;
Y(id1)=2;

% multinomial regression
fitm=mnrfit(X,Y+1); % +1 because labels need to be positive for the mnrfit function

lmin=min(X);
lmax=max(X);

x=linspace(lmin,lmax,100);
pdf=mnrval(fitm,x');

% colors used for visualization
cl=[0 0 1;
    0 0 1;
    0 0 1;
    1/3 0 2/3;
    2/3 0 1/3;
    1 0 0];

% figure parameters
style={'--','-',':','-.','--','-'};
Legend={'-     (control)','+ 1 (inoculated unaffected)','+ 1 (inoculated pre-affected)','+ 2 (inoculated vigor-class 2)','+ 3 (inoculated vigor-class 3)','+ 4 (inoculated vigor-class 4)'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure()
subplot(1,2,1)
b=boxplot(X,Y,'Color',cl); hold on
set(b,{'linew'},{1.5})
ylabel('PRIn')
l=line([1.5 1.5],[-0.1 0.9]);
l.LineStyle='--';
l.Color=[0.5 0.5 0.5];
ht=my_xticklabels(gca,1:1:6,{'-','+ 1','+ 1','+ 2','+ 3','+ 4'})
xtickangle(0)

t=title('a');
set(t,'horizontalAlignment','left')
set(t,'units','normalized')
h1=get(t,'position');
set(t,'position',[0 h1(2) h1(3)])

subplot(1,2,2)
for i=1:length(pdf(1,:))
    p=plot(x,pdf(:,i),'color',cl(i,:),'LineWidth',2); hold on
    p.LineStyle=style{i};
end
xlim([lmin lmax])
ylabel('Probability of falling within Class')
legend(Legend)
xlabel('PRIn[-]')

t=title('b');
set(t,'horizontalAlignment','left')
set(t,'units','normalized')
h1=get(t,'position');
set(t,'position',[0 h1(2) h1(3)])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 11.
temp=[];
for i=1:5
    temp=cat(3,temp,CM{i});
end
tempsum=sum(temp,3);
CM_VA_ave=tempsum./5
VA_acc_ave=sum(diag(CM_VA_ave))/sum(CM_VA_ave(:))
VA_kappa_ave=kappa_coefficient(CM_VA_ave)

%% 12.
load(Pred_VA_merged)
temp=[];
for i=1:5
    temp=cat(3,temp,CM{i});
end
tempsum=sum(temp,3);
CM_VAmer_ave=tempsum./5
VAmer_acc_ave=sum(diag(CM_VAmer_ave))/sum(CM_VAmer_ave(:))
VAmer_kappa_ave=kappa_coefficient(CM_VAmer_ave)