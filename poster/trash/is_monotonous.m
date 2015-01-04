function bool=is_monotonous(f)

keyboard
fd=diff(f,1,1);
if all( fd(~isnan(fd(:)))>0 )
     bool=true;
else
    bool=false;
end