% normalFlowExtrema function
% Computes normal flow --> end documentation

function createFrames(filepath, filename, initialTime, finalTime, sliceTime)

    [a,t]=loadaerdat2(strcat(filepath, filename, '/', filename, '.aedat'));    
    maskT = t>initialTime & t<finalTime; %<-- Moving horizontally
    a(maskT == 0)=[]; t(maskT == 0)=[];
    
    % And now, adjust the timestamp
    t = t - t(1)+1;    
    [x, y, pol] = extractRetinaEventsFromAddr(a);
    x = x; y = 128-(y+1);

    events.y = y;
    events.x = x;
    events.pol = pol;
    events.time = t;
    
    
    timeZero = t(1);
    sizex = 128; sizey = 128;


    % For simulated data -------------------------------------------------                
    % % Positive events only
    posFrame = zeros(sizey, sizex); 
    posTimeStamp = zeros(sizey,sizex); 
    %posVectorOfTimeStamps=zeros(sizey,sizex, 500); 
    %posLastEventPosition = ones(sizey,sizex); 

    eventCounter = 1;

    nextSliceTime = timeZero + sliceTime;
    k=1;
    
    while eventCounter<numel(events.y)
        x = events.x(eventCounter)+1;
        y = events.y(eventCounter)+1;
        timeStamp = events.time(eventCounter)-timeZero;
        %posVectorOfTimeStamps(y,x,posLastEventPosition(y,x))=timeStamp;
        %posLastEventPosition(y,x)=posLastEventPosition(y,x)+1;        

        posFrame(y, x)=posFrame(y, x) + 1;
        posTimeStamp(y, x)= timeStamp;
        eventCounter = eventCounter+1;
        
        if events.time(eventCounter) >= nextSliceTime
            posFrame = posFrame./max(posFrame(:));
            imwrite(mat2gray(posFrame), strcat(filepath, filename, '/', filename, '_', sprintf('%04d', k), '.jpg'));
            
            posTimeFrame = (posTimeStamp-min(posTimeStamp(:)))/(max(posTimeStamp(:))-min(posTimeStamp(:)));
            imwrite(mat2gray(posTimeFrame), strcat(filepath, filename, '/time/', filename, '_', sprintf('%04d', k), '.jpg'));
            
            k=k+1;
            
            nextSliceTime = nextSliceTime + sliceTime;
            posFrame = zeros(sizey, sizex); 
            posTimeStamp = zeros(sizey,sizex);
            
            timeZero = events.time(eventCounter);
        end
    end
end