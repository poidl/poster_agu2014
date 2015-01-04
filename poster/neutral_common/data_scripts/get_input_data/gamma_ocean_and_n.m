function ocean = gamma_ocean_and_n(SA,CT,p,lon,lat)

% Written by D. R. Jackett and possibly others
% Modified by P.M. Barker (2014)
% Modified by S. Riha (2014)

lon=lon(1,:);
lat=lat(1,:);
ocean = gamma_ocean_3d(lon,lat,squeeze(SA(1,:,:)));


end

%##########################################################################

function ocean = gamma_ocean_3d(lon,lat,z)

% gamma_ocean_3d
%==========================================================================
%
% USAGE:  
%  ocean = gamma_ocean_3d(longs,lats,z)
%
% DESCRIPTION:
%  gamma_ocean_3d      ocean of longs/lats observations
%
% INPUT: 
%  longs - vector (nx) of longitudes [0,360]
%  lats  - vector (ny) of latitudes [-90,90]
%  z     - array (ny,nx) describing the ocean extent
%
% OUTPUT:   
%  ocean - array (ny,nx) of ocean values
%           0    land,
%           1    North Pacific,
%           2    South Pacific
%           4    South Indian
%           5    North Atlantic, Hudson Bay, Mediterranean Sea, North Indian
%                Red Sea, persian gulf, Baltic sea, black/caspian seas
%           6    South Atlantic
%           7    Atlantic / Artic
%           8    Southern Equatorial Pacific, 
%           9    
%           10   
% Author:    	
%  David Jackett 7/7/98
%
%==========================================================================

[ny,nx]=size(z);

ocean = nan(ny,nx);

for ii = 1:ny*nx
    ocean(ii) = gamma_ocean_2d(lon(ii),lat(ii));
end

ocean(isnan(z))=nan;

end

%##########################################################################

function ocean = gamma_ocean_2d(lon,lat)

% gamma_ocean_2d
%==========================================================================
%
% USAGE:  
%  ocean = gamma_ocean0(lon,lat)
%
%   gamma_ocean0         ocean of single lon/lat observation
%
% Input: 
%  lon  - 	longitude [0,360]
%  lat   - 	latitude [-90,90]
%
% Output:    
%  ocean - 	0  land,
%           1-6  main oceans,
%           7    Arctic
%           8    Med
%
% Author:
%  David Jackett  7/7/98
%
%==========================================================================


po_long = [100, 140, 240, 260, 272.59, 276.5, 278.65, 280.73, 295.217, 290, ...
    300, 294, 290, 146, 146, 133.9, 126.94, 123.62, 120.92, 117.42, 114.11, ...
    107.79, 102.57, 102.57, 98.79, 100];

po_lat = [20, 66, 66, 19.55, 13.97, 9.6, 8.1, 9.33, 0, -52, -64.5, -67.5, ...
    -90, -90, -41, -12.48, -8.58, -8.39, -8.7, -8.82, -8.02, -7.04, -3.784, ...
    2.9, 10, 20];

na_long = [260, 272, 285, 310, 341.5, 353.25, 356, 360, 354.5, 360, 360, ...
    295.217, 280.73, 278.65, 276.5, 272.59, 260, 260];

na_lat = [60, 72, 82, 81.75, 65, 62.1, 56.5, 44, 36, 20, 0, 0, 9.33, 8.1, ...
    9.6, 13.97, 19.55, 60];

i_pacific = inpolygon(lon,lat,po_long,po_lat);

% pacific ocean
if i_pacific == 1
    if lat <= -15
        ocean = 5;%2;
    elseif lat > -15 & lat <= 0
        ocean = 8;
    else
        ocean = 1;
    end
    
% indian ocean
elseif 20<=lon && lon<=150 && -90<=lat && lat<=30
    if lat <= 0
        ocean = 4;
    else
        ocean = 5;
    end
    
% atlantic ocean
elseif (0<=lon && lon<=20 && -90<=lat && lat<=90) || ...
        (20<=lon && lon<=40 && 28<=lat && lat<=44) || ...
        (260<=lon && lon<=360 && -90<=lat && lat<=90)
    i_natlantic = inpolygon(lon,lat,na_long,na_lat);
%     if lat <= 0
%         ocean = 5;
%     else
    if (i_natlantic==1) | (0<=lon && lon<=15 && 0<lat && lat<=10) | lat <= 0
        ocean = 5;
    else
        ocean = 7;
    end
    
% arctic ocean
elseif 0<=lon && lon<=360 && 64<lat && lat<=90
    ocean = 7;
else
    ocean = 7;
end

% % red sea
% if 31.25<=lon && lon<=43.25 && 13<=lat && lat<=30.1
%     ocean = 5;
%     
% % persian gulf
% elseif 40<=lon && lon<=56 && 22<=lat && lat<=32
%     ocean = 5;
%     
% % baltic sea
% elseif 12<=lon && lon<=33.5 && 50<=lat && lat<=60
%     ocean = 9;
% elseif 16<=lon && lon<=33.5 && 60<=lat && lat<=66
%     ocean = 9;
%     
% % black/caspian seas
% elseif 40<=lon && lon<=112 && 30<=lat && lat<=60
%     ocean = 10;
% elseif 27.5<=lon && lon<=40 && 40<=lat && lat<=50
%     ocean = 10;
%     
% % african lakes
% elseif 29<=lon && lon<=36 && -16<=lat && lat<=4
%     ocean = 10;
%     
% % hudson bay
% elseif 266<=lon && lon<=284 && 40<=lat && lat<=70
%     ocean = 5;
%    

% mediterranean sea
if 0<=lon && lon<=45 && 28<=lat && lat<=47
    ocean = 13;
elseif 355<=lon && lon<=360 && 34<=lat && lat<=42
    ocean = 13;
end

end

%##########################################################################

