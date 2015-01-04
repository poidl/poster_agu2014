function omega_surfaces(datasets)

for ds=datasets
    load(['./data_out/',ds{:},'/input_data.mat'])

    lon_=squeeze(lon(1,:,:));
    lat_=squeeze(lat(1,:,:));
    [ibb,ilat,ilon]=backbone_index(lon_,lat_);
%     % complicated? could take pbb=linspace(0,bottom) 
%     
%     ia=ilat+(-1:1);
%     io=ilon+(-1:1);
%     gamma_cuboid=get_gamma_n(s(:,ia,io),ct(:,ia,io),p(:,ia,io),lon(:,ia,io),lat(:,ia,io));
%     gvals=contour_values(gamma_cuboid,lon(:,ia,io),lat(:,ia,io),p(:,ia,io));
%     gamma_cast=get_gamma_n(s(:,ibb),ct(:,ibb),p(:,ibb),lon(:,ibb),lat(:,ibb));
% 
%     pbb=nan*gvals;
%     ns=length(pbb);
%     for ii=1:ns
%         pbb(ii)=var_on_surf_stef(p(:,ibb),gamma_cast,gvals(ii));
%     end
%     gvals=gvals(~isnan(pbb));
%     pbb=pbb(~isnan(pbb));
    pbot=p(sum(~isnan(s(:,ibb))),ibb);
    pbb=linspace(0,pbot,102);
    pbb=pbb(2:end-1);
    % get gamma_n values at clamping points
    %sbb=interp1(p(:,ibb),s(:,ibb),pbb);
    %ctbb=interp1(p(:,ibb),ct(:,ibb),pbb);
    %gvals=get_gamma_n(sbb',ctbb',pbb',lon(:,ibb),lat(:,ibb));
    ns=length(pbb);

    [~,yn,xn]=size(s);
    sns3d=nan*ones(ns,yn,xn);
    ctns3d=sns3d;
    pns3d=sns3d;
    sms=nan*ones(1,ns);
    dms=nan*ones(1,ns);

    for kk=1:ns
        point=[pbb(kk) ibb];
        display(['pressure ',num2str(pbb(kk))]);
        [sns,ctns,pns] =optimize_surface_at_point(s,ct,p,lon,lat,point);
        sms(kk)=error_surface(sns,ctns,pns,s,ct,p,lon,lat,'slope_difference');
        dms(kk)=error_surface(sns,ctns,pns,s,ct,p,lon,lat,'drho_local');
        sns3d(kk,:,:)=sns;
        ctns3d(kk,:,:)=ctns;
        pns3d(kk,:,:)=pns;
    end

    save(['./data_out/',ds{:},'/omega_3d.mat'],'pns3d','sms','dms')
    save_netcdf03(pns3d,'pns3d',['./data_out/',ds{:},'/omega_3d.nc'])
end

