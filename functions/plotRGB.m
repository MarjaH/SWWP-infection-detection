function plaatje=plotRGB(imageHS,image1_band,image2_band,image3_band,varargin);
%%varargin can contain a different scaling for each of the images and
%%should be a 3-row, 2-column vector with on each row the [min,max] values 
%% function created by L.A. Klerk, AMOLF, Amsterdam, Netherlands / 2009
image1=imageHS(:,:,image1_band);
image2=imageHS(:,:,image2_band);
image3=imageHS(:,:,image3_band);


if nargin>3
    limits=varargin{1};
    if limits(1,2)>max(max(image1))
       limits(1,2)=max(max(image1));
    end
    if limits(2,2)>max(max(image2))
       limits(2,2)=max(max(image2));
    end
    if limits(3,2)>max(max(image3))
       limits(3,2)=max(max(image3));
    end   
else
    limits(1,:)=[min(min(image1)),max(max(image1))];
    limits(2,:)=[min(min(image2)),max(max(image2))];
    limits(3,:)=[min(min(image3)),max(max(image3))];
end

plaatje=cat(3,image1,image2,image3);
tempim=zeros(size(image1));
for n=1:3
    tempim=plaatje(:,:,n);
    tempim(tempim<=limits(n,1))=limits(n,1);
    tempim(tempim>=limits(n,2))=limits(n,2);
    tempim=tempim-limits(n,1);
    tempim=tempim./(limits(n,2)-limits(n,1));
    plaatje(:,:,n)=tempim;
end
% figure()
% subplot(1,2,2)
image(plaatje)
%legend(['R=' inputname(1)], ['G=' inputname(2)],['B=' inputname(3)])
title('RGB composite')
axis image


% plaatje=cat(3,image1,image2,image3);
% 
% for n=1:3
%     plaatje(:,:,n)=plaatje(:,:,n)./max(max(plaatje(:,:,n)));
% end
% 
% image(plaatje)
% legend(['R=' inputname(1)], ['G=' inputname(2)],['B=' inputname(3)])
% axis image