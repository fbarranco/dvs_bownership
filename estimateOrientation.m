function  [list_of_orient_events, orientationFrame] = estimateOrientation(list_of_events, sizex, sizey, NUM_ORIENTATIONS)

list_of_orient_events = [];
offset = createOffsets();

%NUM_ORIENTATIONS = 8;
% LENGTH = 6;
LENGTH = 10;
lastTimesMap = zeros(sizey, sizex, 2); % x2 because of polarity
dts = zeros(NUM_ORIENTATIONS, LENGTH);
oriHistoryEnabled=1;

minDtTHresholdUs = 100000;
oriHistoryMixingFactor = 0.1;
oriHistoryDiffThreshold = 0.5;
dtRejectThreshold = 100000*5;

orientationFrame = ones(sizey, sizex)*NaN;
oriHistoryMap = -1*ones(sizey, sizex); % Initialized to non valid values



for i=1:numel(list_of_events.x)
    event.x = list_of_events.x(i); event.y = list_of_events.y(i);
    event.pol = list_of_events.pol(i); event.time = list_of_events.time(i);
    
    [orient, updated_lastTimesMap, updated_dts, updated_oriHistoryMap] = ...
    eventOrientation(event, offset, lastTimesMap, dts, oriHistoryMap, ...
    oriHistoryDiffThreshold, oriHistoryMixingFactor, minDtTHresholdUs, oriHistoryEnabled, ...
    dtRejectThreshold, NUM_ORIENTATIONS, LENGTH);
    
    lastTimesMap = updated_lastTimesMap;
    dts = updated_dts;
    oriHistoryMap = updated_oriHistoryMap;
    
    
    %[updatedVectorMap, orient] = eventOrientation(event, vectorMap, width, height, ...
    % dt, synapticWeight, useOrientationHistory, orientationHistoryWeight, thrOrientation, thrGradient, neighborThr);
    
    event.orient = orient;
    %list_of_orient_events = [list_of_orient_events, event];
    
    list_of_orient_events.x(i) = event.x; list_of_orient_events.y(i) = event.y;
    list_of_orient_events.pol(i) = event.pol; list_of_orient_events.time(i) = event.time;
    list_of_orient_events.orient(i) = event.orient;
    
    orientationFrame(event.y, event.x)=orient;
end

end


% function offset = createOffsets()
% 
% offset(1,1,:)=[ 0  0  0  0  0  0];
% offset(1,2,:)=[-3 -2 -1  1  2  3];
% 
% offset(2,1,:)=[-3 -2 -1  1  2  3];
% offset(2,2,:)=[-3 -2 -1  1  2  3];
% 
% offset(3,1,:)=[-3 -2 -1  1  2  3];
% offset(3,2,:)=[ 0  0  0  0  0  0];
% 
% offset(4,1,:)=[ 3  2  1 -1 -2 -3];
% offset(4,2,:)=[-3 -2 -1  1  2  3];
% 
% end




% function offset = createOffsets()
%     offset(1,1,:)=[-5 -4 -3 -2 -1  1  2  3  4  5];
%     offset(1,2,:)=[ 0  0  0  0  0  0  0  0  0  0]; 
%     
%     offset(2,1,:)=[ 5  4  3  2  1 -1 -2 -3 -4 -5];
%     offset(2,2,:)=[-5 -4 -3 -2 -1  1  2  3  4  5];
%     
%     offset(3,1,:)=[ 0  0  0  0  0  0  0  0  0  0]; 
%     offset(3,2,:)=[-5 -4 -3 -2 -1  1  2  3  4  5];
%     
%     offset(4,1,:)=[-5 -4 -3 -2 -1  1  2  3  4  5];
%     offset(4,2,:)=[-5 -4 -3 -2 -1  1  2  3  4  5];        
% end


function offset = createOffsets()
    offset(1,1,:)=[-5 -4 -3 -2 -1  1  2  3  4  5];
    offset(1,2,:)=[ 0  0  0  0  0  0  0  0  0  0];
        
    offset(2,1,:)=[ 5  4  3  2  1 -1 -2 -3 -4 -5];
    offset(2,2,:)=[-2 -2 -1 -1  0  0  1  1  2  2];
    
    offset(3,1,:)=[ 5  4  3  2  1 -1 -2 -3 -4 -5];
    offset(3,2,:)=[-5 -4 -3 -2 -1  1  2  3  4  5];
    
    offset(4,1,:)=[-2 -2 -1 -1  0  0  1  1  2  2];
    offset(4,2,:)=[ 5  4  3  2  1 -1 -2 -3 -4 -5];
        
    offset(5,1,:)=[ 0  0  0  0  0  0  0  0  0  0];
    offset(5,2,:)=[-5 -4 -3 -2 -1  1  2  3  4  5];
    
    offset(6,1,:)=[ 2  2  1  1  0  0 -1 -1 -2 -2];
    offset(6,2,:)=[ 5  4  3  2  1 -1 -2 -3 -4 -5];
    
    offset(7,1,:)=[-5 -4 -3 -2 -1  1  2  3  4  5];
    offset(7,2,:)=[-5 -4 -3 -2 -1  1  2  3  4  5];        
    
    offset(8,1,:)=[ 5  4  3  2  1 -1 -2 -3 -4 -5];
    offset(8,2,:)=[ 2  2  1  1  0  0 -1 -1 -2 -2];
end
