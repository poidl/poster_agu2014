function plot_field(methods,datasets)

close all

ntransects=24; % number of y-z transects
%xlab='latitude [deg]';
title_prefix='field';
fout_prefix='field';


for ds=datasets
    make_dir(['./figures/',ds{:}])
    load(['./data_out/',ds{:},'/input_data.mat'])
    
    [nz,ny,nx]=size(s);

    for ii=1:length(methods)
        meth=methods(ii);
        make_dir(['./figures/',ds{:},'/',meth{:}]);
        disp([ds{:},', ',meth{:}])
        load(['./data_out/',ds{:},'/',meth{:},'/field.mat'])

        save_netcdf03(field,'field',['./data_out/',ds{:},'/',meth{:},'/field.nc'])
        
        va=field;

        z=squeeze(p(:,1,1));
        plot_page_script;
        
    end

end