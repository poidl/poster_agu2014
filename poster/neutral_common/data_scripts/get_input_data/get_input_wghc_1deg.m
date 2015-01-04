function [s,ct,p,lon,lat]=get_input_wghc_1deg(fname)

% resolution of original set is 0.5 deg
lat=ncread(fname,'lat');
lon=ncread(fname,'lon');
p=ncread(fname,'p');
s=ncread(fname,'s');
tis=ncread(fname,'tis'); % in situ temp

% subsampling to 1 deg resolution (ATTENTION INDICES: (LON,LAT,DEPTH))
lat=lat(1:2:end,1:2:end,:);
lon=lon(1:2:end,1:2:end,:);
p=p(1:2:end,1:2:end,:);
s=s(1:2:end,1:2:end,:);
tis=tis(1:2:end,1:2:end,:);

s=gsw_SA_from_SP(s,p,lon,lat);
ct=gsw_CT_from_t(s,tis,p);

lat=permute(lat, [3 2 1]);
lon=permute(lon, [3 2 1]);
p=permute(p, [3 2 1]);
s=permute(s, [3 2 1]);
ct=permute(ct, [3 2 1]);




