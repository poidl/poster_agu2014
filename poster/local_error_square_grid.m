function [sms,e2]=local_error_square_grid(f,s,ct,p,lon,lat,error_measure)

[dx,dy,dz]=get_dx(lon,lat,p);

[nz,ny,nx]=size(s);

sms=nan*ones(1,nz);

if strcmp(error_measure,'drho_local')
    error('not implemented')
elseif strcmp(error_measure,'slope_difference')    
    [ex,ey]=delta_slope_grid(f,s,ct,p);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mean square

% assuming dz is laterally constant 
dxt=regrid_new(dx,3,-2); % dx onto dy
dx_=regrid_new(dxt,2,2);
dyt=regrid_new(dy,2,-2); % dy onto dx
dy_=regrid_new(dyt,3,2);

f1=sqrt(dy_./dx);
f2=sqrt(dx_./dy);

fx=(ex.*f1).^2;
fy=(ey.*f2).^2;

dx_=squeeze(dx(1,:,:));
dy_=squeeze(dy(1,:,:));

myarea=dx_.*dy_;

for kk=1:nz
    fx_=squeeze(fx(kk,:,:));
    fy_=squeeze(fy(kk,:,:));
    ix=~isnan(fx_(:));
    iy=~isnan(fy_(:));

    area_=sum(myarea(ix&iy));
    
    sms(kk)= nansum([fx_(:);fy_(:)])/area_;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% square

ex=ex./dx;
ey=ey./dy;

e2=ex.^2+ey.^2;


end
