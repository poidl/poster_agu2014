function y=get_percent_larger(e2,thresh)

[nz,ny,nx]=size(e2);

y=nan*ones(1,nz);


for kk=1:nz
    e2_=squeeze(e2(kk,:,:));
    ii=~isnan(e2_(:));
    ilarger=e2_(:)>thresh;
    y(kk)=100*sum(ilarger)/sum(ii);
end