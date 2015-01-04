#!/usr/bin/python

from netCDF4 import Dataset
import numpy as np

ds1 = Dataset('ORCA05-G70.112_mesh_zgr.nc', 'r')

p=ds1.variables['gdept'][:]

ds1.close()

ds2 = Dataset('nemo.nc', 'a')

s=ds2.variables['s']

[nz,ny,nx]=s.shape
oo=np.ones((1,ny,nx))

p=p*oo

ds2.createVariable('p','d',('z','y','x'))
ds2.variables['p'][:]=p
ds2.close()
