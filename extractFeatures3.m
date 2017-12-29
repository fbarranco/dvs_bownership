function extractFeatures3(filepath, filename, finalTime)

    filterSize = 5;
    minNumElems = 6; %at least 6 orientations (it's a threshold!!!)
    NUM_ORIENTATIONS = 8;
    hogBlockSize = 15;
    
    sizex = 128;
    sizey = 128;
    
    for i=20000:20000:80000
    %for i=80000:80000
        initialTime = finalTime-i;


        % Read the file
        myPrintEvents(filepath, filename, initialTime, finalTime);
        % Load results
        load(fullfile(filepath, strcat(filename, '_', num2str(finalTime), '_', num2str(initialTime))), 'events', 'sizex', 'sizey'); 
        events.x = events.x+1; events.y = events.y+1;

        % Estimate orientation
        [list_of_orient_events, orientationFrame] = estimateOrientation(events, sizex, sizey, NUM_ORIENTATIONS);

        [vectorOfTimeStamps, positionVectorOfTimeStamps] = activityFilter(list_of_orient_events, sizex, sizey, 150);

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
    for i=20000:20000:80000
%     for i=80000:80000
        initialTime = finalTime-i;

        % Read the file
%        myPrintEvents(filepath, filename, initialTime, finalTime);

        % Load results
        load(fullfile(filepath, strcat(filename, '_', num2str(finalTime), '_', num2str(initialTime))), 'posLastEventPosition', 'posTimeStamp', 'posVectorOfTimeStamps', 'firstTimeStamp');
        
        % Create the frame    
        posLastEventPosition = posLastEventPosition-1;
        save(fullfile(filepath, strcat(filename,'TimeStamps_', num2str(finalTime), '_', num2str(initialTime))), 'posLastEventPosition', 'posTimeStamp', 'posVectorOfTimeStamps', 'firstTimeStamp'); % Save orientation
    end

    
    for i=20000:20000:80000        
	    initialTime = finalTime-i;
        % Load the last map with the last time stamp locations
        load(fullfile(filepath, strcat(filename,'TimeStamps_', num2str(finalTime), '_', num2str(initialTime))), 'posTimeStamp');
	    %load(fullfile(filepath, strcat(filename, '_', num2str(finalTime), '_', num2str(initialTime))), 'sizex', 'sizey'); 
        
        %minTime = min(min(posTimeStamp(posTimeStamp~=0)));
        %posTimeStamp(posTimeStamp~=0) = posTimeStamp(posTimeStamp~=0) - minTime;        
        Inorm = mat2gray(posTimeStamp);
        
        edgeCanny = dvsCannyEdgeDetector(Inorm, 0, 'canny');
        tmp = bwmorph(edgeCanny, 'clean');
        tmp = bwmorph(tmp, 'spur');
        dvsContour = bwmorph(tmp, 'clean');
        
        %save(fullfile(filepath, strcat(filename,'Texture_', num2str(finalTime), '_', num2str(initialTime))), 'gaborFilterResponses', 'textureSegmentation'); % Save orientation
        save(fullfile(filepath, strcat(filename,'Baseline_', num2str(finalTime), '_', num2str(initialTime))), 'dvsContour', 'Inorm', 'edgeCanny'); % Save orientation
    end                

    for i=20000:20000:80000        
	    initialTime = finalTime-i;
        % Load the last map with the last time stamp locations
        load(fullfile(filepath, strcat(filename,'TimeStamps_', num2str(finalTime), '_', num2str(initialTime))), 'posTimeStamp');
	    load(fullfile(filepath, strcat(filename, '_', num2str(finalTime), '_', num2str(initialTime))), 'sizex', 'sizey'); 
        
        minTime = min(min(posTimeStamp(posTimeStamp~=0)));
        posTimeStamp(posTimeStamp~=0) = posTimeStamp(posTimeStamp~=0) - minTime;        
        Inorm = mat2gray(posTimeStamp);
        
        nscales = 3; norient = 6; 
        [EO, ~] = gaborconvolve(Inorm, nscales, norient, 3, 1.7, 0.65, 1.3, 0, 0);
        gaborFilterResponses = zeros(sizex, sizey, norient*nscales);
%         gaborFilterResponses_imag = zeros(sizex, sizey, norient*nscales);
%         gaborFilterResponses_mag = zeros(sizex, sizey, norient*nscales);
%         gaborFilterResponses_phase = zeros(sizex, sizey, norient*nscales);
        k=1;
        for s=1:3
            for o=1:6
                gaborFilterResponses(:,:,k) = mat2gray(real(EO{s,o}));
%                 gaborFilterResponses_imag(:,:,k) = imag(EO{s,o});
%                 gaborFilterResponses_mag(:,:,k) = abs(EO{s,o});
%                 gaborFilterResponses_phase(:,:,k) = angle(EO{s,o});
                k=k+1;
            end
        end
        
        
       gaborFilterResponsesMax(:,:,1) = max(gaborFilterResponses(:,:,1:6), [], 3);
       gaborFilterResponsesMax(:,:,2) = max(gaborFilterResponses(:,:,7:12), [], 3);
       gaborFilterResponsesMax(:,:,3) = max(gaborFilterResponses(:,:,13:end), [], 3);
       
       textureSegmentation = zeros(sizex, sizey);
       save(fullfile(filepath, strcat(filename,'Texture_', num2str(finalTime), '_', num2str(initialTime))), 'gaborFilterResponses', 'gaborFilterResponsesMax', 'textureSegmentation'); % Save orientation
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
    
    for i=20000:20000:80000
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

end
