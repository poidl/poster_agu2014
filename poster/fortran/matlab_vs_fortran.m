fname='/home/nfs/z3439823/mymatlab/neutral_common/data_scripts/wghc/convert_to_netcdf.py/wghc.nc';
[s,ct,p,lon,lat]=get_input_wghc_0p5deg(fname); % 0.5 deg resolution. This is just for comparison between matlab and fortran.

[s,ct,p,lon,lat]=crop_to_gamma_n(s,ct,p,lon,lat);
[s,ct]=only_keep_largest_region(s,ct); % remove everything except largest region
[s,ct]=remove_mediterranean(s,ct,p,lon,lat);
[s,ct,~]=remove_floating_nans(s,ct);



lon_=squeeze(lon(1,:,:));
lat_=squeeze(lat(1,:,:));
[ibb,ilat,ilon]=backbone_index(lon_,lat_);

[nz,ny,nx]=size(s);
p0=2000;

% as initial surface, we choose an iso-surface of potential density with reference pressure p0
s0=var_on_surf_stef(s(:,ibb),p(:,ibb),p0);
ct0=var_on_surf_stef(ct(:,ibb),p(:,ibb),p0);

s0_vec=s0*ones(1,nx*ny); % construct vector argument, repeat same bottle
ct0_vec=ct0*ones(1,nx*ny);
p0_vec=p0*ones(1,nx*ny);

% pot dens surface
[sns,ctns,pns]=depth_sig_simple(s0_vec,ct0_vec,p0_vec,s(:,:),ct(:,:),p(:,:));
sns=reshape(sns,[ny,nx]);
ctns=reshape(ctns,[ny,nx]);
pns=reshape(pns,[ny,nx]);

% we only keep the one single (connected) surface on which p0 is located.
[sns,ctns,pns] = get_connected(sns,ctns,pns,ibb);
    
save_netcdf_matfort(s,ct,p,sns,ctns,pns);

[erx,ery]=delta_tilde_rho(sns,ctns,pns);

regions=find_regions_coupled_system(pns,erx,ery);
[derr,res]=solve_lsqr_links_matfort(regions, erx, ery);

tic
[sns, ctns, pns] = depth_ntp_simple(sns(:)', ctns(:)', pns(:)', s(:,:), ct(:,:), p(:,:), derr(:)' );
display(['Root finding took ',num2str(toc),' sec.']);
sns=reshape(sns,[ny,nx]);
ctns=reshape(ctns,[ny,nx]);
pns=reshape(pns,[ny,nx]);

%%%%%%%%%%% gamma_n

% tis=gsw_t_from_CT(s(:,:),ct(:,:),p(:,:)); % in-situ
% 
% tic
% gamma_=gamma_n(s(:,:),tis,p(:,:),lon(1,:),lat(1,:));
% display(['Gamma_n took ',num2str(toc),' sec.']);           
            
            

