
lo=squeeze(lon(1,1,:));
y=squeeze(lat(1:nz-1,:,1));

of=ceil(nx/ntransects);
il=(1:of:nx); % longitude indices of transects

ncols=2; % number of columns
nrows=3; % number of rows
nsp=ncols*nrows; % max. number of subplots per figure

np=length(il); % total number of subplots
nfig=floor(np/nsp)+(mod(np,nsp)>0); % number of figures (pages)

spwidth=0.4; % subplot width
spheight=0.2; % subplot height
wscol= 0.08; % white space between columns
wsrow=0.1; % white space between rows
leftmarg=(1-(ncols*spwidth+(ncols-1)*wscol))*0.5; % left and right margin
topmarg=(1-(nrows*spheight+(nrows-1)*wsrow))*0.5; % top and bottom margin


txt={'a)','b)','c)','d)','e)','f)'};

%keyboard
iit=1; % index of iteration
    
for ifig=1:nfig
    sz=1*[21 29.7]; % A4 = [21 29.7] cm 
    figure('PaperSize',sz,'PaperUnits','centimeters','PaperPosition',[0 0 sz(1) sz(2)],'Visible','off') 

    set(gcf,'DefaultAxesFontSize', 8)
    set(gcf,'DefaultTextFontSize',8)

    isp=1; % index of subplot
    ip=1; % index of plot

%     cmp=colormap(hot(128));
%     cmp2=cmp(find(cmp(:,1)==1,1,'first')-15:end,:);

    while (isp<=nsp) && ( ip <=np)  && (iit<=np)
        ip=((ifig-1)*nsp+isp);
        irow=ceil(isp/ncols); % row index
        icol=isp-(irow-1)*ncols; % column index
        left=leftmarg+(icol-1)*(spwidth+wscol); % current subplot position
        bottom=1-topmarg-irow*spheight-(irow-1)*wsrow; % current subplot position

        subplot('position',[left,bottom,spwidth,spheight])
        vp=squeeze(va(:,:,il(iit)));
        %keyboard
        
        dots=vp>=0;
        vp(dots)=nan;
        
        contourf(y,z,log10(-vp))
        set(gca,'YDir','reverse')
        %colorbar
        colorbar('Location','SouthOutside','position',[left,bottom-0.4*wsrow,spwidth,0.1*wsrow]);
        hold on
        plot(y(dots),z(dots),'ro','markersize',10)

        title([title_prefix,' at lon= ',num2str(lo(il(iit))),' deg  (',ds{:},', ',meth{:},')'],'interpreter','none')
        text(-0.1,1.1,txt(isp),'fontsize',12,'units','normalized')
        iit=iit+1; isp=isp+1;
    end
    if strcmp(meth{:},'n3')
        fout=['./figures/',ds{:},'/',fout_prefix,'_n3_',num2str(ifig,'%02i'),'.pdf'];
    else
        fout=['./figures/',ds{:},'/',meth{:},'/',fout_prefix,'_',num2str(ifig,'%02i'),'.pdf'];
    end
    print('-dpdf','-r200',fout)
    %keyboard
end
