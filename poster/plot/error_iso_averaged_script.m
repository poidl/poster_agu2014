cols={'k','b','r','g','c','m','y','k--','b--','r--','g--','c--','m--','y--'};
    
plot_omega=0;
if plot_omega
    cols_=cols(1:length(methods)+1); % plus one for omega surfaces
    h=nan*ones(1,length(methods)+1); 
else
    cols_=cols(1:length(methods)); 
    h=nan*ones(1,length(methods)); 
end

for ds=datasets
    make_dir(['./figures/',ds{:}])
    
    load(['./data_out/',ds{:},'/input_data.mat'])

    if strcmp(mapto,'sig0')
        g=gsw_sigma0(s,ct);
    elseif strcmp(mapto,'sig2')
        g=gsw_sigma2(s,ct);
    elseif strcmp(mapto,'sig4')
        g=gsw_sigma4(s,ct);
    end 

    sz=1.2*[20 10];
    figure('PaperSize',sz,'PaperPosition',[0 0 sz(1) sz(2)])
    %keyboard 
    for ii=1:length(methods)
        meth=methods(ii);
        make_dir(['./figures/',ds{:},'/',meth{:}]);
        load(['./data_out/',ds{:},'/',meth{:},'/field.mat']);
        load(['./data_out/',ds{:},'/',meth{:},'/error_ms.mat']);
        x=map_contour_values(field,x,g,lon,lat,p);
         
        if strcmp(error,'df')
            h(ii)=semilogy(x,1e3*sms,cols_{ii});
        elseif strcmp(error,'dms')
            h(ii)=semilogy(x,sqrt(dms),cols_{ii});
%keyboard
        end
        hold on

%keyboard
    end

if plot_omega
    % get the error of omega surfaces
    load(['./data_out/',ds{:},'/omega_3d.mat'])
    [ns,~,~]=size(pns3d);
    xs=nan*ones(1,ns);
    %keyboard
    %keyboard
    for kk=1:ns
        gns=var_on_surf_stef(g,p,squeeze(pns3d(kk,:,:)));
        xs(kk)=area_mean(gns,squeeze(lon(1,:,:)),squeeze(lat(1,:,:)));
    end
    if strcmp(error,'df')
        h(ii+1)=semilogy(xs,1e3*sms,cols_{length(methods)+1});
    elseif strcmp(error,'dms')
        h(ii+1)=semilogy(xs,sqrt(dms),cols_{length(methods)+1});
    end
end
    

xl1=-6;
xl2=2;

ylim([y1 y2]);
%ylim([1e-6 1e6]);
%xlim([xl1,xl2]);
if plot_omega
    labels=[methods,'omega'];
else
    labels=[methods];
end
legend(h,'location','northwest',labels,'Interpreter','none')
    
xlab=['surface average of ',mapto, ' [kg/m^3]'];
ylabel(ylab)
xlabel(xlab)
title(['Data set: ',ds{:}],'Interpreter','none');
grid on

fout=['./figures/',ds{:},'/',fout_prefix,'_',mapto,'.pdf'];
print('-dpdf','-r200',fout)

end




%print('-dpdf','-r200',['../figures/hist.pdf'])


% 
% dirs = strsplit(ls('../data_out/error_ms*','-d'));
% if strcmp(dirs{end},'')  % remove empty string at the end
%     dirs(end)=[];
% end
% for dir = dirs
% 
%     files = strsplit(ls(['../data_out/',dir{:},'/error_ms*']));
%     if strcmp(files{end},'')  % remove empty string at the end
%         files(end)=[];
%     end
%     cols_=cols(1:length(files));
%     h=nan*ones(1,length(files));
%     
%     sz=1.5*[13 10];
%     figure('PaperSize',sz,'PaperPosition',[0 0 sz(1) sz(2)]) 
%     vnames={};
% 
% 
%     
%     for ii=1:length(files)
%         file=files(ii);
%         load(file{:});
% %         cx=[x,cx];
% %         cg=[g,cg];
% %         csms=[sms,csms];
% %         cdms=[dms,cdms];
%         vnames=[vname,vnames];
%         
%         h(ii)=semilogy(g,sms,cols_{ii})
%         hold on
%         
%     end
% end
% 
% xl1=-6;
% xl2=2;
% ylim([1e-13 1e-4]);
% %xlim([xl1,xl2]);
% 
% keyboard
% 
% 
% sz=1.5*[13 10];
% figure('PaperSize',sz,'PaperPosition',[0 0 sz(1) sz(2)]) 
% 
% 
% 
% h1=semilogy(x1,y1,'b')
% hold on
% semilogy(x1,y1,'bo')
% h2=semilogy(x2,y2,'r')
% semilogy(x2,y2,'ro')
% %h2=plot(x2,y2,'r')
% %plot(x2,y2,'ro')
% % h3=plot(x3,y3,'g')
% % plot(x3,y3,'go')
% 
% xl1=-6;
% xl2=2;
% ylim([1e-12 1e-4]);
% xlim([xl1,xl2]);
% 
% ylabel('D_f [m^2/s]')
% xlabel('value of iso-surface')
% grid on
% 
% 
% 
% %legend([h1 h2 pp],'backbone: \gamma_{rf}','backbone: pressure','frequency distribution')
% legend([h1 h2 pp],'location','northwest','Eden Willebrand 99','\gamma_p','frequency distribution')
% %legend([h1 h2 ],'backbone: \gamma_{rf}','backbone: pressure')
% print('-dpdf','-r200',['../figures/D_f_3d_global_comp.pdf'])
% 
% %print('-dpdf','-r200',['../figures/hist.pdf'])
% 
% 
