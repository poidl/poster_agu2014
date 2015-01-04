function [gm]=map_contour_values(f,cv,g,lon,lat,p)

[nz,ny,nx]=size(f);

gm=nan*ones(size(cv));
    
for ii=1:length(cv)

    pns=var_on_surf_stef(p,f,cv(ii)*ones(ny,nx));
    
    % map to mean of g
    gns=var_on_surf_stef(g,p,pns);
    gm(ii)=area_mean(gns, squeeze(lat(1,:,:)),squeeze(lon(1,:,:)));
    
end

end
