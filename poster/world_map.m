close all
clear all

ds='woa13_1deg';

load(['./data_out/',ds,'/input_data.mat'])

[nz,ny,nx]=size(s);
[ibb,ilon,ilat]=backbone_index(squeeze(lon(1,:,:)),squeeze(lat(1,:,:)));

lo=squeeze(lon(1,1,:));
la=squeeze(lat(1,:,1));
lo(lo>lo(end))=lo(lo>lo(end))-lo(end);
ss=squeeze(s(1,:,:));

figure()
h=imagesc(lo,la,ss);
set(h,'alphadata',~isnan(ss)) % white nans
set(gca,'ydir','normal')
colorbar()
hold on 
plot(lo(ilon),la(ilat),'r*','markersize',10,'linewidth',1.2)
plot(lo(ilon),la(ilat),'bo','markersize',10,'linewidth',1.2)



%keyboard
method='gamma_i_v1'
load(['./data_out/',ds,'/',method,'/field.mat'])

g=squeeze(field(1,:,:));

figure()
h=imagesc(lo,la,g);
set(h,'alphadata',~isnan(g)) % white nans
set(gca,'ydir','normal')
colorbar()


ind=ilon;
pp=squeeze(p(:,1,1));

pbot=p(sum(~isnan(s(:,ibb))),ibb);

ss=squeeze(s(:,:,ind));
figure()
h=contourf(la,pp,ss);
%set(h,'alphadata',~isnan(g)) % white nans
set(gca,'ydir','reverse')
title(['lo= ', num2str(lo(ind))])
colorbar()
hold on
yl=ylim;
plot(la(ilat)*[1 1],[ yl(1) pbot])



g=squeeze(field(:,:,ind));
figure()
h=contourf(la,pp,g);
%set(h,'alphadata',~isnan(g)) % white nans
set(gca,'ydir','reverse')
title(['lo= ', num2str(lo(ind))])
colorbar()
hold on 

yl=ylim;
plot(la(ilat)*[1 1],[ yl(1) pbot])

keyboard
% ss=squeeze(s(:,(ilon-1)*ny+1:(ilon)*ny));
% figure()
% h=contourf(la,pp,ss);
% %set(h,'alphadata',~isnan(g)) % white nans
% set(gca,'ydir','reverse')
% title(['lo= ', num2str(lo(ind))])
% colorbar()
% hold on 
% keyboard
