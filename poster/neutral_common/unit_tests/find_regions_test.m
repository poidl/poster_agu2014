restoredefaultpath
addpath(genpath('..'))

global_user_input
% path_to_gammanc='/home/nfs/z3439823/mymatlab/neutral_common/gamma_n/gamma_JackettMcDougall96';
% [s,ct,p,lon,lat]=get_input_jackett96(path_to_gammanc);
% fname='/home/nfs/z3439823/mymatlab/neutral_common/data/WOA13/woa13.nc';
% [s,ct,p,lon,lat]=get_input_woa13_4deg(fname);
fname='/home/nfs/z3439823/mymatlab/neutral_common/data/wghc/convert_to_netcdf.py/wghc.nc';
[s,ct,p,lon,lat]=get_input_wghc_4deg(fname);  
%fname='/home/nfs/z3439823/mymatlab/neutral_common/data/nemo/nemo.nc';
%[s,ct,p,lon,lat]=get_input_nemo_4deg(fname); 

ss=squeeze(s(1,:,:));
regs1=find_regions(ss);

% dummy ex and ey
ex=circshift(ss,[0 -1])-ss;
ey=circshift(ss,[-1 0])-ss;
if ~zonally_periodic
    ex(:,end)=nan;
end
ey(end,:)=nan;

regs2=find_regions_coupled_system(ss,ex,ey);


if length(regs1)~=length(regs2) 
    error('found different number of regions')
end
for ii=1:length(regs1)
    if length(regs1{ii})~=length(regs2{ii}) 
        error('regions of different size')
    elseif ~isempty(setdiff(regs1{ii},regs2{ii}))
        error('point set not identical')
    end
end
disp('success')

        