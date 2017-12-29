function [posVectorOfTimeStamps, posPositionVectorOfTimeStamps] = activityFilter(posEvents, sizex, sizey, MAX_EVENTS)

thresTimeActivity = 2000;
% thresMaxActivity = 15;

posx = posEvents.x; posy = posEvents.y; post = posEvents.time;
pos_ind = sub2ind([sizey, sizex], posy, posx);

% posFrame = zeros(sizey, sizex); negFrame = zeros(sizey, sizex);
lastTimeStamp_pos = zeros(sizey, sizex); 
posPositionVectorOfTimeStamps= ones(sizey, sizex); 
posVectorOfTimeStamps= zeros(sizey, sizex, MAX_EVENTS);


% From now, apply the noise activity filter
for ii=1:numel(pos_ind)
    lastTimeStamp_pos(pos_ind(ii))= post(ii);
    
    block_time = lastTimeStamp_pos(max(posy(ii)-2,1):min(posy(ii)+2, sizey), max(posx(ii)-2,1):min(posx(ii)+2, sizex));
    mask = block_time > (lastTimeStamp_pos(posy(ii),posx(ii))-thresTimeActivity); %mask(2,2)=0;
    mask(floor((min(posy(ii)+2,sizey)-max(posy(ii)-2,1)+1)/2)+1, floor((min(posx(ii)+2, sizex)-max(posx(ii)-2,1)+1)/2)+1)=0;
    
    if sum(mask(:)) > 1
        tmp_ind = sub2ind([sizey, sizex, MAX_EVENTS], posy(ii), posx(ii), posPositionVectorOfTimeStamps(pos_ind(ii)));
        posVectorOfTimeStamps(tmp_ind)=post(ii);
        posPositionVectorOfTimeStamps(pos_ind(ii))=posPositionVectorOfTimeStamps(pos_ind(ii))+1;
    end
end

end