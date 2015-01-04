function m=area_mean(f,lon,lat)
% assuming f is gridded on t

[dy,dx]=scale_fac(lat,lon);

dxt=regrid_new(dx,2,-2); % dx onto t
dyt=regrid_new(dy,1,-2); % dy onto t

ii=~isnan(f(:));

dA=dxt.*dyt;

fdA=f.*dA;

m=sum(fdA(ii))/sum(dA(ii));



