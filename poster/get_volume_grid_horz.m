function vol=get_volume_grid_horz(f,lon,lat,p)
% grid-cell area on horizontal t points multiplied by dz (to get volume between to
% vertically adjacent grid points, e.g. instabilities_percent_script.

[dx,dy,dz]=get_dx(lon,lat,p);

%dzt=regrid_new(dz,1,-2); % dx on t
%dzt(1,:,:)=0.5*dz(1,:,:);
dyt=regrid_new(dy,2,-2);
dxt=regrid_new(dx,3,-2);

vol=dxt.*dyt.*dz; % grid cell volume
vol=vol(1:end-1,:,:);
f=f(1:end-1,:,:);
vol=vol./sum(vol(~isnan(f(:)))); % total wet volume = 1