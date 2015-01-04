function n3s=n3_zon_mean(s,ct,p)

[nz,ny,nx]=size(s);
[n1,n2,n3]=get_n(s,ct,p);
n3=regrid_new(n3,1,-2);

n3s=repmat(nanmean(n3,3),[1,1,nx]);

end
