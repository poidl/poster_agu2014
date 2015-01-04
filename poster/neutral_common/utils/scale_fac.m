function [dy,dx] = scale_fac(lat,lon)

%           Find distances between gridpoints of given latitude/longitude 
%
% Usage:    [e2t,e1t] = scale_fac(lats,longs)
%
%           Find distances between gridpoints of given latitude/longitude 
%           in a 2-dim dataset 
%
% Input:    lats        latitude
%           longs       longitude
%
% Output:   e2t         distance between gridpoints in N-S direction             
%           e1t         distance between gridpoints in E-W direction 
%
% Units:    e2t         m
%           e1t         m
%
% Calls:    gsw_distance.m
%
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

%% check input arguments

if ~(nargin == 2)
    error('scale_fac.m: requires 2 input arguments')
end

%% initialize and preallocate memory

[ny,nx] = size(lat);

dy=gsw_distance(lon(:),lat(:));
dy=[dy; nan];
dy=reshape(dy,[ny,nx]);
dy(end,:)=nan;

lont=lon';
latt=lat';
dx=gsw_distance(lont(:),latt(:));
dx=[dx; nan];
dx=reshape(dx,[nx,ny]);
dx=dx';

if ~zonally_periodic
    dx(:,end)=nan;
else
    lo=[lon(:,1),lon(:,end)]';
    la=[lat(:,1),lat(:,end)]';
    
    dx_end=gsw_distance(lo(:),la(:));
    dx_end=[dx_end;nan];
    dx_end=reshape(dx_end,[2 ny]);
    dx(:,end)=dx_end(1,:)';
end

%% calculate distances

% if ~zonally_periodic;
%         for j = 1:yi
%             for i = 1:xi-1
%                 e1t(j,i) = gsw_distance([longs(j,i) longs(j,i+1)],[lats(j,i) lats(j,i)]);
%             end
%         end
%         for j = 1:yi-1
%             for i = 1:xi
%                 e2t(j,i) = gsw_distance([longs(j,i) longs(j,i)],[lats(j,i) lats(j+1,i)]);
%             end
%         end
% else
%         for j = 1:yi
%             for i = 1:xi-1
%                 e1t(j,i) = gsw_distance([longs(j,i) longs(j,i+1)],[lats(j,i) lats(j,i)]);
%             end
%         end
%         for j = 1:yi
%             e1t(j,xi) = gsw_distance([longs(j,xi) longs(j,1)],[lats(j,i) lats(j,i)]);
%         end
%         for j = 1:yi-1
%             for i = 1:xi
%                 e2t(j,i) = gsw_distance([longs(j,i) longs(j,i)],[lats(j,i) lats(j+1,i)]);
%             end
%         end
% end
