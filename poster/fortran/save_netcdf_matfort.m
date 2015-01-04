function save_netcdf_matfort(sa,ct,p,sns,ctns,pns);

[nz,ny,nx]=size(sa);

fname='data/os_input_matfort.nc';

vname={'sa','ct','p'};

delete data/os_input_matfort.nc

for ii=1:3;
    nccreate(fname,vname{ii},...
              'Dimensions',{'x' nx 'y' ny 'z' nz});
end

value={sa,ct,p};
 
for ii=1:3;
    ncwrite(fname,vname{ii}, permute(value{ii},[3 2 1]));
end




vname={'sns','ctns','pns'};

for ii=1:3;
    nccreate(fname,vname{ii},...
              'Dimensions',{'x' nx 'y' ny});
end

value={sns,ctns,pns};
 
for ii=1:3;
    ncwrite(fname,vname{ii}, permute(value{ii},[2 1]));
end

end

