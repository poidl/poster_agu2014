function plot_b(methods,datasets)

close all

ntransects=24; % number of y-z transects
%xlab='latitude [deg]';
title_prefix='b';
fout_prefix='b';
 
for ds=datasets
    make_dir(['./figures/',ds{:}])
    load(['./data_out/',ds{:},'/input_data.mat'])
    
    [nz,ny,nx]=size(s);
    
    sl=circshift(s,[-1 0 0]);
    ctl=circshift(ct,[-1 0 0]);
    pmid=0.5*(p+circshift(p,[-1 0 0]));
    pmid(end,:,:)=nan;
    n3=(gsw_rho(s,ct,pmid)-gsw_rho(sl,ctl,pmid));
    pmid=pmid(1:end-1,:,:);
    n3=n3(1:end-1,:,:);
    
    
    
    for ii=1:length(methods)
        meth=methods(ii);
        make_dir(['./figures/',ds{:},'/',meth{:}]);
        disp([ds{:},', ',meth{:}])
        load(['./data_out/',ds{:},'/',meth{:},'/field.mat'])
        df=-diff(field,1,1);
        b=df./n3;
        
        save_netcdf03(b,'b',['./data_out/',ds{:},'/',meth{:},'/b.nc'])
        
        
        va=b;
        z=squeeze(pmid(:,1,1));
        plot_page_script;
        
    end


end