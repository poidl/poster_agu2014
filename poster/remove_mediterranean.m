function [s,ct]=remove_mediterranean(s,ct,p,lon,lat)


ocean=gamma_ocean_and_n(s,ct,p,lon,lat);

s(:,ocean(:)==13)=nan;
ct(:,ocean(:)==13)=nan;
   


