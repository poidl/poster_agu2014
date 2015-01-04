#!/usr/bin/python

from netCDF4 import Dataset
import numpy as np

ds = Dataset('http://servdap.legi.grenoble-inp.fr/meom/ORCA05/ORCA05-I/ORCA05-G70.112_mesh_hgr.nc')
lat=ds.variables['gphit'][:]
lon=ds.variables['glamt'][:]

# this variable is corrupted when using netCDF4. use wget to download file, and run 'add_pressure.py' after this script to 
# include pressure in the data set
#ds = Dataset('http://servdap.legi.grenoble-inp.fr/meom/ORCA05/ORCA05-I/ORCA05-G70.112_mesh_zgr.nc')
#dz=ds.variables['gdept'][:]

# land mask. doesn't make sense to me. use s==0 & t==0 instead
#ds = Dataset('http://servdap.legi.grenoble-inp.fr/meom/ORCA05/ORCA05-I/ORCA05-G70.112_byte_mask.nc')
ds = Dataset('http://servdap.legi.grenoble-inp.fr/meom/ORCA05/ORCA05-MJM89b-S/1967/ORCA05-MJM89b_y1967m12d31_gridT.nc')


print 'downloading salinity'
s=ds.variables['vosaline']
s.set_auto_maskandscale(False)
s=s[:]
print 'downloading pot. temperature'
t=ds.variables['votemper']
t.set_auto_maskandscale(False)
t=t[:]

[nt,nz,ny,nx]=s.shape

#p=100.*np.arange(nz) # in place of dz
#p=p[None,:,None,None]
#o=np.ones(lat.shape)
#p=p*o
#p=np.squeeze(p)

lat=lat*np.ones((nz,1,1))
lon=lon*np.ones((nz,1,1))


s=np.squeeze(s)
t=np.squeeze(t)
setnan= np.logical_and(s[:]==0.,t[:]==0.) # in place of mask

s[setnan]=np.nan
t[setnan]=np.nan

lat=np.squeeze(lat)
lon=np.squeeze(lon)

ds = Dataset('nemo.nc', 'w', format='NETCDF4')

ds.createDimension('z', nz)
ds.createDimension('y', ny)
ds.createDimension('x', nx)

ds.createVariable('lat','d',('z','y','x'))
ds.createVariable('lon','d',('z','y','x'))
#ds.createVariable('p','d',('z','y','x'))
ds.createVariable('s','f',('z','y','x')) # single precision!
ds.createVariable('tpot','f',('z','y','x'))

ds.variables['lat'][:]=lat
ds.variables['lon'][:]=lon
#ds.variables['p'][:]=p
ds.variables['s'][:]=s
ds.variables['tpot'][:]=t

ds.close()

