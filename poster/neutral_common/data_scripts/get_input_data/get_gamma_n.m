function gamma=get_gamma_n(s,ct,p,lon,lat)

[nz,ny,nx]=size(s);

% check if s (and ct?) data outside -80<=lat & lat<=64 has been deleted
ii=-80<=lat & lat<=64;
if any(~isnan(s(~ii)))
    error('stop')
end

la=lat(1,:);
ii=-80<=la & la<=64;

s_=s(:,ii);
ct_=ct(:,ii);
p_=p(:,ii);
la_=lat(1,ii);
lo_=lon(1,ii);

tis=gsw_t_from_CT(s_,ct_,p_); % in-situ
%lo=squeeze(lon(1,:,:));
%la=squeeze(lat(1,:,:));

%gamma=gamma_n(s(:,:),tis(:,:),p(:,:),lo(:),la(:));

gamma_=gamma_n(s_,tis,p_,lo_,la_);

gamma=nan*ones(nz,ny*nx);
gamma(:,ii)=gamma_;

gamma=reshape(gamma,[nz,ny,nx]);

