%function save_vars(dir,vars)

for ii=1:length(vars)
    var=vars{ii};
    save([dir,'/',var,'.mat'],var);
end