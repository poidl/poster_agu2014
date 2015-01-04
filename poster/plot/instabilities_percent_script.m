perc=nan*ones(1,length(methods)+1); % percent of volume
npts=nan*ones(1,length(methods)+1); % number of unstable pairs
 
for ds=datasets
    make_dir(['./figures/',ds{:}])
    
    load(['./data_out/',ds{:},'/input_data.mat'])
    
    vol=get_volume_grid_horz(s,lon,lat,p);  
    %vol=vol(1:end-1,:,:);

    [n2,~]=gsw_Nsquared(s(:,:),ct(:,:),p(:,:));
    nn2=n2<=0;
    
    npts(1)=sum(nn2(:));
    perc(1)= sum(vol(nn2(:)));
%keyboard
    for ii=1:length(methods)
        meth=methods(ii);
        make_dir(['./figures/',ds{:},'/',meth{:}]);
        load(['./data_out/',ds{:},'/',meth{:},'/field.mat'])
        df=diff(field(:,:),1,1);
        nn2=df<=0;

        npts(ii+1)=sum(nn2(:));
        perc(ii+1)= sum(vol(nn2(:)));
    end

    % cut sigmas. the values are so large for sigmas that we'd have to use a
    % logarithmic axis...
    npts=npts(1:end-3);
    perc=perc(1:end-3);

    sz=1.5*[10 7];
    figure('PaperSize',sz,'PaperPosition',[0 0 sz(1) sz(2)])

    x=(1:length(npts));
    w=0.4; % bar width

    [ax,p1,p2] =plotyy(x-0.2,perc,x+0.2,npts,'bar','bar')
    set(p1,'facecolor','b','barwidth',w)
    set(p2,'facecolor','r','barwidth',w)
    %set(ax(1),'ycolor','b')
    %set(ax(2),'ycolor','r')
    ylabel(ax(1),'% unstable ocean','color','b') % label left y-axis
    ylabel(ax(2),'number of unstable points','color','r') % label right y-axis

    set(ax(1),'XTick',x)
    set(ax(2),'XTick',x)
    meth=methods;
    meth=['n2',meth(1:end-3)];
    set(ax(1),'XTicklabel',meth)
    set(ax(2),'XTicklabel',meth)
    %set(ax(2),'XTicklabel',['fd','asf','afsd','asfd'])
    %set(ax(2),'XTick',['fd','asf','afsd','asfd'])

    title(['Data set: ',ds{:}],'Interpreter','none');
    grid on

    fout=['./figures/',ds{:},'/',fout_prefix,'.pdf'];
    print('-dpdf','-r200',fout)

end
