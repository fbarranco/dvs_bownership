% normalFlowExtrema function
% Computes normal flow --> end documentation

function myPrintEventsForVideo(filepath, filename, initialTime, finalTime, a,t)

    disp(filename);
    
    initialTime_cpy = initialTime;
    finalTime_cpy = finalTime;
    % % % %-----------------------------------------
    % For real sequences
    
    
    
    initialTime = t(1) + initialTime;
    finalTime = t(1)+finalTime;
    
    maskT = t>initialTime & t<finalTime; %<-- Moving horizontally
    a(maskT == 0)=[]; t(maskT == 0)=[];
%     keyboard
    % Remove the first ones
    %a(1:100)=[]; t(1:100)=[];
    
    % And now, adjust the timestamp
    t = t - t(1)+1;    
    [x, y, pol] = extractRetinaEventsFromAddr(a);
    x = x; y = 128-(y+1);
    
    % Only for saving the .mat file with events
    posx = x; posy=y; timeStamp = t; I1 = zeros(128,128);
    
    
    events.y = y;
    events.x = x;
    events.pol = pol;
    events.time = t;
    
    initialTime = t(1);
    sizex = 128; sizey = 128;
    
    % For simulated data -------------------------------------------------                
    % % Positive events only
    posFrame = zeros(sizey, sizex);
    posTimeStamp = zeros(sizey,sizex);
    firstTimeStamp = zeros(sizey, sizex);
    posVectorOfTimeStamps=zeros(sizey,sizex, 500);
    posLastEventPosition = ones(sizey,sizex);
    
    posCounter = 1;

    while posCounter<numel(events.y)
        x = events.x(posCounter)+1;
        y = events.y(posCounter)+1;
        timeStamp = events.time(posCounter)-initialTime;
        posVectorOfTimeStamps(y,x,posLastEventPosition(y,x))=timeStamp;
        posLastEventPosition(y,x)=posLastEventPosition(y,x)+1;        

        posFrame(y, x)=posFrame(y, x)+1;
        if posTimeStamp(y,x)==0
            firstTimeStamp(y,x)=timeStamp;
        end
        posTimeStamp(y, x)= timeStamp;
        

        posCounter = posCounter+1;
    end

   save(fullfile(filepath, strcat(filename, '_', sprintf('%09d', finalTime_cpy), '_', sprintf('%09d', initialTime_cpy)))); 
end