% Assign direction to event

% Orientation histogram
% NUM_ORIENTATIONS = 4;
% length = 6;
% lastTimesMap = zeros(ysize, xsize, 2);
% dts = zeros(NUM_ORIENTATIONS, LENGTH);
% oridts = zeros(NUM_ORIENTATIONS, 1);
% oriDecideHelper= zeros(NUM_ORIENTATIONS, 1);

% minDtTHresholdUs = 100000;
% oriHistoryMixingFactor = 0.1;
% oriHistoryDiffThreshold = 0.5;
% dtRejectThreshold = 100000*5;


function [orient, lastTimesMap, dts, oriHistoryMap] = ...
    eventOrientation(e, offset, lastTimesMap, dts, oriHistoryMap, ...
    oriHistoryDiffThreshold, oriHistoryMixingFactor, minDtTHresholdUs, oriHistoryEnabled, ...
    dtRejectThreshold, NUM_ORIENTATIONS, LENGTH)

INT_MAX = 2147483647; 
[xsize, ysize, ~] = size(lastTimesMap);
exitFunction = 0;
oridts = zeros(NUM_ORIENTATIONS, 1);
oriDecideHelper= zeros(NUM_ORIENTATIONS, 1);


% Separate everything according to the polarity
pol = e.pol;
if pol ~=1
    pol = 2; 
else
    pol = 1;
end

lastTimesMap(e.y, e.x, pol) = e.time;


for ori=1:NUM_ORIENTATIONS
    d = squeeze(offset(ori,:,:));
    for i=1:LENGTH
        xx = e.x + d(1,i);
        yy = e.y + d(2,i);
        
        if (xx>0 && xx<=xsize && yy>0 && yy<=ysize)
           dts(ori, i) = e.time - lastTimesMap(yy, xx, pol);
        end
    end
end


%Compute the average or maximum time to last event within RF
%if ( useAverageDtEnabled ){
for ori=1:NUM_ORIENTATIONS
    oridts(ori) = 0; 
    oriDecideHelper(ori) = 0;

    count = 0;
    dtList = zeros(1,LENGTH);
    for k=1:LENGTH
        dt = dts(ori,k);
        if dt > dtRejectThreshold
            continue;
        end
        oridts(ori) = oridts(ori)+dt; %average dt
        dtList(k) = dt;
        count = count+1;
    end

    if count > 0
        oridts(ori) = oridts(ori)/count;
        for k=1:LENGTH
            if dtList(k)>0 
                dtList(k) = dtList(k) - oridts(ori);
            end
            oriDecideHelper(ori) = oriDecideHelper(ori) + dtList(k)*dtList(k);            
        end

        if(oriDecideHelper(ori)<0)
            oriDecideHelper(ori) = INT_MAX; %Happens when dtList[k]^2 is larger than maxint or the sum exceeds maxint.
        end
        oriDecideHelper(ori) = oriDecideHelper(ori)/count; %biased estimator of variance
    else
        % no samples, all outside outlier rejection threshold
        oridts(ori) = INT_MAX;
        oriDecideHelper(ori) = INT_MAX;
    end    
end % for ori


% WTA to find the one best orientation per event--">
% here we do a WTA, only 1 event max gets generated in optimal 
% orienation IFF is also satisfies coincidence timing requirement
%if ( !multiOriOutputEnabled ){

%now find min of these, this is most likely orientation, iff this time is also less than minDtThresholdUs

mindt = minDtTHresholdUs; decideHelper = 0; orient = -1;
for ori=1:NUM_ORIENTATIONS
    if oridts(ori) < mindt
        mindt = oridts(ori);
        decideHelper = oriDecideHelper(ori);
        orient = ori-1;
    else
        if oridts(ori) == mindt
            if oriDecideHelper(ori) <= decideHelper
                mindt = oridts(ori);
                orient = ori-1;
            end
        end
    end
end
% if orient == 0
%     keyboard
% end

% didn't find a good orientation(meaning oridts[ori] has been larger than minDtThresholdUs for all ori)
if  orient == -1 
    exitFunction = 1;    
end

% if oriHistoryEnabled
if (~exitFunction)    
    if oriHistoryEnabled
        %We only let the orientation pass if it is within some
        % agreement with the past orientations we found at this 
        % particular spot. If it is too different, we ignore it
        % and dont count it as a valid orientation.

        % update lowpass orientation map
        f = oriHistoryMap(e.y, e.x);
        if f == -1  
            f = orient;
        end
        f = (1 - oriHistoryMixingFactor) * f + oriHistoryMixingFactor * double(orient);
        oriHistoryMap(e.y, e.x) = f;

        %fd is the distance between the orientation in the HistoryMap
        % and the currently detected orientation.
        fd = f - orient;
        halfTypes = NUM_ORIENTATIONS / 2;
        %The distance between orientation 0 (horizontal) and ori 3
        % (up-left) is not equal to 0-3=3 but infact is just 1.
        % There is one orientation between 0 and 3, hence we need
        % to adjust here.
        if  fd > halfTypes 
            fd = fd - NUM_ORIENTATIONS;
        elseif  fd < -halfTypes 
            fd = fd + NUM_ORIENTATIONS;
        end

        if abs(fd) > oriHistoryDiffThreshold 
            % Do something here too
            orient = -1;
            exitFunction = 1;
        end
    end
end


end