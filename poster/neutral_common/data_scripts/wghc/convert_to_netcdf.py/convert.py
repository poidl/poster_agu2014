#!/usr/bin/env python

from netCDF4 import Dataset as NF
import numpy as np
import matplotlib.pyplot as plt

dr='/home/nfs/z3439823/mymatlab/data/wghc/WGHCGRD/'
li=[dr+'wghc0000-0595',\
dr+'wghc0600-1195',\
dr+'wghc1200-1795',\
dr+'wghc1800-2395',\
dr+'wghc2400-2995',\
dr+'wghc3000-3595']

lat=np.nan*np.ones((45,341,720))
lon=np.nan*np.ones((45,341,720))

s=np.nan*np.ones((45,341,720))
tis=np.nan*np.ones((45,341,720)) # in situ
# DEPTH, NOT PRESSURE!
p=np.nan*np.ones((45,341,720))

offs=0
for fl in li:
    file = open(fl, 'r')
    line=file.readline()
    ll=np.fromstring(line.rstrip(), dtype=float, count=-1, sep=' ')
    ii=-1
    while ii<119: #720:
        ii=ii+1
        jj=-1
        while jj<340:
#            print str(jj)+','+str(ii)
            jj=jj+1
            if len(ll)!=4:
                raise Exception('not good')
            # get lat/lon of first line
            line=file.readline()
            ll=np.fromstring(line.rstrip(), dtype=float, count=-1, sep=' ')
            lo,la=ll[:2]
            print 'lon/lat: '+str(lo)+','+str(la)
            if len(ll)!=2:
                if ll[2]>=0 and ll[3]!=-9: # pressure can be nan
                    kk=0
                    flag=True
                    while flag!=False and kk<=44:
                        sal=ll[7]
                        temp=ll[5]
                        if sal==-9:
                            sal=np.nan
                        if temp==-9:
                            temp=np.nan
                        s[kk,jj,offs+ii]=sal
                        tis[kk,jj,offs+ii]=temp
                        p[kk,jj,offs+ii]=ll[3]
                        line=file.readline()
                        ll=np.fromstring(line.rstrip(), dtype=float, count=-1, sep=' ')
                        if ll[0]!=lo or ll[1]!=la:
                            flag=False
                        kk=kk+1
                        if kk==45:
                            p_=p[:,jj,offs+ii] # remember depth
                else:
                    line=file.readline()
                    ll=np.fromstring(line.rstrip(), dtype=float, count=-1, sep=' ')

            else:
                line=file.readline()
                ll=np.fromstring(line.rstrip(), dtype=float, count=-1, sep=' ')

            lon[:,jj,offs+ii]=lo
            lat[:,jj,offs+ii]=la

    file.close()
    offs=offs+120

oo=np.ones((1,341,720)) # make pressure (depth)
p=p_[:,None,None]*oo

ds = NF('wghc.nc', 'w', format='NETCDF4')

ds.createDimension('z', 45)
ds.createDimension('y', 341)
ds.createDimension('x', 720)

ds.createVariable('lat','d',('z','y','x'))
ds.createVariable('lon','d',('z','y','x'))
ds.createVariable('p','d',('z','y','x'))
ds.createVariable('s','d',('z','y','x')) # single precision!
ds.createVariable('tis','d',('z','y','x'))

ds.variables['lat'][:]=lat
ds.variables['lon'][:]=lon
ds.variables['p'][:]=p
ds.variables['s'][:]=s
ds.variables['tis'][:]=tis

ds.close()
