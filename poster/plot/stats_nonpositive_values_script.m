
cols     ={'k.','bo','ro','go','co','mo','yo','ks','bs','rs','gs','cs','ms','ys'};
marker_sz=[10,(7:2:26)];
    
cols_=cols(1:length(methods)+1);
h=nan*ones(1,length(methods)+1);

total=nan*ones(1,length(methods)+1);
    
for ds=datasets
    make_dir(['./figures/',ds{:}])
    
    load(['./data_out/',ds{:},'/input_data.mat'])
    [n2,pmid]=gsw_Nsquared(s(:,:),ct(:,:),p(:,:));
    pmid=pmid(:,1);
    nn2=n2<=0;
    nn2=sum(nn2,2);
    total(1)=sum(nn2);
    %keyboard
    sz=1.2*[10 13];
    figure('PaperSize',sz,'PaperPosition',[0 0 sz(1) sz(2)])

    h(1)=semilogx(nn2,-pmid,cols_{1},'markersize',marker_sz(1));
    hold on
    for ii=1:length(methods)
        meth=methods(ii);
        make_dir(['./figures/',ds{:},'/',meth{:}]);
        load(['./data_out/',ds{:},'/',meth{:},'/field.mat'])
        df=diff(field(:,:),1,1);
        nnn=df<=0;
        nnn=sum(nnn,2);
        h(ii+1)=semilogx(nnn,-pmid,cols_{ii+1},'markersize',marker_sz(ii+1));
        total(ii+1)=sum(nnn);
    end

    % total to percent
    perc=100*total/sum(~isnan(field(:)));
    labels=['N^2',methods];
    for ii=1:length(labels)
        labels{ii}=[labels{ii}, ' (',num2str(total(ii)),' total)'];
    end
    legend(h,'location','southeast',labels,'Interpreter','none')

    ylabel(ylab)
    xlabel(xlab)
    title(['Data set: ',ds{:}],'Interpreter','none');
    grid on

    fout=['./figures/',ds{:},'/',fout_prefix,'.pdf'];
    print('-dpdf','-r200',fout)

end
