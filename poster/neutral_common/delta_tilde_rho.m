function [drhodx,drhody] = delta_tilde_rho(sns,ctns,pns)


%   _________________________________________________________________
%   This is part of the analyze_surface toolbox, (C) 2009 A. Klocker
%   Copyright (C) 2010-2013 P. Barker
%   Copyright (C) 2013, 2014 S. Riha
%   Principal investigators: Trevor McDougall, David Jackett
%   type 'help analyze_surface' for more information 
%   type 'analyze_surface_license' for license details
%   type 'analyze_surface_version' for version details
%

global_user_input;

%% initialize

[yi,xi] = size(sns);

%% calculate density gradients referred to mid-point pressures

pmid=0.5*(pns+circshift( pns, [0,-1]));

r1=gsw_rho(sns,ctns,pmid);
r2=gsw_rho( circshift(sns, [0 -1])  , circshift( ctns, [0 -1]) ,pmid);

drhodx=r2-r1;

if ~zonally_periodic;
    drhodx(:,xi) = nan;
end


pmid=0.5*(pns+circshift( pns, [-1,0]));

r1=gsw_rho(sns,ctns,pmid);
r2=gsw_rho( circshift(sns, [-1 0])  , circshift( ctns, [-1 0]) ,pmid);

drhody=r2-r1;

drhody(yi,:) = nan;





