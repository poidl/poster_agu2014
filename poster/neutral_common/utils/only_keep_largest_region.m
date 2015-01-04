function [s,ct]=only_keep_largest_region(s,ct)

regions=find_regions(squeeze(s(1,:,:)));
[zi,yi,xi]=size(s);

npmaxreg=0; % number of points in largest region
for i=1:length(regions)
    if length(regions{i})>npmaxreg;
        npmaxreg=length(regions{i});
        imaxreg=i;
    end
end
setnan=true(1,xi*yi);
setnan(regions{imaxreg})=false;

s(:,setnan)=nan;
ct(:,setnan)=nan;
