function stats_pdf_error_allmethods(methods,datasets)

close all

error='s2';
xlab='D_f [m^2/s]';
fout_prefix='stats_pdf_error_allmethods';


cols={'k','b','r','g','c','m','y','k--','b--','r--','g--','c--','m--','y--'};

for ds=datasets
    make_dir(['./figures/',ds{:}])
    
    load(['./data_out/',ds{:},'/input_data.mat'])
    
    sz=1.2*[20 10];
    figure('PaperSize',sz,'PaperPosition',[0 0 sz(1) sz(2)]);
    
    for ii=1:length(methods)


        meth=methods(ii);
        make_dir(['./figures/',ds{:},'/',meth{:}]);
        if strcmp(error,'s2')
            load(['./data_out/',ds{:},'/',meth{:},'/e2_grid.mat'])
        else
            error('not implemented')
        end

        nbins=600;
        [x,y,freq]=get_pdf_log(1000*e2,lon,lat,p,nbins);
        %h=loglog(x,y,cols{ii});
        h=semilogx(x,y,cols{ii});
        hold on
    end
    
    %ylim([1e-6 1e6]);
	%xlim([xl1,xl2]);
	
	ylabel('pdf') % label left y-axis
	xlabel(xlab)
	title(['Data set: ',ds{:}],'Interpreter','none');
	grid on

	fout=['./figures/',ds{:},'/',fout_prefix,'.pdf'];
	print('-dpdf','-r200',fout)
	%keyboard
end
