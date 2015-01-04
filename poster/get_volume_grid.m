function vol=get_volume_grid(f,lon,lat,p)
% grid-cell volume on t points

[dx,dy,dz]=get_dx(lon,lat,p);

dzt=regrid_new(dz,1,-2); % dx on t
dzt(1,:,:)=0.5*dz(1,:,:);
dyt=regrid_new(dy,2,-2);
dxt=regrid_new(dx,3,-2);

vol=dxt.*dyt.*dzt; % grid cell volume

vol=vol./sum(vol(~isnan(f(:)))); % total wet volume = 1