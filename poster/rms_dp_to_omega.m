function rms_dp_to_omega(methods,datasets)


for ds=datasets
    load(['./data_out/',ds{:},'/input_data.mat'])
    load(['./data_out/',ds{:},'/omega_3d.mat'])

    [ibb,~,~]=backbone_index(squeeze(lon(1,:,:)),squeeze(lat(1,:,:)));
    disp(ds{:})
    for meth=methods
        load(['./data_out/',ds{:},'/',meth{:},'/field.mat']); 

        lon_=squeeze(lon(1,:,:));
        lat_=squeeze(lat(1,:,:));
        ns=size(pns3d,1);
        %y=pns3d(:,ibb); 
        
        rms_dp=nan*ones(1,ns);

        for ii=1:ns
            p0=pns3d(ii,ibb);
            point=[p0 ibb];
            pis=iso_surface_pressure(field,p,point);
            dp=pis-squeeze(pns3d(ii,:,:));
            rms_dp(ii)=sqrt(area_mean(dp.^2,lon_,lat_));
            %fsm=area_mean(fs,dx_,dy_);
            %stdo(ii)=sqrt(area_mean((fs-fsm).^2,dx_,dy_));
        end

        rms_dp_to_omega=rms_dp;
        save(['./data_out/',ds{:},'/',meth{:},'/rms_dp_to_omega.mat'],'rms_dp_to_omega');

    end
end
