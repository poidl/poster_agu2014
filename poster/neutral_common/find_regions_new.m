function regions=find_regions(vv)
% Connected component labeling: flood-fill approach
% see Steve Eddins' blog: http://blogs.mathworks.com/steve/2007/04/15/connected-component-labeling-part-4/
% This might actually be slower than Andreas' original code, and it's not easier to read. Revert? 
% Stefan 2014/11/06

global_user_input;
[yi,xi]=size(vv);

% wet points (mixed layer excluded)
wet=~isnan(vv);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% alternative code

remove_south=[1:yi:xi*yi]-1; % southern neighbours of southern boundary points
remove_north=[yi:yi:xi*yi]+1; % northern neighbours of northern boundary points

L=zeros(size(wet)); % label matrix

iregion=1; % region label

while 1
    ii=find(wet==1,1,'first');
    if isempty(ii); break; end
    idx=ii; % linear indices of the pixels that were just found
    wet(idx)=0; % set the newly found pixels to dry
    L(idx) = iregion; % label first point
    while ~isempty(idx); % find neighbours
        offsets = [-1; yi; 1; -yi]; % neighbor offsets for a four-connected neighborhood
        ntmp = bsxfun(@plus, idx, offsets'); % find all the nonzero 4-connected neighbors
        ns=ntmp(:,1)';
        ns=setdiff(ns,remove_south); % remove southern neighbors of southern bdy
        nn=ntmp(:,3)';
        nn=setdiff(nn,remove_north);
        n=[ns, nn, ntmp(:,2)', ntmp(:,4)'];
        if zonally_periodic;  
            n(n<1)=n(n<1)+xi*yi; 
            n(n>xi*yi)=n(n>xi*yi)-xi*yi;
        else
            n=n(n>0 & n<=xi*yi); % remove western (eastern) neighbors of western (eastern) bdy
        end
        n = unique(n(:)); % remove duplicates
        idx = n(wet(n)); % keep only the neighbors that haven't been labelled
        if isempty(idx); break; end
        L(idx) = iregion;
        wet(idx)=0; % set the pixels that were just labeled to 0
    end
    iregion=iregion+1;
end

for ii=1:iregion-1;
    regions{ii}=find(L==ii);
end
