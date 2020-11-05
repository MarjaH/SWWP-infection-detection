%% Create Features from spectral signatures

% The goal of this script is to create a features per observation (pot) with
%       - mean reflectance
%       - median reflectance
%       - area (size of plant)
%       - Vegetation Indices
%       - Lambda-lambda (normalized differential reflectance indices)
%       - Lambda-lambda logarithmic
%       - Reflectance ratio
%       - First derivatives
% 

% input:    - Pines
%           - Flags

% output:   - FCube
%           - FeatList

% Dependencies: - VI_calculator
%                   - wv2bnd
%               - dv1
%               - lam_lam
%               - lam_lam_log
%               - ref_ratio

% Marja Haagsma - marja_haagsma@hotmail.com
% January 2019

clc; clear
%% Inputs
dates={'03_16','03_23','03_30','04_06','04_12','04_26','05_01','05_03','05_11PM','05_23','06_06','06_13','07_09','08_03','09_05','10_16'};
wavelengths=[399.184,401.416,403.648,405.880,408.112,410.344,412.576,414.808,417.040,419.272,421.504,423.736,425.968,428.199,430.431,432.663,434.895,437.127,439.359,441.591,443.823,446.055,448.287,450.519,452.751,454.983,457.215,459.447,461.679,463.911,466.142,468.374,470.606,472.838,475.070,477.302,479.534,481.766,483.998,486.230,488.462,490.694,492.926,495.158,497.390,499.622,501.854,504.085,506.317,508.549,510.781,513.013,515.245,517.477,519.709,521.941,524.173,526.405,528.637,530.869,533.101,535.333,537.565,539.797,542.028,544.260,546.492,548.724,550.956,553.188,555.420,557.652,559.884,562.116,564.348,566.580,568.812,571.044,573.276,575.508,577.740,579.971,582.203,584.435,586.667,588.899,591.131,593.363,595.595,597.827,600.059,602.291,604.523,606.755,608.987,611.219,613.451,615.683,617.914,620.146,622.378,624.610,626.842,629.074,631.306,633.538,635.770,638.002,640.234,642.466,644.698,646.930,649.162,651.394,653.625,655.857,658.089,660.321,662.553,664.785,667.017,669.249,671.481,673.713,675.945,678.177,680.409,682.641,684.873,687.105,689.337,691.568,693.800,696.032,698.264,700.496,702.728,704.960,707.192,709.424,711.656,713.888,716.120,718.352,720.584,722.816,725.048,727.280,729.511,731.743,733.975,736.207,738.439,740.671,742.903,745.135,747.367,749.599,751.831,754.063,756.295,758.527,760.759,762.991,765.223,767.454,769.686,771.918,774.150,776.382,778.614,780.846,783.078,785.310,787.542,789.774,792.006,794.238,796.470,798.702,800.934,803.166,805.397,807.629,809.861,812.093,814.325,816.557,818.789,821.021,823.253,825.485,827.717,829.949,832.181,834.413,836.645,838.877,841.109,843.340,845.572,847.804,850.036,852.268,854.500,856.732,858.964,861.196,863.428,865.660,867.892,870.124,872.356,874.588,876.820,879.051,881.283,883.515,885.747,887.979,890.211,892.443,894.675,896.907,899.139,901.371,903.603,905.835,908.067,910.299,912.531,914.763,916.994,919.226,921.458,923.690,925.922,928.154,930.386,932.618,934.850,937.082,939.314,941.546,943.778,946.010,948.242,950.474,952.706,954.937,957.169,959.401,961.633,963.865,966.097,968.329,970.561,972.793,975.025,977.257,979.489,981.721,983.953,986.185,988.417,990.649,992.880,995.112,997.344,999.576,1001.81];
PathName='';   % where PinesFlags_dates are stored
SaveDir='';    % where you want to store the FCubes

%% Load the data (Pines & Flags, wavelengths)
for j=1:length(dates)

% load Pines and Flags arrays
load([PathName,'\PinesFlags_',dates{j},'_new.mat']);

% find unique flags
pots=unique(Flags);

%% Create  features

for i=1:length(pots)
    HS_ave(i,:)=nanmean(Pines(Flags==pots(i),:),1);     % mean
    HS_med(i,:)=nanmedian(Pines(Flags==pots(i),:));     % median
    HS_area(i)=length(Pines(Flags==pots(i),:));         % area
    HS_rr(i,:)=ref_ratio(HS_ave(i,:),'spectral');       % reflectance ratio
end

[VI,VI_list]=VI_Calculator(HS_ave,wavelengths);                 % VI's

lam=lam_lam(HS_ave,'spectral');                                 % normalized difference index
lam_log=lam_lam_log(HS_ave,'spectral');                         % logarithmic normalized difference index
%     % lambda-lambda
%     % a 2-D matrix where (i,1) is
%     % the combination between 1-2, (i,2) is 1-3, (i,W-1) is 2-3,
%     % (i,W+1) is 2-4, (i,2W-2) 3-4 etc.
%     
dv=dv1(HS_ave,wavelengths,'all');                               % first derivative

%% Create Name string for every column
if ~exist('Feat','var')
for i=1:length(wavelengths)
    Feat{i}=['mean ',num2str(wavelengths(i))];
end

l=length(Feat);
for i=1:length(wavelengths)
    Feat{l+i}=['median ',num2str(wavelengths(i))];
end

l=length(Feat);
Feat{l+1}='area [#pixels]';

l=length(Feat);
for i=1:length(VI(1,:))
    Feat{l+i}=VI_list{i};
end

l=length(Feat);
H=length(wavelengths)-1:-1:1;
for i=1:length(lam(1,:))
    x=100;t=1;ii=i;
    while x>1
        x=ii/H(t);
        ii=ii-H(t);
        t=t+1;
    end
    x=wavelengths(t-1);
    y=wavelengths(mod(i,H(t-1))+1);
    if y==x
       y=wavelengths(end);
    end
    Feat{l+i}=['lam (',num2str(x),'-',num2str(y),')'];
end

l=length(Feat);
H=length(wavelengths)-1:-1:1;
for i=1:length(lam(1,:))
    x=100;t=1;ii=i;
    while x>1
        x=ii/H(t);
        ii=ii-H(t);
        t=t+1;
    end
    x=wavelengths(t-1);
    y=wavelengths(mod(i,H(t-1))+1);
    if y==x
       y=wavelengths(end);
    end
    Feat{l+i}=['lamlog (',num2str(x),'-',num2str(y),')'];
end

l=length(Feat);
for i=1:length(HS_rr(1,:))
    x=wavelengths(ceil(i/length(wavelengths)));
    xx=mod(i,length(wavelengths));
    if xx==0
        xx=271;
    end
    y=wavelengths(xx);
    Feat{l+i}=['rr (',num2str(x),'-',num2str(y),')'];
end

l=length(Feat);
for i=1:length(dv(1,:))
    Feat{l+i}=['1dv (',num2str(wavelengths(i)),')'];
end
end
%% Create Feature Cube 
FCube=[HS_ave HS_med HS_area' VI lam lam_log HS_rr dv];
FeatList=Feat;

% save FCube, FeatList, and pots
% save([SaveDir,'\FCubes_',dates{j},'.mat'],'FCube','FeatList','pots')
clearvars -except j Feat dates SaveDir wavelengths PathName
end