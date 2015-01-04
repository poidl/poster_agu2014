function error_iso_averaged(methods,datasets)

close all

error='df';
mapto='sig4';
y1=1e-11; y2=1e-2;
ylab='D_f [m^2/s]';
fout_prefix='error_iso_averaged_df';
error_iso_averaged_script;

% mapto='sig2';
% error_iso_averaged_script
% 
% mapto='sig4';
% error_iso_averaged_script

error='dms';
mapto='sig4';
y1=1e-10; y2=1e-6;
ylab='rms \epsilon [kg/m^4]';
fout_prefix='error_iso_averaged_erms';
error_iso_averaged_script;

% mapto='sig2';
% error_iso_averaged_script
% 
% mapto='sig4';
% error_iso_averaged_script
