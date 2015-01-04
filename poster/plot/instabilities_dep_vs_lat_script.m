for ds=datasets
    make_dir(['./figures/',ds{:}])
    
    load(['./data_out/',ds{:},'/input_data.mat'])

    [nz,ny,nx]=size(s);
    lat_upper=lat(1:end-1,:,:);
    p_upper=p(1:end-1,:,:);
%%%%%%
% N^2

        sz=1.2*[10 10];
        figure('PaperSize',sz,'PaperPosition',[0 0 sz(1) sz(2)])
        [df,~]=gsw_Nsquared(s(:,:),ct(:,:),p(:,:));
        
        df=df<=0;        
        plot(lat_upper(df),-p_upper(df),'.','markersize',10)

        % save to netcdf for inspection
        df=reshape(df,[nz-1,ny,nx]);
        df=double(df);
        df(df==0)=nan;
        save_netcdf03(df,'df',['./data_out/',ds{:},'/df_n2.nc']);

        ylabel(ylab)
        xlabel(xlab)
ylim([-max(p(:)) 0])
xlim([-90 90])
        title(['Data: ',ds{:},'  Total num. N^2<=0: ',num2str(nansum(df(:)))],'Interpreter','none');
        grid on

        fout=['./figures/',ds{:},'/',fout_prefix,'_n2.pdf'];
        print('-dpdf','-r200',fout)
%%%%%%

    for ii=1:length(methods)
        sz=1.2*[10 10];
        figure('PaperSize',sz,'PaperPosition',[0 0 sz(1) sz(2)])

        meth=methods(ii);
        make_dir(['./figures/',ds{:},'/',meth{:}]);

        load(['./data_out/',ds{:},'/',meth{:},'/field.mat'])
        
        df=diff(field,1,1);
        df=df<=0;
        
        
        plot(lat_upper(df),-p_upper(df),'.','markersize',10)

        % save to netcdf for inspection
        df=double(df);
        df(df==0)=nan;
        save_netcdf03(df,'df',['./data_out/',ds{:},'/',meth{:},'/df.nc']);

        ylabel(ylab)
        xlabel(xlab)
ylim([-max(p(:)) 0])
xlim([-90 90])
        title([meth{:},'     Data: ',ds{:},'  Total num. instabilities: ',num2str(nansum(df(:)))],'Interpreter','none');
        grid on

        fout=['./figures/',ds{:},'/',meth{:},'/',fout_prefix,'.pdf'];
        print('-dpdf','-r200',fout)

    end
end
