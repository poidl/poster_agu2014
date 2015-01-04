function [s,ct,p,lon,lat]=get_input_woa13_1deg(fname)

lat=ncread(fname,'lat');
lon=ncread(fname,'lon');
p=ncread(fname,'p');
s=ncread(fname,'s');
tis=ncread(fname,'tis'); % in situ temp

s=gsw_SA_from_SP(s,p,lon,lat);
ct=gsw_CT_from_t(s,tis,p);

lat=permute(lat, [3 2 1]);
lon=permute(lon, [3 2 1]);
p=permute(p, [3 2 1]);
s=permute(s, [3 2 1]);
ct=permute(ct, [3 2 1]);

lon(lon<0)=lon(lon<0)+360;

%keyboard
