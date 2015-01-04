PROGRAM = glabel_matlab nsfces_matlab

FC=gfortran

FFLAGS = -O3 -ffixed-line-length-none

%.o : %.f ; $(FC) $(FFLAGS) -c -o $@ $<

LIBS       =  ../gamma.a -lnetcdff


all: glabel_matlab nsfces_matlab

glabel_matlab: glabel_matlab.o
	$(FC) $(FFLAGS) -o $@  glabel_matlab.o $(LIBS)

nsfces_matlab: nsfces_matlab.o
	$(FC) $(FFLAGS) -o $@  nsfces_matlab.o $(LIBS)

clean :
	rm *.o 
	rm glabel_matlab
	rm nsfces_matlab
