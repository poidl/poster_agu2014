for ds=datasets
    make_dir(['./figures/',ds{:}])
    
    load(['./data_out/',ds{:},'/input_data.mat'])

    for ii=1:length(methods)
        sz=1.2*[20 10];
        figure('PaperSize',sz,'PaperPosition',[0 0 sz(1) sz(2)])

        meth=methods(ii);
        make_dir(['./figures/',ds{:},'/',meth{:}]);
        if strcmp(error,'s2')
            load(['./data_out/',ds{:},'/',meth{:},'/e2_grid.mat'])
        else
            error('not implemented')
        end

        nbins=600;
        [x,y,freq]=get_pdf_log(1000*e2,lon,lat,p,nbins);
%keyboard
        [ax,p1,p2] =plotyy(x,y,x,freq,'loglog','loglog','linestyle','.','linestyle','.');

        set(p1,'marker','.','linestyle','.','markersize',10)
        set(p2,'marker','.','linestyle','.','markersize',10,'color','r')
        set(ax(2),'ycolor','r')
        %ylim([1e-6 1e6]);
        %xlim([xl1,xl2]);
        
        ylabel(ax(1),'pdf') % label left y-axis
        ylabel(ax(2),'frequency') % label right y-axis
        xlabel(xlab)
        title([meth{:},'    Data set: ',ds{:}],'Interpreter','none');
        grid on

        fout=['./figures/',ds{:},'/',meth{:},'/',fout_prefix,'.pdf'];
        print('-dpdf','-r200',fout)

    end
end
