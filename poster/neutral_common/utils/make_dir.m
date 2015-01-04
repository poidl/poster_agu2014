function make_dir(dir)

% if exist(dir,'dir')
%     rmdir(dir,'s');
% end
% mkdir(dir);

if ~exist(dir,'dir')
    mkdir(dir);
end