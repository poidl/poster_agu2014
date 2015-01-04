function write_scalar(fname,scalar)

fileID = fopen(fname,'a');
fprintf(fileID,'%12.2f\n',scalar);
fclose(fileID);