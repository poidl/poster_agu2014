#!/usr/bin/python

from netCDF4 import Dataset
import numpy as np

ds1 = Dataset('woa13_decav_s00_01.nc', 'r')
ds2 = Dataset('woa13_decav_t00_01.nc', 'r')

lon=ds1.variables['lon'][:]
lat=ds1.variables['lat'][:]
p=ds1.variables['depth'][:]
s=ds1.variables['s_an'][:]

s=np.squeeze(s)
[nz,ny,nx]=s.shape

oo=np.ones((1,ny,nx))
p=p[:,None,None]*oo
oo=np.ones((nz,ny,1))
lon=lon[None,None,:]*oo
oo=np.ones((nz,1,nx))
lat=lat[None,:,None]*oo

t=ds2.variables['t_an'][:] # in situ temperature

ds1.close()
ds2.close()

s[s>1e30]=np.nan;
t[t>1e30]=np.nan;


ds = Dataset('woa13.nc', 'w', format='NETCDF4')

ds.createDimension('z', nz)
ds.createDimension('y', ny)
ds.createDimension('x', nx)

ds.createVariable('lat','d',('z','y','x'))
ds.createVariable('lon','d',('z','y','x'))
ds.createVariable('p','d',('z','y','x'))
ds.createVariable('s','d',('z','y','x')) 
ds.createVariable('tis','d',('z','y','x'))

ds.variables['lat'][:]=lat
ds.variables['lon'][:]=lon
ds.variables['p'][:]=p
ds.variables['s'][:]=s
ds.variables['tis'][:]=t

ds.close()

