function [s,ct,p,lon,lat]=crop_to_gamma_n(s,ct,p,lon,lat)

% crop. From README of the gamma code:
% "...The gamma_n code will stop if you give it a cast whose longitude or latitude
%     is outside the range of the data set, namely [0,360]x[-80,64]."
% la=squeeze(lat(1,:,1));
% ii=-80<=la& la<=64;
% s=s(:,ii,:);
% ct=ct(:,ii,:);
% p=p(:,ii,:);
% lon=lon(:,ii,:);
% lat=lat(:,ii,:);

ii=-80<=lat & lat<=64;

s(~ii)=nan;
ct(~ii)=nan;
