function restore_intersections(ds)

[status,message] = copyfile(['./data_out/',ds{:},'/intersections.mat'],'./data/');
if ~status
    disp('restoring of intersections failed, re-computing...')
end