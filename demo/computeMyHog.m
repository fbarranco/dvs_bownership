function [out]=computeMyHog(I, numDirections, blocksize)

xsize = size(I, 2);
ysize = size(I, 1);

edges = 0:numDirections; 
d = floor(blocksize/2);

out = zeros(ysize, xsize, numDirections);

for y = 1:ysize
    for x=1:xsize
        if ~isnan(I(y,x))
           tmp = I(max(y-d,1):min(y+d, ysize), max(x-d,1):min(x+d, xsize));
           tmp(isnan(tmp)) = [];
           out(y,x,:) = histcounts(tmp, edges);
           out(y,x,:) = double(out(y,x,:)) ./numel(tmp);
        end
    end
end

end