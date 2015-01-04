c/ AUTHOR: Viktor Gouretski
c/ BSH, Hamburg, 20 February 2004


c/      program read_wghc_climatology

c/ this sample program reads in gridded files of the WOCE GLOBAL HYDROGRAPHIC CLIMATOLOGY


      character*80 filein

      real*4       par(13,100),error(5,100)

      real*4       var(6,100)    

      integer*4    levels(6,100)



      write(6,*)'input grid-file name'
      read(5,80) filein
      open(20,file=filein,status='old')

      write(6,*)'Latitude and Longitude of the grid-node to display'
      read(5,*)y,x

                       
80    format(a80)      

3033  format(i2,1x,3f6.0) 

5030  format(2f6.1,3f6.0,3f10.6,
     *f8.3,f8.2,2f8.3,
     *5f5.2,5i4,
     *6f8.3,4f10.6)   
        
      

      do 1 i=1,720   ! start  longitude  loop  

      do 11 j=1,341  ! start  latitude   loop
      
      read(20,3033,end=2,err=2)
     *nbrlev,radbub,radcor,depthml

      do k=1,nbrlev  ! start standard level loop
            
      read(20,5030)xgrid,ygrid,etdep,
     *(par(ipa,k),ipa=1,9),
     *(error(ipa,k),ipa=1,5),
     *(levels(ipa,k),ipa=1,5),
     *(var(ipa,k),ipa=1,6),
     *(par(ipa,k),ipa=10,13)
         
      end do

      if(xgrid.ne.x.or.ygrid.ne.y) goto 11

      do k=1,nbrlev
      write(6,5030)xgrid,ygrid,etdep,
     *(par(ipa,k),ipa=1,9),
     *(error(ipa,k),ipa=1,5),
     *(levels(ipa,k),ipa=1,5),
     *(var(ipa,k),ipa=1,6),
     *(par(ipa,k),ipa=10,13)
      end do

      stop

c/     nbrlev - number of gridded levels
c/     radbub - radius of the influence bubble (km)
c/     radcor - decorrelation length scale (km)
c/     depthml - mixed layer depth (m), defined as depth where 
c/               vertical density gradient >= 0.005 kg/m4
      

c      xgrid - grid-node longitude (from 0 to 359.5E)
c      ygrid - grid-node latitude (from -80S to 90N)
c      etdep - grid-node ETOPO5 depth (m)

C      par(1,k) - depth (m) of the k-th level
c      par(2,k) - pressure (dbar) 
c      par(3,k) - temperature_in-situ   (degr. C)
c      par(4,k) - potential temperature (degr. C)
c      par(5,k) - salinity
c      par(6,k) - oxygen (ml/l)
c      par(7,k) - silicate (umol/kg)
c      par(8,k) - nitrate (umol/kg)
c      par(9,k) - phosphate (umol/kg)
c      par(10,k) - gamma-n
c      par(11,k) - sig-0 (kg/m3)
c      par(12,k) - sig-2 (kg/m3)
c      par(13,k) - sig-4 (kg/m3)

c      error(1,k) - relative optimum interpolation error for T, Theta & S
c      error(2,k) - relative optimum interpolation error for Oxygen
c      error(3,k) - relative optimum interpolation error for Silicate
c      error(4,k) - relative optimum interpolation error for Nitrate
c      error(5,k) - relative optimum interpolation error for Phosphate
     
c      levels(1,k) - actual number of observations used for the optimal interpolation of T, Theta & S
c      levels(2,k) - actual number of observations used for the optimal interpolation of Oxygen
c      levels(3,k) - actual number of observations used for the optimal interpolation of Silicate
c      levels(4,k) - actual number of observations used for the optimal interpolation of Nitarte
c      levels(5,k) - actual number of observations used for the optimal interpolation of Phosphate

c       var(1,k) - temperature standard deviation  from the mean (within the influence radius = radcor)  
c       var(2,k) - salinity    standard deviation  from the mean (within the influence radius = radcor)  
c       var(3,k) - oxygen      standard deviation  from the mean (within the influence radius = radcor)  
c       var(4,k) - silicate    standard deviation  from the mean (within the influence radius = radcor)  
c       var(5,k) - nitrate     standard deviation  from the mean (within the influence radius = radcor)  
c       var(6,k) - phosphate   standard deviation  from the mean (within the influence radius = radcor)  

11    continue 

      write(6,*)'All nodes where longitude =',xgrid,' have been read'
      
1     continue  

2     stop

      end
      




