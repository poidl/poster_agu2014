function [k_out,r_out] = gamma_intersections(s,ct,p,shift)

% Written by D.R. Jackett
% Modified by P.M. Barker (2014)
% Modified by S. Riha (2014)
% Principal Investigator: T.J. McDougall

[nz,ny,nx]=size(s);
nxy=nx*ny;

s=s(:,:);
ct=ct(:,:);
p=p(:,:);

s_=circshift(s,[0,shift]);
ct_=circshift(ct,[0,shift]);
p_=circshift(p,[0,shift]);

k_out=nan*ones(nz,nxy);
r_out=nan*ones(nz,nxy);

for kk=1:nz
    if mod(kk,10)==0
        disp(['kk= ',num2str(kk)]);
    end
    
    if any(~isnan(s(kk,:))) && any(~isnan(s_(kk,:)))


        [dum1,dum2,p_n]=depth_ntp_simple(s(kk,:),ct(kk,:),p(kk,:), s_, ct_, p_);

        inan=isnan(p_n);
        p_n_stacked=repmat(p_n,[nz 1]);
        k_e=sum(p_n_stacked>=p_,1);
        ibot= k_e==nz;
        k_e(inan|ibot)=1; % dummy
        k_e3d= k_e+nz*[0:nx*ny-1];
        p1=p_(k_e3d);
        p2=p_(k_e3d+1);
        
        r=(p_n-p1)./(p2-p1);
        
        r(ibot)=0;    % Lower cast bottle is undefined!
        k_e(ibot)=nz; % Lower cast bottle is undefined!

        r(inan)=nan;
        k_e(inan)=nan;

        k_out(kk,:)=k_e;
        r_out(kk,:)=r;
        
    else
        k_out(kk,:)=nan;
        r_out(kk,:)=nan;
    end    
    
end

k_out=reshape(k_out,[nz,ny,nx]);
r_out=reshape(r_out,[nz,ny,nx]);




