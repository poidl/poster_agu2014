

of=ceil(ns/nsurf);
is=(1:of:ns); % indices of surface
%keyboard
ncols=2; % number of columns
nrows=3; % number of rows
nsp=ncols*nrows; % max. number of subplots per figure

np=length(is); % total number of subplots
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
        vp=squeeze(va(is(iit),:,:));
        %keyboard
        h=imagesc(lo,la,vp);
        %set(h,'edgecolor','none')
        set(h,'alphadata',~isnan(vp)) % white nans
        set(gca,'YDir','normal')
        colorbar('Location','SouthOutside','position',[left,bottom-0.4*wsrow,spwidth,0.1*wsrow]);
        %keyboard
        hold on
        plot(lo(ilon),la(ilat),'xr','markersize',10,'linewidth',2)
        plot(lo(ilon),la(ilat),'ob','markersize',10,'linewidth',2)
        if strfind(ds{:},'nemo')
            text(lo(ilon),la(ilat),'!! Grid non-isotropic in lat/lon !!')
            plot([lo(1) lo(end)],[la(1) la(end)],'k')
            plot([lo(end) lo(1)],[la(1) la(end)],'k')
        end
            
        
        title([title_prefix,', bb pr. ',num2str(pns3d(is(iit),ibb)),' dbar (',ds{:},', ',meth{:},')'],'interpreter','none')
        text(-0.1,1.1,txt(isp),'fontsize',12,'units','normalized')
        iit=iit+1; isp=isp+1;
    end
    fout=['./figures/',ds{:},'/',meth{:},'/',fout_prefix,'_',num2str(ifig,'%02i'),'.pdf'];
    print('-dpng','-r400',fout)
    %keyboard
end
