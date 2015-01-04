restoredefaultpath
addpath(genpath('..'))

global_user_input
 path_to_gammanc='/home/nfs/z3439823/mymatlab/neutral_common/gamma_n/gamma_JackettMcDougall96';
 [s,ct,p,lon,lat]=get_input_jackett96_no_land_mask(path_to_gammanc);
% fname='/home/nfs/z3439823/mymatlab/neutral_common/data/WOA13/woa13.nc';
% [s,ct,p,lon,lat]=get_input_woa13_4deg(fname);
%fname='/home/nfs/z3439823/mymatlab/neutral_common/data/wghc/convert_to_netcdf.py/wghc.nc';
%[s,ct,p,lon,lat]=get_input_wghc_4deg(fname);  
%fname='/home/nfs/z3439823/mymatlab/neutral_common/data/nemo/nemo.nc';
%[s,ct,p,lon,lat]=get_input_nemo_4deg(fname);

[nz,ny,nx]=size(s);
[ocean, n] = gamma_ocean_and_n(s,ct,p,lon,lat);

ss=squeeze(s(1,:,:));
ss( ocean(:)~=1 & ocean(:)~=5)=nan;

regs1=find_regions(ss);

% dummy ex and ey
ex=circshift(ss,[0 -1])-ss;
ey=circshift(ss,[-1 0])-ss;
if ~zonally_periodic
    ex(:,end)=nan;
end
ey(end,:)=nan;


% the rule: disconnect North Indian from North Pacific
% (Thailand/Malaysia/Indonesia not resolved) and North Pacific from North
% Atlantic (Central America not resolved)

test=ocean(:).*circshift(ocean(:),-ny);
en_in_other_basin= (test==5); % eastern neighbour in other basin
ex(en_in_other_basin)=nan;

test=ocean(:).*circshift(ocean(:),-1);
nn_in_other_basin= (test==5); % northern neighbour in other basin
ey(nn_in_other_basin)=nan;

regs2=find_regions_coupled_system(ss,ex,ey);
if length(regs2)~=3
    error('error'
end


