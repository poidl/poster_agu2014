function stats_percent_larger_poster_small()

methods={'gamma_i_v1','ew99mod_v2','sig2'};
datasets={'jackett96','woa13_4deg','wghc_4deg','nemo_4deg'};
datasets={'woa13_1deg'};
make_dir('./figures/poster')
xlab_prefix='% > D_f=';
xlab_suffix=' m^2/s';

thresh=1e-8;

ncols=3; % number of columns
nrows=1; % number of rows
nsp=ncols*nrows; % number of subplots

spwidth=0.3; % subplot width
spheight=0.8; % subplot height
wscol= 0.02; % white space between columns
wsrow=0.05; % white space between rows
leftmarg=(1-(ncols*spwidth+(ncols-1)*wscol))*0.5 % left and right margin
topmarg=(1-(nrows*spheight+(nrows-1)*wsrow))*0.5 % top and bottom margin


txt={'a)','b)','c)','d)','e)','f)','g)','h)','i)','j)','k)','l)'};
cols={'b','g','r','g','c','m','y','k--','b--','r--','g--','c--','m--','y--'};
cols=[1.2 1.5 1.8];
sz=1*[21 29.7]; % A4 = [21 29.7] cm 
sz=1*[21 10]; % A4 = [21 29.7] cm
figure('PaperSize',sz,'PaperUnits','centimeters','PaperPosition',[0 0 sz(1) sz(2)]) 

set(gcf,'DefaultAxesFontSize', 8)
set(gcf,'DefaultTextFontSize',8)

isp=1; % index of subplot

for ds=datasets
    make_dir(['./figures/',ds{:}]);
    load(['./data_out/',ds{:},'/input_data.mat']);
    h=nan*length(methods); % handles
    xl=0; % xax upper limit
    for ii=1:length(methods)

        meth=methods(ii);
        load(['./data_out/',ds{:},'/',meth{:},'/e2_grid.mat'])

        irow=ceil(isp/ncols); % row index
        icol=isp-(irow-1)*ncols; % column index
        left=leftmarg+(icol-1)*(spwidth+wscol); % current subplot position
        bottom=1-topmarg-irow*spheight-(irow-1)*wsrow; % current subplot position

        subplot('position',[left,bottom,spwidth,spheight])

        y=get_percent_larger(e2,thresh);
        z=squeeze(p(:,1,1));
        %keyboard
        h(ii)=barh(-z,y,'style','hist');
        
        % color the negative values in red
fvd = get(h(ii),'Faces');
vvd = get(h(ii),'Vertices'); % one indexed color per vertex: http://www.mathworks.com.au/help/matlab/ref/patch_props.html#Faces
fvcd = get(h(ii),'FaceVertexCData');
fvcd(fvd(:,:))=cols(ii); % the color axis should range from 1 to 2 (check with caxis)
set(h(ii),'FaceVertexCData',fvcd);

       
        
        xll=xlim;
        %xl=max(xl,xll(2));
        xl=80;
        dz=diff(z);
        ylim([-z(end)-0.8*dz(end),100])
        %ylabel('depth [m]')
        set(gca,'yticklabel','')
        xlabel([xlab_prefix,num2str(thresh),xlab_suffix])
        title(['Data set: ',ds{:},'   Method: ',meth{:}],'Interpreter','none');
        grid on

        text(-0.03,1.05,txt(isp),'fontsize',12,'units','normalized')
        isp=isp+1;
        
    end
    %keyboard
    for ii=1:length(h)
        ax = get(h(ii),'Parent');
        set(ax,'xlim',[0 xl]);
    end
end
fout=['./figures/poster/percent_larger_small.pdf'];
print('-dpdf','-r200',fout)
%keyboard

