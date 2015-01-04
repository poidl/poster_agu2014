function save_netcdf03(va,vname,fname)

if length(size(va))==3

    [nz,ny,nx]=size(va);

    if exist(['./',fname],'file')
        delete(['./',fname])
    end
    for ii=1:1;
        nccreate(['./',fname],vname,...
                  'Dimensions',{'x' nx 'y' ny 'z' nz});
    end
    for ii=1:1;
        ncwrite(['./',fname],vname, permute(va,[3 2 1]));
    end

elseif length(size(va))==2

    [ny,nx]=size(va);

    if exist(['./',fname],'file')
        delete(['./',fname])
    end
    for ii=1:1;
        nccreate(['./',fname],vname,...
                  'Dimensions',{'x' nx 'y' ny});
    end
    for ii=1:1;
        ncwrite(['./',fname],vname, permute(va,[2 1]));
    end    
end