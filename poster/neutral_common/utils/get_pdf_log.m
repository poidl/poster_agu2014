function [bins,bincounts,freq]=get_pdf_log(f,lon,lat,p,nbins)
warning('not a pdf!')
[dx,dy,dz]=get_dx(lon,lat,p);

dzt=regrid_new(dz,1,-2); % dx on t
dzt(1,:,:)=0.5*dz(1,:,:);
dyt=regrid_new(dy,2,-2);
dxt=regrid_new(dx,3,-2);

vol=dxt.*dyt.*dzt; % grid cell volume

vol=vol./sum(vol(~isnan(f(:)))); % total wet volume = 1


va_min=min(f(:));
va_max=max(f(:))+eps(1100); % add eps(1100) such that histc() returns zero for last bin.
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
for ii=1:nbins
    bincounts(ii)=sum(vol(ind==ii));
end
