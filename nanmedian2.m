%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%
% thr -> number of values aren't NaN

function out=nanmedian2(I, thr, filtersize)

xsize = size(I, 2);
ysize = size(I, 1);

out=zeros(ysize,xsize);

I(1:floor(filtersize/2),:)=NaN;
I(end-floor(filtersize/2)-1:end,:)=NaN;

I(:,1:floor(filtersize/2))=NaN;
I(:,end-floor(filtersize/2)-1:end)=NaN;

for y=floor(filtersize/2)+1:ysize-floor(filtersize/2)
    for x=floor(filtersize/2)+1:xsize-floor(filtersize/2)
        if ~isnan(I(y,x))
            tmp=I(y-floor(filtersize/2):y+floor(filtersize/2),x-floor(filtersize/2):x+floor(filtersize/2));
            count=(filtersize*filtersize)-sum(sum(isnan(tmp)));
            
            if count> thr
                tmp(isnan(tmp))=[];
                out(y,x)=nanmedian(tmp(:));
            else
                out(y,x)=NaN;
            end
            
        end
    end
end