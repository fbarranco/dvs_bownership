%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%
% thr -> number of values aren't 0

function out=medianFilter2(I, filtersize, th)

xsize = size(I, 2);
ysize = size(I, 1);

out=zeros(ysize,xsize);

for y=1:ysize
    for x=1:xsize
        
        if (y>=floor(filtersize/2)+1) && (y<=ysize-floor(filtersize/2)) && (x>=floor(filtersize/2)+1) && (x<=xsize-floor(filtersize/2))
        
            if isnan(I(y,x))
                out(y,x) = NaN;
            else
                if I(y,x)~=0
                    tmp=I(y-floor(filtersize/2):y+floor(filtersize/2), x-floor(filtersize/2):x+floor(filtersize/2));

                    tmp = tmp(:);
                    tmp(tmp==0)=[];
                    tmp(isnan(tmp))=[];

                    out(y,x)=median(tmp);

                    if numel(tmp)<th
                        out(y,x)=0;
                    end
                end
            end
        else
            out(y,x)=I(y,x);
        end        
    end
end