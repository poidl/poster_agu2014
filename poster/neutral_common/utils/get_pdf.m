function [bins,bincounts,freq]=get_pdf(f,lon,lat,p,nbins)

vol=get_volume_grid(f,lon,lat,p);

va_min=min(f(:));
va_max=max(f(:))+eps(1100); % add eps(1100) such that histc() returns zero for last bin.
%va_max=max(f(:));
bins=linspace(va_min,va_max,nbins);

% bincounts = histc(x,binranges)
% bincounts counts the number of values in x that are within each specified bin range.
% bins determines the endpoints for each bin
% the last entry in bincounts is the number of values in x that equal the last entry in binranges.
[freq,ind]=histc(f(:),bins);
%keyboard
% replace bincount for bin ii by sum of volumes of bin members
bincounts=nan*ones(1,nbins);
for ii=1:nbins
    bincounts(ii)=sum(vol(ind==ii));
end
bincounts=bincounts*nbins/(va_max-va_min);