
CD-ROM-2. WOCE Global Hydrographic Climatology:  Gridded  data
===============================================================


The   CD-ROM-2   contains  objectively  analysed  all-data-mean 
climatological profiles  for one-half-degree squares of the 
Global Ocean.  

There are 45 standard depth levels between the sea surface
and 6000 meter depth. The data are split into 60-degree
longitude sectors:

__________________________________________
Filename                      Longitude, E
__________________________________________
Wghc_0000-0595.gz                0- 59.5
Wghc_0060-1195.gz               60-119.5
Wghc_1200-1795.gz              120-179.5
Wghc_1800-2395.gz              180-239.5
Wghc_2400-2995.gz              240-299.5
Wghc_3000-3595.gz              300-359.5
__________________________________________

The  header  of  each gridded profile contains  the  number 
of gridded levels, radius of influence bubble, decorrelation 
length  scale  and  mixed  layer  depth.  

Each standard level contains analysed values of temperature,
salinity,  oxygen, silicate, nitrate, and  phosphate, along
with  relative interpolation errors, numbers of observations
contributed to the optimum  estimate, and property standard
deviations within  the influence bubble.

The  first grid-node  in  the first  file (wghc_0000-0595.gz)
represents the 0.5x0.5-degree box centred at 80oS and 0o. The 
first  341 grid-nodes are incremented northward  constant in
longitude. The 342-th grid-node  has the coordinates  80oS and 
0.5oE. Each of the six files follows the same pattern with the 
longitude of the first grid node in each file being incremented 
by 60 degree in longitude.

The  sample FORTRAN program  read_wghc_climatology.f  reads in
the gridded  profiles.   The program requests a single latitude 
and longitude of the grid node from the user and returns gridded
properties at standard levels written to the screen.  