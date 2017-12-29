% th1 is similar to the activity filter. Do not take into account events
% that happened a long time ago (> th1)
%
% th2 is a threshold for a distance. Re-calculate the fitted plane when 
% a new event comes and the distance to the plane is > th2

% th1=5000;
% th2=0.5;
function [Vx, Vy, flowTimeStamp, posFrame] = visualFlow(events, blockSize, th1, th2, maxspeed, xsize, ysize)

x = events.x; y = events.y; 
t = events.time; pol = events.pol;


%------------------------------------------------------
%Code #1 Initialization 
%alpha=.5
Iflotvx_neg=zeros(ysize,xsize); Iflotvy_neg=zeros(ysize,xsize); Iflotvx_pos=zeros(ysize,xsize); Iflotvy_pos=zeros(ysize,xsize);
It_pos=zeros(xsize, ysize);  It_neg=zeros(xsize, ysize);
flowTimeStamp_pos=zeros(xsize, ysize); flowTimeStamp_neg=zeros(xsize, ysize); flowTimeStamp = zeros(xsize, ysize);
% blockSize=2; %size of the half block
%------------------------------------------------------

% Before beginning with the plane fitting, we should collect in It all the
% events whose timestamp is less than the threshold th1 in fitt
posFrame = zeros(ysize, xsize);


for ii=1:5:numel(t)
    %Update position
    ptx = x(ii)+1;
    pty = y(ii)+1;
    %Get the timestamps of the positions: storing only the last event
    %if pol(i)==1
       It_pos(pty, ptx)=t(ii); % put his time in the timetable
    %else
    %   It_neg(pty, ptx)=t(i); % put his time in the timetable
    %end 
    %timeStamp = t(i);
        
    %Discarding events out of the border (borderSize == blockSize == 8)
    if (ptx>blockSize+1 && ptx<xsize-(blockSize+1))
       if (pty>blockSize+1 && pty<ysize-(blockSize+1))

           % Extract time region around (ptx,pty) position
           % Region is (blockSize+1+blockSize) x (blockSize+1+blockSize)
           %            17 x 17 (blockSize ==8)
           %if pol(i)==1
               m=It_pos(pty-blockSize:pty+blockSize,ptx-blockSize:ptx+blockSize); 
           %else
           %    m=It_neg(pty-blockSize:pty+blockSize,ptx-blockSize:ptx+blockSize); 
           %end

           % Remove those events that happened long time ago respect the timestamp of (ptx, pty)--> 20% 
           % The time of ptx,pty is m(blockSize+1, blockSize+1)
           %m(abs(m(blockSize+1,blockSize+1)-m)/m(blockSize+1,blockSize+1)>0.2)=0;
           m(abs(m(blockSize+1,blockSize+1)-m)>th1)= 0;
           
           %If there are any new events
            if (sum(m(:)>0))
                
                [vvx,vvy]=fiit(m, t(ii), th1, th2);

                vvx(isnan(vvx)) = 0;
                vvy(isnan(vvy)) = 0;
                vvx(isinf(vvx)) = 0;
                vvy(isinf(vvy)) = 0;
                
                % Set thresholds for maximum and minimum velocities
                vvx(abs(vvx) > maxspeed) = 0;
                vvy(abs(vvy) > maxspeed) = 0;

                if (norm([vvx,vvy])>0)
                    %if pol(i)==1
                        Iflotvx_pos(pty,ptx)=vvx(blockSize+1,blockSize+1);
                        Iflotvy_pos(pty,ptx)=vvy(blockSize+1,blockSize+1);
                        %flowTimeStamp_pos(pty,ptx) = timeStamp;
                        %posFrame(pty,ptx)=posFrame(pty,ptx)+1;
                    %else
                    %    Iflotvx_neg(pty,ptx)=vvx(blockSize+1,blockSize+1);
                    %    Iflotvy_neg(pty,ptx)=vvy(blockSize+1,blockSize+1);
                    %    flowTimeStamp_neg(pty,ptx) = timeStamp;                        
                    %%end                   
                end
            end % if (sum(m(:)>0))
       end %if pty
    end %if ptx

end %for i=1:1:length(t)
% keyboard


Vy = Iflotvy_pos;
Vx = Iflotvx_pos;

%[Vx, flowTimeStamp] = myCreateCombinedData(Vx_pos, Vx_neg, flowTimeStamp_pos, flowTimeStamp_neg);
%[Vx, ~] = createCombinedData(Vx_pos, Vx_neg, flowTimeStamp_pos, flowTimeStamp_neg);
%[Vy, flowTimeStamp] = createCombinedData(Vy_pos, Vy_neg, flowTimeStamp_pos, flowTimeStamp_neg);

end

function [C, flowTimeStamp] = createCombinedData(A, B, timeA, timeB)

[xsize, ysize] = size(A);

C = zeros(size(A,1), size(A,2));
flowTimeStamp= zeros(size(A,1), size(A,2));

for i=1:xsize
    for j=1:ysize
        if A(i,j) == B(i,j)
            C(i,j)=A(i,j);
            flowTimeStamp(i,j) = timeA(i,j);
        else
            if A(i,j)==0
                C(i,j)=B(i,j);
                flowTimeStamp(i,j) = timeB(i,j);
            end
            
            if B(i,j)==0
                C(i,j)=A(i,j);
                flowTimeStamp(i,j) = timeA(i,j);
            end            
        end
    end
end

end