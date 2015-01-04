

cols={'k','b','r','g','c','m','y','k--','b--','r--','g--','c--','m--','y--'};
    

cols_=cols(1:length(methods));
h=nan*ones(1,length(methods));
    
for ds=datasets
    make_dir(['./figures/',ds{:}])
    
    load(['./data_out/',ds{:},'/input_data.mat'])

    sz=1.5*[10 12];
    figure('PaperSize',sz,'PaperPosition',[0 0 sz(1) sz(2)])
    %keyboard 
    for ii=1:length(methods)
        meth=methods(ii);
        make_dir(['./figures/',ds{:},'/',meth{:}]);
        load(['./data_out/',ds{:},'/',meth{:},'/field.mat'])
        load(['./data_out/',ds{:},'/',meth{:},'/error_ms_grid.mat'])
        if strcmp(error,'df')
            h(ii)=semilogx(1e3*sms,-x,cols_{ii});
        elseif strcmp(error,'dms')
            error('dms hasn''t been computed on the grid')
%keyboard
        end
        hold on
%keyboard
    end

xl1=-6;
xl2=2;

%ylim([y1 y2]);
%ylim([1e-6 1e6]);
%xlim([xl1,xl2]);

legend(h,'location','northeast',methods,'Interpreter','none')
    
ylabel(ylab)
xlabel(xlab)
title(['Data set: ',ds{:}],'Interpreter','none');
grid on

fout=['./figures/',ds{:},'/',fout_prefix,'.pdf'];
print('-dpdf','-r200',fout)



end
