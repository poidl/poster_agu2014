function [sdx,sdy]=delta_slope_grid(va,s,ct,p)
    
    global_user_input
    
    [nz,ny,nx]=size(s);
    
    sdx=nan*ones(size(s));
    sdy=nan*ones(size(s));
    
    % north 
    sn=circshift(s,[0 -1 0]);
    ctn=circshift(ct,[0 -1 0]);
    pn=circshift(p,[0 -1 0]);    
    van=circshift(va,[0 -1 0]); 
      
    % east
    se=circshift(s,[0 0 -1]);
    cte=circshift(ct,[0 0 -1]);
    pe=circshift(p,[0 0 -1]);    
    vae=circshift(va,[0 0 -1]);
    
    for kk=1:nz
        disp(num2str(kk))
        vsurf=squeeze(va(kk,:,:));
        ssurf=squeeze(s(kk,:,:));
        ctsurf=squeeze(ct(kk,:,:));
        psurf=squeeze(p(kk,:,:));
        
% simpler than delta_slope; slope difference is only calculated in the
% positive directions here.
%%%%%%%%%%%%%%%%%%%%%%%%%

        psurf_=psurf;
        psurf_(isnan(vsurf(:)))=nan;
                
        vpx=depth_iso_simple(vsurf(:)',psurf_(:)',vae(:,:),pe(:,:),0*vsurf(:)');
        vpx=reshape(vpx,[ny,nx]);
        vsx=(vpx-psurf);
        
        vpy=depth_iso_simple(vsurf(:)',psurf_(:)',van(:,:),pn(:,:),0*vsurf(:)');
        vpy=reshape(vpy,[ny,nx]);
        vsy=(vpy-psurf);
        
%%%%%%%%%%%%%%%%%%%%%%%%%        
 %       keyboard
        psurf(isnan(ssurf(:)))=nan;
        [tr,tr,npx]=depth_ntp_simple(ssurf(:)',ctsurf(:)',psurf(:)',se(:,:),cte(:,:),pe(:,:),0*ssurf(:)');
        npx=reshape(npx,[ny,nx]);
        nsx=(npx-psurf);
        [tr,tr,npy]=depth_ntp_simple(ssurf(:)',ctsurf(:)',psurf(:)',sn(:,:),ctn(:,:),pn(:,:),0*ssurf(:)');
        npy=reshape(npy,[ny,nx]);
        nsy=(npy-psurf);

        sdx(kk,:,:)=vsx-nsx;
        sdy(kk,:,:)=vsy-nsy;     
       
    end

    if ~zonally_periodic
        sdx(:,:,end)=nan;
    end
    sdy(:,end,:)=nan;
    
end
