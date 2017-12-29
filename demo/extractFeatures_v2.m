function [out, Ox, Oy] = extractFeatures_v2(posx, posy, pol, time)

    sizey = 128; sizex = 128;
    out = zeros(sizey,sizex,16);
    filterSize = 5;
    minNumElems = 6; %at least 6 orientations (it's a threshold!!!)
%     NUM_ORIENTATIONS = 8;
    NUM_ORIENTATIONS = 4;
    hogBlockSize = 15;
    Ox = zeros(sizey,sizex); Oy = zeros(sizey,sizex);

    events.x = posx; events.y = posy; events.pol = pol; events.time = time-time(1);

%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % Estimate orientation
%     [list_of_orient_events, orientationFrame] = estimateOrientation(events, sizex, sizey, NUM_ORIENTATIONS);
%     %[~, positionVectorOfTimeStamps] = activityFilter(list_of_orient_events, sizex, sizey, 75);
% 
%     % First, clean some of the activity (activity filters)
%     %mask = (positionVectorOfTimeStamps ==1);
%     %orientationFrame(mask)=NaN;
% 
%     % Now, solve for orientationFrame == -1 
%     mask = (orientationFrame == -1);
%     orientationFrame(orientationFrame==-1)=NaN;
% 
%     % Now, solve also max, but only substituting values that are no NaN
%     %filteredOrientationFrame = filterMax(orientationFrame, mask, filterSize, minNumElems);
%     %filteredOrientationFrame = floor(filteredOrientationFrame); % filterMax can give decimals               
%     %hog = computeMyHog(filteredOrientationFrame, NUM_ORIENTATIONS, hogBlockSize);
% 
%     % Create the frame
%     %positionVectorOfTimeStamps = positionVectorOfTimeStamps-1; % Accumulated events per position
%     
%     %out(:,:,1) = filteredOrientationFrame;
%     out(:,:,2) = orientationFrame;
%     %out(:,:,3) = positionVectorOfTimeStamps;
%     %out(:,:,8:15) = hog;
%     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Now, the second feature will be the time
    % Create the frame
    [posTimeStamp, ~ ] = estimateTimeStampFeatures(events);
    out(:,:,7) = posTimeStamp./1e4;

    
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % Now, the third feature will be the gradient in time
%      thresholdActivity = 5000; thresholdDistance = 0.3;    
%      blockSize = 1; maxspeed = 0.4;
%      [Ox, Oy, ~ , ~] = visualFlow(events, blockSize, thresholdActivity, thresholdDistance, maxspeed, sizex, sizey);
%     
%     
%     out(:,:,4) = Ox;
%     out(:,:,5) = Oy;
%     out(:,:,6) = posLastEventPosition;
%     out(:,:,16)= flowTimeStamp./1e4;
        
end