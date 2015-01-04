#!/bin/bash
# The script worked for me on 2014/11/20. S. Riha

# Before getting into this you might consider downloading pre-built
# binaries from:
# http://www.teos-10.org/preteos10_software/neutral_density.html

# Download gamma.tar.Z (distributed by Jackett and McDougall 1997) and 
# place it in this folder. This script 

# *) extracts the code to a build directory
# *) replaces the Makefiles of the gamma code
# *) compiles gamma code

# The new Makefiles assume you have gfortran installed, change as required.
# There seems to be a problem if the path of the build directory is long, even
# with -ffixed-line-length-none. The pre-processing works fine (check with -E),
# and the code compiles without errors. However, when running glabel_matlab,
# ncopen throws an error because it gets a cut-off path string.

# You may have to add something like this to your matlab startup file:
# path1 = getenv('PATH')
# path1 = [path1 ':/home/z3439823/mymatlab/gamma_n/matlab-interface']
# setenv('PATH', path1)

bf=~/mymatlab/gamma_n # build directory

rm -r $bf
mkdir $bf
tar -xf gamma.tar.Z -C $bf --strip-components=1
cp Makefile $bf
cp Makefile_matlab $bf/matlab-interface/Makefile
cd $bf
make
cd $bf/matlab-interface/
make



