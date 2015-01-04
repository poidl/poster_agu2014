function h=plot_mypatch(field,s,lon,lat,p,ilon)

[nz,ny,nx]=size(s);
lo=squeeze(lon(1,1,:));
la=squeeze(lat(1,:,1));
pp=squeeze(p(:,1,1));

dp=diff(pp);
cbz=pp(1:end-1)+0.5*dp; % cell boundaries z
cbz=[cbz(1)-0.5*dp(1); cbz; pp(end)]; % starts (ends) at pressure of shallowest (deepest) gridpoint


% meridional cell boundaries
dl=diff(la);
cbl=la(1:end-1)+0.5*dl; % cell boundaries lat
cbl=[cbl(1)-0.5*dl(1), cbl, cbl(end)+0.5*dl(end)];

x1=cbl(1:end-1);
x2=cbl(2:end);
y1=cbz(1:end-1);
y2=cbz(2:end);

x=[x1;x2;x2;x1]; % starting at shallow south vertex going clockwise
x=repmat(permute(x,[1 3 2]),[1 length(pp) 1]);
y=[y1';y1';y2';y2'];
y=repmat(permute(y,[1 2 3]), [1 1 length(x1)]);

% bottom cell is cut in half to indicate depth of deepest data point exactly
ss=squeeze(s(:,:,ilon));
ibot=sum(~isnan(ss(:,:))); % index of deepest defined point
idum=ibot==0;% dummy
ilast=ibot==nz;% deepest gridpoint is a data point. cell was already cut at definition of cbz
ibot(idum)=1; 
ibot2=ibot+nz*(0:ny-1);
yy=y(:,ibot2);
yy_orig=yy; % save for restoring dummy
yy(3,:)=yy(1,:)+0.5*(yy(4,:)-yy(1,:));
yy(4,:)=yy(3,:);
yy(:,idum)=yy_orig(:,idum); % restore at dummies
yy(:,ilast)=yy_orig(:,ilast);
y(:,ibot2)=yy; % assign


fac=reshape((1:length(y(:))),[4,(ny)*(nz) ])'; % faces
f=squeeze(field(:,:,ilon));

h=patch('Vertices',[x(:),y(:)],'Faces',fac,...
  'FaceVertexCData',f(:),'FaceColor','flat','edgecolor','none');
set(gca,'ydir','reverse')
colorbar()

hold on

% flag nans
ibad=find(isnan(f(:)) & ~isnan(ss(:)));
for ii=ibad'
    plot([x(1,ii) x(3,ii)],[y(1,ii) y(3,ii)],'k','linewidth',1);
    plot([x(2,ii) x(4,ii)],[y(2,ii) y(4,ii)],'k','linewidth',1);
end

