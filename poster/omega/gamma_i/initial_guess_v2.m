function gamma_initial=initial_guess_v2(s,ct,p,lon,lat,ibb)

[nz,ny,nx]=size(s);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initial condition 

%gamma_initial = gamma_rf(s,ct); % (s,ct,p,lon,lat);

%gamma_initial=p./max(p(:));


% linear in z, 1 at bottom of backbone
igood=~isnan(s(:,ibb));
k=sum(igood);

gamma_initial=p./p(k,ibb); 

