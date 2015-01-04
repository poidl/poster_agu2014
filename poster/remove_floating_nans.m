function [s,ct,inds]=remove_floating_nans(s,ct)


in=isnan(s)|isnan(ct);
s(in)=nan;
ct(in)=nan;

bot=in & circshift(~in,[1 0 0]); % not good if true more than once in a water column
bot(1,:,:)=false;
su=sum(bot,1);
inds=find(su(:)>1);
if ~isempty(inds)
    warning(['removing ',num2str(length(inds)),' floating nan(s) from input data by raising topography'])
end
cs=cumsum(bot,1);
s(cs>0)=nan;
ct(cs>0)=nan;

