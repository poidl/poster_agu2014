function plot_dgdz(methods,datasets)

close all

ntransects=24; % number of y-z transects
%xlab='latitude [deg]';
title_prefix='log10(-dg/dz) ';
fout_prefix='dgdz';
 

methods=['n3',methods];
for ds=datasets
    make_dir(['./figures/',ds{:}])
    load(['./data_out/',ds{:},'/input_data.mat'])
    
    [nz,ny,nx]=size(s);
    [dx,dy,dz]=get_dx(lon,lat,p);
    
    
    
    sl=circshift(s,[-1 0 0]);
    ctl=circshift(ct,[-1 0 0]);
    pmid=0.5*(p+circshift(p,[-1 0 0]));
    pmid(end,:,:)=nan;
    n3=(gsw_rho(s,ct,pmid)-gsw_rho(sl,ctl,pmid));
    n3=n3./dz;
    pmid=pmid(1:end-1,:,:);
    n3=n3(1:end-1,:,:);
    
    save_netcdf03(n3,'n3',['./data_out/',ds{:},'/n3.nc'])

    va=n3;
    z=squeeze(pmid(:,:,1));
    meth=methods(1); % n2
    plot_page_script_n2;
    
    for ii=2:length(methods)
        meth=methods(ii);
        make_dir(['./figures/',ds{:},'/',meth{:}]);
        disp([ds{:},', ',meth{:}])
        load(['./data_out/',ds{:},'/',meth{:},'/field.mat'])
        
        df=-diff(field,1,1);
        dgdz=df./dz(1:end-1,:,:);
        va=dgdz;
        z=squeeze(pmid(:,:,1));
        plot_page_script_n2;
        
    end


end