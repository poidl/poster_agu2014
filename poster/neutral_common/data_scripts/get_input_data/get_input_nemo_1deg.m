function [s,ct,p,lon,lat]=get_input_nemo_1deg(fname)

lat=ncread(fname,'lat');
lon=ncread(fname,'lon');
p=ncread(fname,'p');
s=ncread(fname,'s');
tpot=ncread(fname,'tpot'); 

% remove overlapping grid points
lat=lat(1:end-2,:,:);
lon=lon(1:end-2,:,:);
p=p(1:end-2,:,:);
s=s(1:end-2,:,:);
tpot=tpot(1:end-2,:,:);

% subsampling to 1 deg resolution (ATTENTION INDICES: (LON,LAT,DEPTH))
lat=lat(1:2:end,1:2:end,:);
lon=lon(1:2:end,1:2:end,:);
p=p(1:2:end,1:2:end,:);
s=s(1:2:end,1:2:end,:);
tpot=tpot(1:2:end,1:2:end,:);


ct=gsw_CT_from_pt(s,tpot);

lat=permute(lat, [3 2 1]);
lon=permute(lon, [3 2 1]);
p=permute(p, [3 2 1]);
s=permute(s, [3 2 1]);
ct=permute(ct, [3 2 1]);

% Julien wrote 2014/08/18:
% "...caution : the last level is a partial step level  so that its thickness is a 2D function of 
%    space (you should probably get rid of this level for a first try."
sl=circshift(s,[-1 0 0]);
lowest=~isnan(s) & isnan(sl);
lowest(end,:,:)=false;
s(lowest)=nan;
ct(lowest)=nan;

s=double(s);
ct=double(ct);

lon(lon<0)=lon(lon<0)+360;




