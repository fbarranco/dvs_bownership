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
for i=1:numel(pos_ind)
%     [posy, posx] = ind2sub([sizey, sizex], pos_ind(i));
    lastTimeStamp_pos(pos_ind(i))= post(i);
    %block = posFrame(posy-1:posy+1, posx-1:posx+1);
    
    block_time = lastTimeStamp_pos(max(posy(i)-2,1):min(posy(i)+2, sizey), max(posx(i)-2,1):min(posx(i)+2, sizex));
    mask = block_time > (lastTimeStamp_pos(posy(i),posx(i))-thresTimeActivity); %mask(2,2)=0;
    mask(floor((min(posy(i)+2,sizey)-max(posy(i)-2,1)+1)/2)+1, floor((min(posx(i)+2, sizex)-max(posx(i)-2,1)+1)/2)+1)=0;
    
    if sum(mask(:)) > 1
%         posFrame(pos_ind(i))= posFrame(pos_ind(i))+1;
        tmp_ind = sub2ind([sizey, sizex, MAX_EVENTS], posy(i), posx(i), posPositionVectorOfTimeStamps(pos_ind(i)));
        posVectorOfTimeStamps(tmp_ind)=post(i);
        posPositionVectorOfTimeStamps(pos_ind(i))=posPositionVectorOfTimeStamps(pos_ind(i))+1;
    end
end

end