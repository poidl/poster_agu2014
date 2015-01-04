### poster_agu2014

This repository contains the source code for the figures in

**S. Riha, T. J. McDougall and P. M. Barker, 2014: The Construction of a 3-d Neutral Density Variable for Arbitrary Data Sets.** Poster presented at the AGU Fall Meeting 
2014 in San Francisco.

The functions are written in MATLAB (apart from some data pre- and post-processing scripts written in bash or python, and the Fortran version of the omega-surface code).

The hardware used for this study was a typical state-of-the-art desktop with 16GB RAM (2014/12/11).

#### STRUCTURE OF `POSTER/`

- `neutral_common`  
	Contains the directory `data_scripts` for pre-processing data. You can use the scripts in `wghc` and `WOA13` 
	to download the raw data and generate temporary input files in NetCDF format. These are further pre-processed in 
	`poster/run_fields.m` before they are submitted to the `gamma_i` and `ewmod` routines. The path to the temporary input files
	is defined in `poster/run_fields.m`. Access to the NEMO data set is
	kindly provided by Laboratory of Geophysical and Industrial Flows (LEGI), University of Grenoble via their OPENDAP server.
	We point out that the pre-processing of the raw data files is crude. Our objective is not to obtain an accurate
	description of the ocean, but rather an arbitrary data set that serves as test case for our algorithms.
	
- `run.m`   
   The main MATLAB script.
	  
- `gamma_i`  
	Code described in the Jackett and McDougall 2009 manuscript (incomplete; e.g. no weighting).
	
- `ewmod`  
	Code for the method called 'ewmod'. This is an iterative method. The first integration is similar to Eden and Willebrand (1999),
	but no weighting is used here. We add subsequent iterations to make the field more neutral. The motivation for this method
	will be described elsewhere.
	   
- `gsw_matlab_paul_stabilization`  
	Code to remove instabilities from the climatologies. 
	
- `plot`  
	Plotting functions. Figures are saved in `figures`.
	
- `fortran`  and `omega`  
	Omega-surface code. Used for estimating the Fortran runtime from the MATLAB runtime.
	

#### DEPENDENCIES (SOFTWARE)

- Gibbs-SeaWater (GSW) Oceanographic Toolbox (MATLAB library).  
  Available at
  [http://www.teos-10.org/software.htm].
  Reference: McDougall, T.J. and P.M. Barker, 2011: Getting started with TEOS-10 and the Gibbs Seawater (GSW) 
  Oceanographic Toolbox, 28pp., SCOR/IAPSO WG127, ISBN 978-0-646-55621-5.

#### OPTIONAL DEPENDENCIES (SOFTWARE)

- GAMMA-N, A Package Of Neutral Density Routines   
  Reference: Jackett, D. R. and McDougall, T. J., 1997: A Neutral Density Variable forthe World’s Oceans, 
  J. Phys. Oceanogr., 27, 237–263.   
  Note that this is only necessary if you want to 'label' the gamma_i field with gamma-n values at the backbone (as we did for 
  the poster). Alternatively, you may choose, for example, to prescribe pressure at the backbone. The resulting plots will be similar, but not identical
  to the ones shown in the poster (for reasons that are presently unclear). 
  
#### DEPENDENCIES (DATA)	

- Gouretski, V. V. and Koltermann, K. P.: WOCE global hydrographic climatology, Tech. rep., Bundesamtes fuer Seeschifffahrt und 
Hydrographie, 35, 1–52, 2004.

- Locarnini, R. A., A. V. Mishonov, J. I. Antonov, T. P. Boyer, H. E. Garcia, O. K. Baranova, M. M. Zweng, C. R. Paver, J. R. 
Reagan, D. R. Johnson, M. Hamilton, and D. Seidov, 2013. World Ocean Atlas 2013, Volume 1: Temperature. S. Levitus, Ed., A. Mishonov Technical Ed.; NOAA Atlas NESDIS 73, 40 pp.

- Zweng, M.M, J.R. Reagan, J.I. Antonov, R.A. Locarnini, A.V. Mishonov, T.P. Boyer, H.E. Garcia, O.K. Baranova, 
D.R. Johnson, D.Seidov, M.M. Biddle, 2013. World Ocean Atlas 2013, Volume 2: Salinity. S. Levitus, Ed., A. Mishonov Technical Ed.; NOAA Atlas NESDIS 74, 39 pp.

- Access to the NEMO data set was kindly provided by Julien Le Sommer, Laboratory of Geophysical and Industrial Flows (LEGI), University of 
Grenoble.
