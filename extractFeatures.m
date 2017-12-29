function extractFeatures(filepath, filename, finalTime)

    filterSize = 5;
    minNumElems = 6; %at least 6 orientations (it's a threshold!!!)
    NUM_ORIENTATIONS = 8;
    hogBlockSize = 15;
    
    %for i=20000:20000:100000
    for i=80000:80000
        initialTime = finalTime-i;


        % Read the file
        myPrintEvents(filepath, filename, initialTime, finalTime);
        % Load results
        load(fullfile(filepath, strcat(filename, '_', num2str(finalTime), '_', num2str(initialTime))), 'events', 'sizex', 'sizey'); 
        events.x = events.x+1; events.y = events.y+1;

        % Estimate orientation
        [list_of_orient_events, orientationFrame] = estimateOrientation(events, sizex, sizey, NUM_ORIENTATIONS);

        [vectorOfTimeStamps, positionVectorOfTimeStamps] = activityFilter(list_of_orient_events, sizex, sizey, 75);

        % First, clean some of the activity (activity filters)
        mask = (positionVectorOfTimeStamps ==1);
        orientationFrame(mask)=NaN;

        % Now, solve for orientationFrame == -1 
        mask = (orientationFrame == -1);
        orientationFrame(orientationFrame==-1)=NaN;

        % Now, solve also max, but only substituting values that are no NaN
        filteredOrientationFrame = filterMax(orientationFrame, mask, filterSize, minNumElems);
        filteredOrientationFrame = floor(filteredOrientationFrame); % filterMax can give decimals
        
        
        hog = computeMyHog(filteredOrientationFrame, NUM_ORIENTATIONS, hogBlockSize);
        

        % Only for visualization
    %     frame = filteredOrientationFrame; frame(isnan(frame)) = -1;
    %     figure, imagesc(frame), axis image    

        % Create the frame
        positionVectorOfTimeStamps = positionVectorOfTimeStamps-1; % Accumulated events per position
        save(fullfile(filepath, strcat(filename,'Orientation_', num2str(finalTime), '_', num2str(initialTime))), 'orientationFrame', 'filteredOrientationFrame', 'positionVectorOfTimeStamps', 'hog'); % Save orientation
    end


    % Now, the second feature will be the time
    %for i=20000:20000:100000
    for i=80000:80000
        initialTime = finalTime-i;

        % Read the file
%        myPrintEvents(filepath, filename, initialTime, finalTime);

        % Load results
        load(fullfile(filepath, strcat(filename, '_', num2str(finalTime), '_', num2str(initialTime))), 'posLastEventPosition', 'posTimeStamp', 'posVectorOfTimeStamps', 'firstTimeStamp');
        
        % Create the frame    
        posLastEventPosition = posLastEventPosition-1;
        save(fullfile(filepath, strcat(filename,'TimeStamps_', num2str(finalTime), '_', num2str(initialTime))), 'posLastEventPosition', 'posTimeStamp', 'posVectorOfTimeStamps', 'firstTimeStamp'); % Save orientation
    end


    % Now, the third feature will be the gradient in time
    thresholdActivity = 7500;
    thresholdDistance = 0.2;
    
%     thresholdActivity = 5000;
%     thresholdDistance = 0.5;
    blockSize = 2;
    maxspeed = 2;
    
    
    thresholdActivity = 20000;
    thresholdDistance = 0.3;
    
%     thresholdActivity = 5000;
%     thresholdDistance = 0.5;
    blockSize = 2;
    maxspeed = 0.4;
    
    %for i=20000:20000:100000
    for i=80000:80000
        initialTime = finalTime-i;

        % Read the file
        %myPrintEvents(filepath, filename, initialTime, finalTime);

        % Load results
        load(fullfile(filepath, strcat(filename, '_', num2str(finalTime), '_', num2str(initialTime))), 'events', 'sizex', 'sizey', 'posLastEventPosition');
        events.x = events.x+1; events.y = events.y+1;

        [Ox, Oy, flowTimeStamp, posFrame] = visualFlow(events, blockSize, thresholdActivity, thresholdDistance, maxspeed, sizex, sizey);        

        % Create the frame
        posLastEventPosition = posLastEventPosition-1;
        save(fullfile(filepath, strcat(filename,'TempGradient_', num2str(finalTime), '_', num2str(initialTime))), 'posLastEventPosition', 'Ox', 'Oy', 'flowTimeStamp', 'posFrame');
    end
% keyboard
end