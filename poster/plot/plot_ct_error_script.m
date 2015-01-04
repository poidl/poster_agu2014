
for ds=datasets
    make_dir(['./figures/',ds{:}])
    
    load(['./data_out/',ds{:},'/input_data.mat']) 

    sz=1.2*[20 10];
    figure('PaperSize',sz,'PaperPosition',[0 0 sz(1) sz(2)])

    [ibb_horz,i,j]=backbone_index(squeeze(lon(1,:,:)),squeeze(lat(1,:,:)));
    %keyboard 
    for ii=1:length(methods)
        meth=methods(ii);
        make_dir(['./figures/',ds{:},'/',meth{:}]);
        load(['./data_out/',ds{:},'/',meth{:},'/field.mat']);
        %keyboard
        f_mean=nanmean(field(:));
        sig_mean=nanmean(gsw_sigma0(squeeze(s(:)),squeeze(ct(:))));        
        field=field-f_mean+sig_mean;
        %ct_mean=nanmean(ct(:))
        %field=field-f_mean+ct_mean;

        f=squeeze(field(:,:,i));
        %exact=squeeze(ct(:,:,i));
        exact=gsw_sigma0(squeeze(s(:,:,i)),squeeze(ct(:,:,i)));
        contourf(f-exact)
        colorbar()

        ylabel(ylab)
        xlabel(xlab)
        title(['Data set: ',ds{:}],'Interpreter','none');
        grid on

        fout=['./figures/',ds{:},'/',meth{:},'/',fout_prefix,'.pdf'];
        print('-dpdf','-r200',fout)
    end
end
       