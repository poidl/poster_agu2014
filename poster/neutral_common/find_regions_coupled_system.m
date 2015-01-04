function regions=find_regions_coupled_system(vv,ex,ey)
% Finds connected regions. Two points are regarded as connected "neighbours" if they
% appear in one or more equations together. Hence, a region is formed by
% points which form a coupled system of equations. 
% This is different to find_regions(), in which two points are
% regarded as connected "neighbours" if they share a cell boundary. The
% distinction is necessary if ex, ey are slope errors, in which case the
% error could be nan between two neighbouring wet points.

% Connected component labeling: flood-fill approach
% see Steve Eddins' blog: http://blogs.mathworks.com/steve/2007/04/15/connected-component-labeling-part-4/
% This might actually be slower than Andreas' original code, and it's not easier to read. Revert? 
% Stefan 2014/11/06

global_user_input;
[yi,xi]=size(vv);

% wet points (mixed layer excluded)
wet=~isnan(vv);

le=~isnan(ex); % a link exists in eastward direction
ln=~isnan(ey); % north
lw=circshift(le,[0 1]);
ls=circshift(ln,[1 0]);
    
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
        
        ne=ntmp(:,2); % eastern neighbour
        nw=ntmp(:,4);
        nn=ntmp(:,3);
        ns=ntmp(:,1);
        
        ne(ne>xi*yi)=ne(ne>xi*yi)-xi*yi;
        nn(nn>xi*yi)=nn(nn>xi*yi)-xi*yi;
        nw(nw<1)=nw(nw<1)+xi*yi; 
        ns(ns<1)=ns(ns<1)+xi*yi;       
        
        ne=ne(lw(ne)); % keep only those which have link
        nw=nw(le(nw));
        nn=nn(ls(nn));
        ns=ns(ln(ns)); 

        n=[ne; nw; nn; ns;];    
        n = unique(n(:)); % remove duplicates
        idx = n(wet(n)); % keep only the neighbors that haven't been labelled
        if isempty(idx); break; end
        L(idx) = iregion;
        wet(idx)=0; % set the pixels that were just labeled to 0
    end
%            keyboard  
    iregion=iregion+1;
end

for ii=1:iregion-1;
    regions{ii}=find(L==ii);
end
