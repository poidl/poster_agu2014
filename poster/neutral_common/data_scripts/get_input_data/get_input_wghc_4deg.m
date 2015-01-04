function [s,ct,p,lon,lat]=get_input_wghc_4deg(fname)

[s,ct,p,lon,lat]=get_input_wghc_1deg(fname);

% dirty averaging to ensure land points don't disappear
%s= 0.5*s+0.25*circshift(s,  [0 0 -1])+0.25*circshift(s, [0 0 1]);
%ct=0.5*ct+0.25*circshift(ct,[0 0 -1])+0.25*circshift(ct,[0 0 1]);

%s= 0.5*s+0.25*circshift(s,  [0 -1 0])+0.25*circshift(s, [0 1 0]);
%ct=0.5*ct+0.25*circshift(ct,[0 -1 0])+0.25*circshift(ct,[0 1 0]);

s=s(:,1:4:end,1:4:end);
ct=ct(:,1:4:end,1:4:end);
p=p(:,1:4:end,1:4:end);
lon=lon(:,1:4:end,1:4:end);
lat=lat(:,1:4:end,1:4:end);
