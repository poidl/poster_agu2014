function plot_bb_section(methods,datasets)


close all

%ntransects=24; % number of y-z transects
%xlab='latitude [deg]';
%title_prefix='field';
fout_prefix='bb_section';


for ds=datasets
    make_dir(['./figures/',ds{:}])
    load(['./data_out/',ds{:},'/input_data.mat'])
    
    
    [ibb,ilon,ilat]=backbone_index(squeeze(lon(1,:,:)),squeeze(lat(1,:,:)));

    for ii=1:length(methods)
        meth=methods(ii);
        make_dir(['./figures/',ds{:},'/',meth{:}]);
        disp([ds{:},', ',meth{:}])
        load(['./data_out/',ds{:},'/',meth{:},'/field.mat'])
       
        sz=1*[18 10]; % A4 = [21 29.7] cm 
        figure('PaperSize',sz,'PaperUnits','centimeters','PaperPosition',[0 0 sz(1) sz(2)],'Visible','off')  
        
        plot_mypatch(field,s,lon,lat,p,ilon);
        title(['ND field at', num2str(lon(1,ibb)), 'E. Backbone at ', num2str(lat(1,ibb)), 'N. (',ds{:},', ',meth{:},')'],'interpreter','none')
        hold on
        kbot=sum(~isnan(s(:,ibb)));
        pbot=p(kbot,ibb);
        yl=ylim;
        plot(lat(1,ibb)*[1 1],[ yl(1) pbot],'linewidth',2)
        grid on
        set(gca,'layer','top')
        xlim([-90 90])
%set(gcf, 'Renderer', 'opengl')
        fout=['./figures/',ds{:},'/',meth{:},'/',fout_prefix,'.pdf'];
        print('-dpng','-r200',fout) % pdf will make white striped grid
        %keyboard
    end

end