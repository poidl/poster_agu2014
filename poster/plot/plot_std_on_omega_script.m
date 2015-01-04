

cols={'k','b','r','g','c','m','y','k--','b--','r--','g--','c--','m--','y--'};
    

cols_=cols(1:length(methods));
h=nan*ones(1,length(methods));
    
for ds=datasets
    make_dir(['./figures/',ds{:}])
    
    load(['./data_out/',ds{:},'/input_data.mat'])
    load(['./data_out/',ds{:},'/omega_3d.mat'])
    sz=1.5*[13 10];
    figure('PaperSize',sz,'PaperPosition',[0 0 sz(1) sz(2)])
    [ibb,~,~]=backbone_index(squeeze(lon(1,:,:)),squeeze(lat(1,:,:)));
    x=pns3d(:,ibb);
    for ii=1:length(methods)
        meth=methods(ii);
        make_dir(['./figures/',ds{:},'/',meth{:}]);
        load(['./data_out/',ds{:},'/',meth{:},'/std_on_omega.mat'])
%keyboard
        h(ii)=semilogy(x,std_on_omega,cols_{ii});
        hold on
    end
    

%keyboard


legend(h,'location','northeast',methods,'Interpreter','none')
    
ylabel(ylab)
xlabel(xlab)
title(['Data set: ',ds{:}],'Interpreter','none');
grid on

fout=['./figures/',ds{:},'/',fout_prefix,'.pdf'];
print('-dpdf','-r200',fout)

end
