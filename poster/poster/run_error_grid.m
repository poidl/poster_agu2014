function run_error_grid(methods,datasets)


for ds=datasets
    load(['./data_out/',ds{:},'/input_data.mat'])
    disp(ds{:})
    for meth=methods
        disp(meth{:})
        load(['./data_out/',ds{:},'/',meth{:},'/field.mat'])
        x=p(:,1,1);
        [sms,e2]=local_error_square_grid(field,s,ct,p,lon,lat,'slope_difference');
        vars={'x','sms'};
        save(['./data_out/',ds{:},'/',meth{:},'/error_ms_grid.mat'],vars{:})
        save(['./data_out/',ds{:},'/',meth{:},'/e2_grid.mat'],'e2')
    end
end
