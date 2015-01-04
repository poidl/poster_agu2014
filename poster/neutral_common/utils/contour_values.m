function values=contour_values(f,lon,lat,p)
    % get vector of values of f whose spacing decreases with
    % stratification (decreses with number of observations in a density range)
    
    [dx,dy,dz]=get_dx(lon,lat,p);
    nbins=30;
    [bins,bincounts,~]=get_pdf(f,lon,lat,p,nbins);

    bincounts=bincounts(1:end-1); % remove last entry
    nsurf=100; % approx. number of total surfaces
    N=int16(bincounts*nsurf/sum(bincounts)); % number of surfaces for bin
    N=double(N);

    dg=diff(bins)./N; % increment of gamma
    dg(~isfinite(dg))=nan;
    
    nsurf=sum(N);
    values=nan*(ones(1,nsurf));
    
    jj=1;
    for ii=1:length(dg);
        if ~isnan(dg(ii))
            values(jj: jj+N(ii)-1)=bins(ii)+dg(ii)*(0.5 : 1 : N(ii)-0.5);
            jj=jj+N(ii);
        end
    end 
end
