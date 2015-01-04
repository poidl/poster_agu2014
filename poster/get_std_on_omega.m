function get_std_on_omega(methods,datasets)


for ds=datasets
    load(['./data_out/',ds{:},'/input_data.mat'])
    load(['./data_out/',ds{:},'/omega_3d.mat'])

    lat_=squeeze(lat(1,:,:));
    lon_=squeeze(lon(1,:,:));

    for meth=methods
        load(['./data_out/',ds{:},'/',meth{:},'/field.mat']); 

        ns=size(pns3d,1);
        stdo=nan*ones(1,ns);

        for ii=1:ns
            disp(num2str(ii))
            fs=var_on_surf_stef(field,p,pns3d(ii,:,:));
            fsm=area_mean(fs,lon_,lat_);
            stdo(ii)=sqrt(area_mean((fs-fsm).^2,lon_,lat_));
        end

        std_on_omega=stdo;
        save(['./data_out/',ds{:},'/',meth{:},'/std_on_omega.mat'],'std_on_omega');

    end
end

