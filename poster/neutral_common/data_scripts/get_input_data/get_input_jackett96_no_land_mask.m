function [s,ct,p,lon,lat]=get_input_jackett96_no_land_mask(path_to_gammanc)

[s,ct,p,gamma_96,lat,lon]=gammanc_to_sctp(path_to_gammanc);

%[s,ct,gamma_96]=make_mask_96(s,ct,p,gamma_96,lon,lat);

lat=double(lat);
lon=double(lon);
