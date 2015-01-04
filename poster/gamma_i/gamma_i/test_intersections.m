load('./data/intersections.mat');
ke=k_east;
re=r_east;
kw=k_west;
rw=r_west;
kn=k_north;
rn=r_north;
ks=k_south;
rs=r_south;

load('./data/intersections_new.mat');

%keyboard
if any(ke(~isnan(ke(:))) ~= k_east(~isnan(k_east(:))))
    error('e')
elseif any(kw(~isnan(kw(:))) ~= k_west(~isnan(k_west(:))))
    error('w')
elseif any(kn(~isnan(kn(:))) ~= k_north(~isnan(k_north(:))))
    error('n')
elseif any(ks(~isnan(ks(:))) ~= k_south(~isnan(k_south(:))))
    error('s')
else
    disp('good')
end


