function [posTimeStamp, posLastEventPosition] = estimateTimeStampFeatures(events)
    DVSW = 128; DVSH = 128;
    
    posTimeStamp = zeros(DVSH,DVSW);
    posLastEventPosition = zeros(DVSH,DVSW);
        
    onofflist=(events.x-1)*DVSW+(events.y-1)+1;
    posTimeStamp(onofflist)=events.time;
    
    %tmp = histcounts(onofflist, 1:DVSH*DVSW+1);
    %posLastEventPosition = reshape(tmp, DVSH, DVSW);
end


