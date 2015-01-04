function plot_field_on_omega(methods,datasets)

close all

%ntransects=24; % number of y-z transects
%xlab='latitude [deg]';
title_prefix='f on omega';
fout_prefix='f_on_omega';


for ds=datasets
    make_dir(['./figures/',ds{:}])
    make_dir(['./figures/',ds{:}])
    load(['./data_out/',ds{:},'/input_data.mat'])
    load(['./data_out/',ds{:},'/omega_3d.mat'])
    
    [ibb,ilon,ilat]=backbone_index(squeeze(lon(1,:,:)),squeeze(lat(1,:,:)));
    la=squeeze(lat(1,:,ilon)); % WRONG: nemo grid non-isotropic in lat/lon !
    lo=squeeze(lon(1,ilat,:));

    lo(lo>lo(end))=lo(lo>lo(end))-360;
    %keyboard
    for ii=1:length(methods)
        meth=methods(ii);

        make_dir(['./figures/',ds{:},'/',meth{:}]);
        make_dir(['./figures/',ds{:},'/',meth{:}]);
        disp([ds{:},', ',meth{:}])
        load(['./data_out/',ds{:},'/',meth{:},'/field.mat'])
        

        
        [ns,ny,nx]=size(pns3d);
        va=nan*pns3d;
        for k=1:ns
            v=var_on_surf_stef(field,p,squeeze(pns3d(k,:,:)));
            va(k,:,:)=v-nanmean(v(:));
        end
        
        
        nsurf=24; % number of surfaces to plot
        plot_page_script_omega;

    end

end
