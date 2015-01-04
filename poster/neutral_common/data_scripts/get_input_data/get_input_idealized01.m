function [s,ct,p,lon,lat]=get_input_idealized01()

nx=3;
ny=45;
nz=33;

ts=7; % surface temperature south
tn=5; % surface temperature north
dt=5; % surface temp minus bottom temp
dp=2e3;

% ts=5.2; % surface temperature south
% tn=5; % surface temperature north
% dt=0.5; % surface temp minus bottom temp
% dp=2e3;

y=linspace(0,1,ny);

tsn= ts+(tn-ts)*y;
tsn=repmat(tsn,[nx 1]);
tsn=repmat(permute(tsn,[3,2,1]),[nz 1 1]);

dt=-dt*linspace(0,1,nz);
dt=repmat(dt,[ny 1]);
dt=repmat(permute(dt,[2,1,3]),[1 1 nx]);

dp=dp*linspace(0,1,nz);
dp=repmat(dp,[ny 1]);
p=repmat(permute(dp,[2,1,3]),[1 1 nx]);

ct=tsn+dt;
s=0*ct+35;

% h=contourf(squeeze(ct(:,:,1)))
% colorbar()
% set(gca,'YDir','reverse')
% figure()
% rpot=gsw_rho(s,ct,0*ct);
% contourf(squeeze(rpot(:,:,1)))
% colorbar()
% set(gca,'YDir','reverse')

%lat=[-84:4:84];
lat=linspace(-80,64,ny);
lat=repmat(lat,[nx 1]);
lat=repmat(permute(lat,[3,2,1]),[nz 1 1]);

%lon=[0:4:356];
lon=linspace(0,360,nx+1); lon=lon(1:end-1);
lon=repmat(lon,[ny 1]);
lon=repmat(permute(lon,[3,1,2]),[nz 1 1]);


% set nans
% s(15)=nan; % 15 is center bottom
% ct(15)=nan; % 15 is center bottom
% s(3)=nan;
% ct(3)=nan;
