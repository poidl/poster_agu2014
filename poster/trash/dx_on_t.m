function [dxt,dyt,dzt]=dx_on_t(dx,dy,dz)

% re-grid dx onto tracer grid
% assumptions:
%   1) shallowest point at p=0 
%   2) bottom tracer cell has the same height as dz above it.
%   3) dy doesn't vary in y
%

dzt=regrid_new(dz,1,-2);
dzt(1,:,:)=0.5*dz(1,:,:);

dyt=regrid_new(dy,2,-2);
dxt=regrid_new(dx,3,-2);

