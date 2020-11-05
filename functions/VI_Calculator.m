function [VI,VI_list] = VI_Calculator(HS,wv)
% This function calculates the following VI's
%   Input cube should be either 2-D or 3-D matrix, and the wavelength
%   vector
%   Ouput is VI cube and a list of the VI's if file is present


% DEPENDENCIES: - wv2bnd()

% Marja Haagsma - marja_haagsma@hotmail.com
% November 2018

%% Check arguments
% check HS matrix
if ~exist('HS','var')||~isnumeric(HS), error('HS matrix is a required argument'); end
[H,W,D]=size(HS);
if D>1
    i=0;    % keeping track if HS matrix is 2-D or 3-D, original matrix is 3-D
else
    i=1;    % keeping track if HS matrix is 2-D or 3-D, original matrix is 2-D
    HS=reshape(HS,[H,1,W]); 
end

% check wavelength vector
[~,~,D]=size(HS);
if ~exist('wv','var')||~isnumeric(wv)||~isequal(length(wv),D),error('wavelength is a required argument of the same size as the number of bands in HS'); end


%% Calculate VI's
                                         
    VI(:,:,1)=(HS(:,:,wv2bnd(wv,801))-HS(:,:,wv2bnd(wv,669)))./...
        (HS(:,:,wv2bnd(wv,801))+HS(:,:,wv2bnd(wv,669)));                    %NDVI
    VI(:,:,2)=(HS(:,:,wv2bnd(wv,801))-HS(:,:,wv2bnd(wv,669)))./...
        sqrt(HS(:,:,wv2bnd(wv,801))+HS(:,:,wv2bnd(wv,669)));                %RDVI
    VI(:,:,3)=HS(:,:,wv2bnd(wv,801))./HS(:,:,wv2bnd(wv,669));               %SR
    VI(:,:,4)=(HS(:,:,wv2bnd(wv,801))./HS(:,:,wv2bnd(wv,669))-1)./...
        (HS(:,:,wv2bnd(wv,801))./HS(:,:,wv2bnd(wv,669)).^0.5+1);            %MSR
    VI(:,:,5)=(1+0.16).*(HS(:,:,wv2bnd(wv,801))-...
        HS(:,:,wv2bnd(wv,669)))./(HS(:,:,wv2bnd(wv,801))+...
        HS(:,:,wv2bnd(wv,669))+0.16);                                       %OSAVI
    VI(:,:,6)=(2*HS(:,:,wv2bnd(wv,801))+1-sqrt((2.*...
        HS(:,:,wv2bnd(wv,801))+1).^2-8.*...
        (HS(:,:,wv2bnd(wv,801))-HS(:,:,wv2bnd(wv,669)))))./2;               %MSAVI
    VI(:,:,7)=0.5.*(120.*(HS(:,:,wv2bnd(wv,801))-...
        HS(:,:,wv2bnd(wv,669)))-200.*(HS(:,:,wv2bnd(wv,669))-...
        HS(:,:,wv2bnd(wv,540))));                                           %TVI
    VI(:,:,8)=1.2.*(1.2.*(HS(:,:,wv2bnd(wv,801))-HS(:,:,wv2bnd(wv,550)))-...
        2.5.*(HS(:,:,wv2bnd(wv,669))-HS(:,:,wv2bnd(wv,550))));              %MTVI1
    VI(:,:,9)=1.5.*(1.2.*(HS(:,:,wv2bnd(wv,801))-HS(:,:,wv2bnd(wv,550)))-...
        2.5.*(HS(:,:,wv2bnd(wv,669))-HS(:,:,wv2bnd(wv,550))))./...
        sqrt((2.*HS(:,:,wv2bnd(wv,801))+1).^2-(6.*...
        HS(:,:,wv2bnd(wv,801))-5.*sqrt(HS(:,:,wv2bnd(wv,669))))-0.5);       %MTVI2
    VI(:,:,10)=1.2.*2.5.*(HS(:,:,wv2bnd(wv,801))-...
        HS(:,:,wv2bnd(wv,669)))-1.3.*(HS(:,:,wv2bnd(wv,801))-...
        HS(:,:,wv2bnd(wv,550)));                                            %MSAVI1
    VI(:,:,11)=1.2.*2.5.*(HS(:,:,wv2bnd(wv,801))-...
        HS(:,:,wv2bnd(wv,669)))-1.3.*(HS(:,:,wv2bnd(wv,801))-...
        HS(:,:,wv2bnd(wv,550)))./sqrt((2.*HS(:,:,wv2bnd(wv,801))+1).^2-...
        (6.*HS(:,:,wv2bnd(wv,801))-5.*...
        sqrt(HS(:,:,wv2bnd(wv,669))))-0.5);                                 %MSAVI2
    VI(:,:,12)=2.5.*(HS(:,:,wv2bnd(wv,801))-...
        HS(:,:,wv2bnd(wv,669)))./(HS(:,:,wv2bnd(wv,801))+...
        6.*HS(:,:,wv2bnd(wv,669))-7.5.*HS(:,:,wv2bnd(wv,400))+1);           %EVI
    VI(:,:,13)=(HS(:,:,wv2bnd(wv,801))-HS(:,:,wv2bnd(wv,680)))./...
        (HS(:,:,wv2bnd(wv,801))+HS(:,:,wv2bnd(wv,680)));                    %LIC1
    VI(:,:,14)=(HS(:,:,wv2bnd(wv,801))-HS(:,:,wv2bnd(wv,540)))./...
        (HS(:,:,wv2bnd(wv,801))+HS(:,:,wv2bnd(wv,540)));                    %GNDVI
    VI(:,:,15)=HS(:,:,wv2bnd(wv,801))./HS(:,:,wv2bnd(wv,540));              %NIR_G
    VI(:,:,16)=HS(:,:,wv2bnd(wv,650))./HS(:,:,wv2bnd(wv,540));              %R_G
    VI(:,:,17)=(HS(:,:,wv2bnd(wv,540))-HS(:,:,wv2bnd(wv,669)))./...
        (HS(:,:,wv2bnd(wv,540))+HS(:,:,wv2bnd(wv,669)));                    %VIGreen
    VI(:,:,18)=(HS(:,:,wv2bnd(wv,814))-HS(:,:,wv2bnd(wv,672)))./...
        (HS(:,:,wv2bnd(wv,814))+HS(:,:,wv2bnd(wv,672)));                    %HNDVI
    VI(:,:,19)=HS(:,:,wv2bnd(wv,539))./HS(:,:,wv2bnd(wv,682));              %GI
    VI(:,:,20)=HS(:,:,wv2bnd(wv,743))./HS(:,:,wv2bnd(wv,692));              %HVI
    VI(:,:,21)=HS(:,:,wv2bnd(wv,740))./HS(:,:,wv2bnd(wv,720));              %VOG1
    VI(:,:,22)=(HS(:,:,wv2bnd(wv,734))-HS(:,:,wv2bnd(wv,747)))./...
        (HS(:,:,wv2bnd(wv,715))+HS(:,:,wv2bnd(wv,726)));                    %VOG2
    VI(:,:,23)=(HS(:,:,wv2bnd(wv,734))-HS(:,:,wv2bnd(wv,747)))./...
        (HS(:,:,wv2bnd(wv,715))+HS(:,:,wv2bnd(wv,720)));                    %VOG3
    VI(:,:,24)=HS(:,:,wv2bnd(wv,750))./HS(:,:,wv2bnd(wv,550));              %GM1
    VI(:,:,25)=HS(:,:,wv2bnd(wv,750))./HS(:,:,wv2bnd(wv,700));              %GM2
    VI(:,:,26)=HS(:,:,wv2bnd(wv,750))./HS(:,:,wv2bnd(wv,710));              %CI
    VI(:,:,27)=HS(:,:,wv2bnd(wv,430))./HS(:,:,wv2bnd(wv,680));              %SRPI
    VI(:,:,28)=(HS(:,:,wv2bnd(wv,415))-HS(:,:,wv2bnd(wv,735)))./...
        (HS(:,:,wv2bnd(wv,415))+HS(:,:,wv2bnd(wv,735)));                    %NPQ1
    VI(:,:,29)=(HS(:,:,wv2bnd(wv,680))-HS(:,:,wv2bnd(wv,430)))./...
        (HS(:,:,wv2bnd(wv,680))+HS(:,:,wv2bnd(wv,430)));                    %NPCI
    VI(:,:,30)=HS(:,:,wv2bnd(wv,695))./HS(:,:,wv2bnd(wv,420));              %CTRI1
    VI(:,:,31)=HS(:,:,wv2bnd(wv,800))./HS(:,:,wv2bnd(wv,675));              %PSSRa
    VI(:,:,32)=HS(:,:,wv2bnd(wv,800))./HS(:,:,wv2bnd(wv,650));              %PSSRb
    VI(:,:,33)=(HS(:,:,wv2bnd(wv,800))-HS(:,:,wv2bnd(wv,470)))./...
        (HS(:,:,wv2bnd(wv,800))+HS(:,:,wv2bnd(wv,470)));                    %PSNDc
    VI(:,:,34)=HS(:,:,wv2bnd(wv,860))./...
        (HS(:,:,wv2bnd(wv,550)).*HS(:,:,wv2bnd(wv,708)));                   %RBRI
    VI(:,:,35)=3.*((HS(:,:,wv2bnd(wv,801))-HS(:,:,wv2bnd(wv,669)))-...
        0.2.*(HS(:,:,wv2bnd(wv,801))-HS(:,:,wv2bnd(wv,540)))).*...
        (HS(:,:,wv2bnd(wv,801))./HS(:,:,wv2bnd(wv,669)));                   %TCARI
    VI(:,:,36)=(HS(:,:,wv2bnd(wv,712)).*(HS(:,:,wv2bnd(wv,712))-...
        HS(:,:,wv2bnd(wv,682)))-0.2.*(HS(:,:,wv2bnd(wv,712))-...
        HS(:,:,wv2bnd(wv,539))))./HS(:,:,wv2bnd(wv,682));                   %MCARI
    VI(:,:,37)=(HS(:,:,wv2bnd(wv,800))-HS(:,:,wv2bnd(wv,445)))./...
        (HS(:,:,wv2bnd(wv,800))+HS(:,:,wv2bnd(wv,680)));                    %SIPI
    VI(:,:,38)=(HS(:,:,wv2bnd(wv,680))-HS(:,:,wv2bnd(wv,500)))./...
        HS(:,:,wv2bnd(wv,750));                                             %PSRI
    VI(:,:,39)=HS(:,:,wv2bnd(wv,800))./HS(:,:,wv2bnd(wv,500));              %PSSRc
    VI(:,:,40)=HS(:,:,wv2bnd(wv,440))./HS(:,:,wv2bnd(wv,740));              %LIC3
    VI(:,:,41)=(1./HS(:,:,wv2bnd(wv,510)))-...
        (1./HS(:,:,wv2bnd(wv,550)));                                        %CRI550
    VI(:,:,42)=(1./HS(:,:,wv2bnd(wv,515)))-...
        (1./HS(:,:,wv2bnd(wv,550)));                                        %CRI550_515
    VI(:,:,43)=(HS(:,:,wv2bnd(wv,570))-HS(:,:,wv2bnd(wv,531)))./...
        (HS(:,:,wv2bnd(wv,570))+HS(:,:,wv2bnd(wv,531)));                    %PRI570
    VI(:,:,44)=(HS(:,:,wv2bnd(wv,515))-HS(:,:,wv2bnd(wv,531)))./...
        (HS(:,:,wv2bnd(wv,515))+HS(:,:,wv2bnd(wv,531)));                    %PRI515
    VI(:,:,45)=(HS(:,:,wv2bnd(wv,529))-HS(:,:,wv2bnd(wv,580)))./...
        (HS(:,:,wv2bnd(wv,529))+HS(:,:,wv2bnd(wv,580)));                    %PRI
    VI(:,:,46)=HS(:,:,wv2bnd(wv,700))./HS(:,:,wv2bnd(wv,670));              %R
    VI(:,:,47)=HS(:,:,wv2bnd(wv,570))./HS(:,:,wv2bnd(wv,670));              %G
    VI(:,:,48)=HS(:,:,wv2bnd(wv,450))./HS(:,:,wv2bnd(wv,490));              %B
    VI(:,:,49)=HS(:,:,wv2bnd(wv,400))./HS(:,:,wv2bnd(wv,550));              %BGI1
    VI(:,:,50)=HS(:,:,wv2bnd(wv,450))./HS(:,:,wv2bnd(wv,550));              %BGI2
    VI(:,:,51)=HS(:,:,wv2bnd(wv,400))./HS(:,:,wv2bnd(wv,690));              %BRI1
    VI(:,:,52)=HS(:,:,wv2bnd(wv,690))./HS(:,:,wv2bnd(wv,550));              %RGI
    VI(:,:,53)=HS(:,:,wv2bnd(wv,440))./HS(:,:,wv2bnd(wv,690));              %LIC2
    VI(:,:,54)=(HS(:,:,wv2bnd(wv,534))-HS(:,:,wv2bnd(wv,698)))./...
        (HS(:,:,wv2bnd(wv,534))+HS(:,:,wv2bnd(wv,698)))-0.5.*...
        HS(:,:,wv2bnd(wv,704));                                             %HI
    VI(:,:,55)=0.5.*(HS(:,:,wv2bnd(wv,722))+...
        HS(:,:,wv2bnd(wv,763)))-HS(:,:,wv2bnd(wv,733));                     %RVSI
    VI(:,:,56)=HS(:,:,wv2bnd(wv,970))./HS(:,:,wv2bnd(wv,900));              %WI
    VI(:,:,57)=HS(:,:,wv2bnd(wv,685))./HS(:,:,wv2bnd(wv,655));              %SIF
    VI(:,:,58)=HS(:,:,wv2bnd(wv,683)).^2./...
        (HS(:,:,wv2bnd(wv,675)).*HS(:,:,wv2bnd(wv,691)));                   %SIF
    VI(:,:,59)=HS(:,:,wv2bnd(wv,690))./HS(:,:,wv2bnd(wv,600));              %SIF
    VI(:,:,60)=HS(:,:,wv2bnd(wv,740))./HS(:,:,wv2bnd(wv,800));              %SIF
    VI(:,:,61)=HS(:,:,wv2bnd(wv,675)).*HS(:,:,wv2bnd(wv,690))./...
        HS(:,:,wv2bnd(wv,683)).^2;                                          %SIF
    VI(:,:,62)=HS(:,:,wv2bnd(wv,730))./HS(:,:,wv2bnd(wv,706));              %SIF --> should actually be the first derivatives at these wavelengths....
    VI(:,:,63)=HS(:,:,wv2bnd(wv,695))./HS(:,:,wv2bnd(wv,760));              %CAR
    VI(:,:,64)=HS(:,:,wv2bnd(wv,672))./(HS(:,:,wv2bnd(wv,550))....
        *3.*HS(:,:,wv2bnd(wv,708)));                                        %DCabCxc
    VI(:,:,65)=(1./HS(:,:,wv2bnd(wv,510)))-...
        (1./HS(:,:,wv2bnd(wv,700)));                                        %CRI700
    VI(:,:,66)=VI(:,:,43)./(VI(:,:,2).*...
        (HS(:,:,wv2bnd(wv,700))./HS(:,:,wv2bnd(wv,670))));                  %PRIn
    VI(:,:,67)=(HS(:,:,wv2bnd(wv,570))-HS(:,:,wv2bnd(wv,530)))./...
        (HS(:,:,wv2bnd(wv,570))+HS(:,:,wv2bnd(wv,530))).*...
        ((HS(:,:,wv2bnd(wv,760))./HS(:,:,wv2bnd(wv,700)))-1);               %PRI*CI
    VI(:,:,68)=(HS(:,:,wv2bnd(wv,570))-HS(:,:,wv2bnd(wv,531))-...
        HS(:,:,wv2bnd(wv,670)))./(HS(:,:,wv2bnd(wv,570))+...
        HS(:,:,wv2bnd(wv,531))+HS(:,:,wv2bnd(wv,670)));                     %PRIm4
    VI(:,:,69)=HS(:,:,wv2bnd(wv,400))./HS(:,:,wv2bnd(wv,420));              %BF2
    VI(:,:,70)=HS(:,:,wv2bnd(wv,400))./HS(:,:,wv2bnd(wv,410));              %BF1
    VI(:,:,71)=mean(HS(:,:,wv2bnd(wv,708):wv2bnd(wv,716)),3)./...
        mean(HS(:,:,wv2bnd(wv,676):wv2bnd(wv,685)),3);                      %RE1
    VI(:,:,72)=(mean(HS(:,:,wv2bnd(wv,708):wv2bnd(wv,716)),3)-...
        mean(HS(:,:,wv2bnd(wv,676):wv2bnd(wv,685)),3))./...
        (mean(HS(:,:,wv2bnd(wv,708):wv2bnd(wv,716)),3)+...
        mean(HS(:,:,wv2bnd(wv,676):wv2bnd(wv,685)),3));                     %RE2
    VI(:,:,73)=HS(:,:,wv2bnd(wv,790))./HS(:,:,wv2bnd(wv,550))-1;            %Chlgreen
    VI(:,:,74)=HS(:,:,wv2bnd(wv,790))./HS(:,:,wv2bnd(wv,705))-1;            %Chlrededge
    VI(:,:,75)=(HS(:,:,wv2bnd(wv,750))-HS(:,:,wv2bnd(wv,705)))./...
        (HS(:,:,wv2bnd(wv,750))-HS(:,:,wv2bnd(wv,705))-2.*...
        HS(:,:,wv2bnd(wv,445)));                                            %mND
    VI(:,:,76)=(HS(:,:,wv2bnd(wv,750))-HS(:,:,wv2bnd(wv,445)))./...
        (HS(:,:,wv2bnd(wv,705))-HS(:,:,wv2bnd(wv,445)));                    %mSR
    VI(:,:,77)=(HS(:,:,wv2bnd(wv,858.6))-(HS(:,:,wv2bnd(wv,648.2))-...
        (HS(:,:,wv2bnd(wv,467.8))-HS(:,:,wv2bnd(wv,648.2)))))./...
        (HS(:,:,wv2bnd(wv,858.6))+(HS(:,:,wv2bnd(wv,648.2))-...
        (HS(:,:,wv2bnd(wv,467.8))-HS(:,:,wv2bnd(wv,648.2)))));              %ARVI
    VI(:,:,78)=(HS(:,:,wv2bnd(wv,800))-HS(:,:,wv2bnd(wv,670)))./...
        (HS(:,:,wv2bnd(wv,800))+HS(:,:,wv2bnd(wv,670))+0.5).*...
        (1+0.5);                                                            %SAVI
    VI(:,:,79)=1./HS(:,:,wv2bnd(wv,550))./(1./HS(:,:,wv2bnd(wv,700)));      %ARI
    VI(:,:,80)=1./HS(:,:,wv2bnd(wv,550))./(1./HS(:,:,wv2bnd(wv,700)))...
        ./mean(HS(:,:,wv2bnd(wv,780):wv2bnd(wv,1400)),3);                   %BRI
    VI(:,:,81)=(HS(:,:,wv2bnd(wv,718))+HS(:,:,wv2bnd(wv,748)))./2-...
        HS(:,:,wv2bnd(wv,733));                                             %RESVI
    VI(:,:,82)=700+40.*(((HS(:,:,wv2bnd(wv,670))+...
        HS(:,:,wv2bnd(wv,780)))./2-HS(:,:,wv2bnd(wv,700)))./...
        (HS(:,:,wv2bnd(wv,740))-HS(:,:,wv2bnd(wv,700))));                   %REIP1
    VI(:,:,83)=702+40.*(((HS(:,:,wv2bnd(wv,667))+...
        HS(:,:,wv2bnd(wv,782)))./2-HS(:,:,wv2bnd(wv,702)))./...
        (HS(:,:,wv2bnd(wv,742))-HS(:,:,wv2bnd(wv,702))));                   %REIP2
    VI(:,:,84)=705+35.*(((HS(:,:,wv2bnd(wv,665))+...
        HS(:,:,wv2bnd(wv,783)))./2-HS(:,:,wv2bnd(wv,705)))./...
        (HS(:,:,wv2bnd(wv,740))-HS(:,:,wv2bnd(wv,705))));                   %REIP3


if i==1         %original matrix was 2-D and VI needs to be converted to original format
    VI=squeeze(VI);
end

VI_list={'NDVI';'RDVI';'SR';'MSR';'OSAVI';'MSAVI';'TVI';'MTVI1';'MTVI2';...
    'MSAVI1';'MSAVI2';'EVI';'LIC1';'GNDVI';'NIR_G';'R_G';'VIGreen';'HNDVI';...
    'GI';'HVI';'VOG1';'VOG2';'VOG3';'GM1';'GM2';'CI';'SRPI';'NPQ1';'NPCI';...
    'CTRI1';'PSSRa';'PSSRb';'PSNDc';'RBRI';'TCARI';'MCARI';'SIPI';'PSRI';...
    'PSSRc';'LIC3';'CRI550';'CRI550_515';'PRI570';'PRI515';'PRI';'R';'G';...
    'B';'BGI1';'BGI2';'BRI1';'RGI';'LIC2';'HI';'RVSI';'WI';...
    'R685_R655';'R683^2_-R675xR691-';'R690_R600';'R740_R800';...
    '-R675xR690-_R683^2';'R730_R706';'CAR';'DCabCxc';'CRI700';...
    'PRIn';'PRIxCI';'PRIm4';'BF2';'BF1';'RE1';'RE2';'Chlgreen';'Chlrededge';...
    'mND';'mSR';'ARVI';'SAVI';'ARI';'BRI';...
    'RESVI';'REIP1';'REIP2';'REIP3'};

% 1. Structure indices
% 2. Physiology - chlorophyll
% 3. Physiology - carotenoid
% 4. Physiology - Xantophyll 
% 5. RGB indices
% 6. Misc
% 7. Fluorescence 
% 8. Red edge
VI_class=[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 ...
    2 2 2 3 3 3 3 3 3 4 4 4 5 5 5 5 5 5 5 5 6 6 6 7 7 7 7 7 7 2 2 3 4 4 ...
    4 5 5 8 8 2 8 2 2 1 1 6 6 8 8 8 8]; 
end

