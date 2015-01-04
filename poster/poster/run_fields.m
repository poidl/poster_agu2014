function run_fields(methods,datasets)

global_user_input; % reuse_intersections?

for ds=datasets
    dir=['./data_out/',ds{:}]; make_dir(dir);
    
    %[s,ct,p,lon,lat]=get_input_nemo_4deg();
    %dir='./data_out/fields/nemo_4deg'; make_dir(dir);
    %[s,ct,p,lon,lat]=get_input_wghc_4deg();
    %dir='./data_out/fields/wghc_4deg'; make_dir(dir);
    %[s,ct,p,lon,lat]=get_input_woa13_4deg();
    %dir='./data_out/fields/woa13_4deg'; make_dir(dir);
    switch ds{:}
        case 'jackett96'    
            path_to_gammanc='/home/nfs/z3439823/mymatlab/gamma_n';
            [s,ct,p,lon,lat]=get_input_jackett96(path_to_gammanc);

        case 'woa13_4deg'
            fname='/home/nfs/z3439823/mymatlab/neutral_common/data_scripts/WOA13/woa13.nc';
            [s,ct,p,lon,lat]=get_input_woa13_4deg(fname);

        case 'wghc_4deg'
            fname='/home/nfs/z3439823/mymatlab/neutral_common/data_scripts/wghc/convert_to_netcdf.py/wghc.nc';
            [s,ct,p,lon,lat]=get_input_wghc_4deg(fname);  

        case 'nemo_4deg'
            fname='/home/nfs/z3439823/mymatlab/neutral_common/data_scripts/nemo/nemo.nc';
            [s,ct,p,lon,lat]=get_input_nemo_4deg(fname); 

        case 'idealized01'
            [s,ct,p,lon,lat]=get_input_idealized01();

        case 'woa13_1deg'
            fname='/home/nfs/z3439823/mymatlab/neutral_common/data_scripts/WOA13/woa13.nc';
            [s,ct,p,lon,lat]=get_input_woa13_1deg(fname);

        case 'wghc_1deg'
            fname='/home/nfs/z3439823/mymatlab/neutral_common/data_scripts/wghc/convert_to_netcdf.py/wghc.nc';
            [s,ct,p,lon,lat]=get_input_wghc_1deg(fname);  

        case 'nemo_1deg'
            fname='/home/nfs/z3439823/mymatlab/neutral_common/data_scripts/nemo/nemo.nc';
            [s,ct,p,lon,lat]=get_input_nemo_1deg(fname); 
    end

    [s,ct,p,lon,lat]=crop_to_gamma_n(s,ct,p,lon,lat); % lon,lat = [0,360]x[-80,64]
    [s,ct]=only_keep_largest_region(s,ct); % remove everything except largest region
    [s,ct]=remove_mediterranean(s,ct,p,lon,lat);
    [s,ct,~]=remove_floating_nans(s,ct);
    s=stabilize(s,ct,p);

    vars={'s','ct','p','lat','lon'};
    save(['./data_out/',ds{:},'/input_data.mat'],vars{:})
    
    for meth=methods
        
        % diagnostics produced within a method are written to ./data, and
        % afterwards stored in either the data-set folder (e.g. intersections), or the method folder
        % (e.g. execution time)
        if exist('./data/exec_time','dir') % remove execution time data folder
            rmdir('./data/exec_time','s')
        end
        if exist('./data/intersections.mat','file') % neutral segments produced by the gamma_i variations
            delete('./data/intersections.mat')
        end

        if strcmp(meth,'gamma_n')
            [field]=get_gamma_n(s,ct,p,lon,lat);

        elseif strcmp(meth,'ew99_v1')
            field=ew99_v1(s,ct,p,lon,lat);

        elseif strcmp(meth,'ew99_v2')
            field=ew99_v2(s,ct,p,lon,lat);
            
        elseif strcmp(meth,'ew99_v3')
            field=ew99_v3(s,ct,p,lon,lat);            
            
        elseif strcmp(meth,'ew99mod_v1')
            field=ew99mod_v1(s,ct,p,lon,lat);

        elseif strcmp(meth,'ew99mod_v2')
            field=ew99mod_v2(s,ct,p,lon,lat);
            
        elseif strcmp(meth,'ew99mod_v3')
            field=ew99mod_v3(s,ct,p,lon,lat);            

        elseif strcmp(meth,'gamma_i_v1') 
            if reuse_intersections
                restore_intersections(ds);
            end
            field = gamma_3d_v1(s,ct,p,lon,lat);

        elseif strcmp(meth,'gamma_i_v2') 
            if reuse_intersections
                restore_intersections(ds);
            end
            field = gamma_3d_v2(s,ct,p,lon,lat);
            
        elseif strcmp(meth,'gamma_i_initial_gamma_n') 
            field = gamma_3d_initial_gamma_n(s,ct,p,lon,lat);            
            
        elseif strcmp(meth,'sig0')
            tic
            field=gsw_sigma0(s,ct);
            exec_time_write('./data/exec_time/runtime_sig0.txt',toc)

        elseif strcmp(meth,'sig2')
            field=gsw_sigma2(s,ct);
            
        elseif strcmp(meth,'sig4')    
            field=gsw_sigma4(s,ct);
            
        else
            error('not implemented')
        end
        
        if exist('./data/exec_time','dir') % if method has dumped execution time data, move it to method folder
            movefile('./data/exec_time/*',['./data_out/',ds{:},'/',meth{:}])
        end
        if exist('./data/intersections.mat','file') % if method has dumped neutral segments, move them to data set folder
            movefile('./data/intersections.mat',['./data_out/',ds{:}])
        end

        dir=['./data_out/',ds{:},'/',meth{:}]; make_dir(dir);
        save([dir,'/field.mat'],'field')
        
    end
    
end


