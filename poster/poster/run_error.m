function run_error(methods,datasets)


for ds=datasets
    load(['./data_out/',ds{:},'/input_data.mat'])
    
    for meth=methods
        load(['./data_out/',ds{:},'/',meth{:},'/field.mat'])
        x=contour_values(field,lon,lat,p);
        sms=local_error_mean_square(field,s,ct,p,lon,lat,x,'slope_difference');
        dms=local_error_mean_square(field,s,ct,p,lon,lat,x,'drho_local');
        vars={'x','sms','dms'};
        save(['./data_out/',ds{:},'/',meth{:},'/error_ms.mat'],vars{:})
    end
end

