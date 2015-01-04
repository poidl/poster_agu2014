function [sms]=local_error_mean_square(f,s,ct,p,lon,lat,cv,error_measure)


[nz,ny,nx]=size(s);

sms=nan*ones(size(cv));
%gm=sms;
    
for ii=1:length(cv)

    pns=var_on_surf_stef(p,f,cv(ii)*ones(ny,nx));
    sns=var_on_surf_stef(s,p,pns);
    ctns=var_on_surf_stef(ct,p,pns);
    
    sms(ii)=error_surface(sns,ctns,pns,s,ct,p,lon,lat,error_measure);
%     if strcmp(error_measure,'drho_local')
%         [ex,ey]=delta_tilde_rho(sns,ctns,pns);
%     elseif strcmp(error_measure,'slope_difference')    
%         [ex,ey]=delta_slope(sns,ctns,pns,s,ct,p);
%     end
%     
%     dxt=regrid_new(dx,3,-2); % dx onto dy
%     dx_=regrid_new(dxt,2,2);
%     dyt=regrid_new(dy,2,-2); % dy onto dx
%     dy_=regrid_new(dyt,3,2);
%     %keyboard
%     f1=sqrt(dy_./dx);
%     f2=sqrt(dx_./dy);
%     f1=squeeze(f1(1,:,:));
%     f2=squeeze(f2(1,:,:));
%     fx=(ex.*f1).^2;
%     fy=(ey.*f2).^2;
%    
%     ix=~isnan(fx(:));
%     iy=~isnan(fy(:));
%     dx_=squeeze(dx(1,:,:));
%     dy_=squeeze(dy(1,:,:));    
%     myarea=dx_.*dy_;
% 
%     area_=sum(myarea(ix&iy));
%     
%     sms(ii)= nansum([fx(:);fy(:)])/area_;
%     
end

end


