function stats_pdf_error_allmethods_poster()

methods={'gamma_i_v1','ew99mod_v2','sig2'};
%datasets={'wghc_4deg','woa13_4deg','nemo_4deg'};
datasets={'wghc_1deg','woa13_1deg','nemo_1deg'};
make_dir('./figures/poster')
xlab='D_f [m^2/s]';


ncols=3; % number of columns
nrows=1; % number of rows
nsp=ncols*nrows; % number of subplots

spwidth=0.29; % subplot width
spheight=0.7; % subplot height
wscol= 0.02; % white space between columns
wsrow=0.05; % white space between rows
leftmarg=(1-(ncols*spwidth+(ncols-1)*wscol))*0.5 % left and right margin
topmarg=(1-(nrows*spheight+(nrows-1)*wsrow))*0.5-0.04 % top and bottom margin

cols={'b','g','r','g','c','m','y','k--','b--','r--','g--','c--','m--','y--'};
txt={'1a)','1b)','1c)','1d)','1e)','1f)','1g)','1h)','1i)','1j)','1k)','1l)'};
legend_labels={'\gamma_i','EWmod','\sigma_2'}
sz=1*[21 29.7]; % A4 = [21 29.7] cm 
sz=0.8*[21 7]; % A4 = [21 29.7] cm
figure('PaperSize',sz,'PaperUnits','centimeters','PaperPosition',[0 0 sz(1) sz(2)],'Visible','off') 

set(gcf,'DefaultAxesFontSize', 8)
set(gcf,'DefaultTextFontSize',8)

isp=1; % index of subplot


for ds=datasets
    make_dir(['./figures/',ds{:}]);
    load(['./data_out/',ds{:},'/input_data.mat']);
    
%keyboard
    irow=ceil(isp/ncols); % row index
    icol=isp-(irow-1)*ncols; % column index
    left=leftmarg+(icol-1)*(spwidth+wscol); % current subplot position
    bottom=1-topmarg-irow*spheight-(irow-1)*wsrow; % current subplot position

    subplot('position',[left,bottom,spwidth,spheight])
    
    va_min=1000;
    va_max=0;
    h=nan*ones(1,length(methods)); % handles
    for ii=1:length(methods)
        
        meth=methods(ii);
       
        load(['./data_out/',ds{:},'/',meth{:},'/e2_grid.mat'])
        df=1000*e2;
        va_min=min(va_min,min(df(:)));
        va_max=max(va_max,max(df(:)));
        
    end    
    for ii=1:length(methods)
        
        meth=methods(ii);
       
        load(['./data_out/',ds{:},'/',meth{:},'/e2_grid.mat'])
        df=1000*e2;

        f=df;
        nbins=100;
        
        [dx,dy,dz]=get_dx(lon,lat,p);

        dzt=regrid_new(dz,1,-2); % dx on t
        dzt(1,:,:)=0.5*dz(1,:,:);
        dyt=regrid_new(dy,2,-2);
        dxt=regrid_new(dx,3,-2);

        vol=dxt.*dyt.*dzt; % grid cell volume

        vol=vol./sum(vol(~isnan(f(:)))); % total wet volume = 1

        va_max=va_max+eps(1100); % add eps(1100) such that histc() returns zero for last bin.
        %va_max=max(f(:));
        if va_min==0
            va_min=1e-20;
        end
        vec=linspace(log(va_min),log(va_max),nbins);
        bins=exp(vec);
        % bincounts = histc(x,binranges)
        % bincounts counts the number of values in x that are within each specified bin range.
        % bins determines the endpoints for each bin
        % the last entry in bincounts is the number of values in x that equal the last entry in binranges.
        [freq,ind]=histc(f(:),bins);
        %keyboard
        % replace bincount for bin ii by sum of volumes of bin members
        bincounts=nan*ones(1,nbins);
        for jj=1:nbins
            bincounts(jj)=sum(vol(ind==jj));
        end
        
        %h=loglog(x,y,cols{ii});
        h(ii)=semilogx(bins,nbins*bincounts,cols{ii});
        hold on
        %keyboard
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    end
    
    legend(h,'location','northwest',legend_labels)
    legend('boxoff')
    xlabel(xlab)
    set(gca,'yticklabel','')
    title(['Data set: ',ds{:}],'Interpreter','none');
    grid on

    text(-0.03,1.08,txt(isp),'fontsize',12,'units','normalized') 
    isp=isp+1;

    set(gca,'xlim',[10e-18 10e-3]);
    set(gca,'xtick',10.^([-13:2:-3]));
    if strcmp(ds{:},datasets{1})
        ylabel('frequency')
    end

    
end


fout=['./figures/poster/stats_pdf_error_allmethods_poster.pdf'];
print('-dpdf','-r200',fout)
%keyboard

