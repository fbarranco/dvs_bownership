%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%
% thr -> number of values aren't NaN

function out=filterMax(I, mask, filtersize, minNumElems)

xsize = size(I, 2);
ysize = size(I, 1);

out=I;
d = floor(filtersize/2);

for y = 1:ysize
    for x=1:xsize
        if mask(y,x) % they are == -1
            tmp = I(max(y-d,1):min(y+d, ysize), max(x-d,1):min(x+d, xsize));
            tmp(isnan(tmp)) = [];
            
            if numel(tmp) >= floor(minNumElems/2) % Since it is not valid, change it easily
                out(y,x) = mode(tmp(:));
            end 
        else 
            if ~isnan(I(y,x))
               tmp = I(max(y-d,1):min(y+d, ysize), max(x-d,1):min(x+d, xsize));
               tmp(isnan(tmp)) = [];
            
               if numel(tmp) >= minNumElems
                    out(y,x) = mode(tmp(:));
               end
            end
        end
        
    end
end

end