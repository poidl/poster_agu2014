for ds=datasets
    make_dir(['./figures/',ds{:}])
    
    load(['./data_out/',ds{:},'/input_data.mat'])

    for ii=1:length(methods)
        sz=1.5*[10 10];
        figure('PaperSize',sz,'PaperPosition',[0 0 sz(1) sz(2)])

        meth=methods(ii);
        make_dir(['./figures/',ds{:},'/',meth{:}]);
        if strcmp(error,'s2')
            load(['./data_out/',ds{:},'/',meth{:},'/e2_grid.mat'])
        else
            error('not implemented')
        end

        y=get_percent_larger(e2,thresh);
        z=squeeze(p(:,1,1));
        barh(-z,y,'style','hist')
        
        dz=diff(z);
        ylim([-z(end)-0.8*dz(end),100])
        ylabel('depth [m]')
        xlabel([xlab_prefix,num2str(thresh),xlab_suffix])
        title(['Data set: ',ds{:},'   Method: ',meth{:}],'Interpreter','none');
        grid on

        fout=['./figures/',ds{:},'/',meth{:},'/',fout_prefix,'.pdf'];
        print('-dpdf','-r200',fout)

    end

end
