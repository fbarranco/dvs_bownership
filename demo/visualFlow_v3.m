% th1 is similar to the activity filter. Do not take into account events
% that happened a long time ago (> th1)
%
% th2 is a threshold for a distance. Re-calculate the fitted plane when 
% a new event comes and the distance to the plane is > th2

% th1=5000;
% th2=0.5;
function [Ox, Oy] = visualFlow_v3(events)

DVSH = 128; DVSW=128;
%Extracting normal flow using:
%Benosman et al. 2012, Asynchronous frameless event-based optical flow
% posEvents.x = events.x;
% posEvents.y = events.y;
% posEvents.time = events.time;
% posEvents.pol = events.pol;

%Gradients computation
%Take only a At of 50 micros <<-it's too small
shift = 1;
time_t = events.time(shift);
time_t1 = time_t + 10000;
time_At = time_t + 25000; %<---8 ms

posFrame = zeros(128,128);
initPosition = shift;
counter = initPosition;
currentTime = time_t;


pos_events.x = events.x(events.pol==1);
pos_events.y = events.y(events.pol==1);
pos_events.time = events.time(events.pol==1);
neg_events.x = events.x(events.pol~=1);
neg_events.y = events.y(events.pol~=1);
neg_events.time = events.time(events.pol~=1);

onofflist=(pos_events.x-1)*DVSW+(pos_events.y-1)+1;
tmp = histcounts(onofflist, 1:DVSH*DVSW+1);
posFrame = reshape(tmp, DVSH, DVSW);

onofflist=(neg_events.x-1)*DVSW+(neg_events.y-1)+1;
tmp = histcounts(onofflist, 1:DVSH*DVSW+1);
negFrame = reshape(tmp, DVSH, DVSW);

% while currentTime<time_At
%     posFrame(posEvents.y(counter), posEvents.x(counter))=posFrame(posEvents.y(counter),posEvents.x(counter))+1;
%     
%     counter = counter+1;
%     currentTime = posEvents.time(counter);    
% end

%Event spatial derivative
% DiffKernelxy2 = [0.6860408186912537 -0.6860408186912537];
%DiffKernelxy = [-1 0 1];
DiffKernelxy = [-1 8 0 -8 1]/12;
event_dx = conv2(double(posFrame)-double(negFrame), DiffKernelxy, 'same');
event_dy = conv2(double(posFrame)-double(negFrame), DiffKernelxy', 'same');


%Event temporal derivative
event_dt = zeros(128,128);
counter = initPosition;
currentTime = time_t;


pos_events.x(pos_events.time>time_t1) = []; pos_events.y(pos_events.time>time_t1) = [];
onofflist=(pos_events.x-1)*DVSW+(pos_events.y-1)+1;
tmp = histcounts(onofflist, 1:DVSH*DVSW+1);
pos_event_dt= reshape(tmp, DVSH, DVSW);

neg_events.x(neg_events.time>time_t1) = []; neg_events.y(neg_events.time>time_t1) = [];
onofflist=(neg_events.x-1)*DVSW+(neg_events.y-1)+1;
tmp = histcounts(onofflist, 1:DVSH*DVSW+1);
neg_event_dt= reshape(tmp, DVSH, DVSW);
event_dt = double(pos_event_dt) - double(neg_event_dt);

% while currentTime<time_t1
%     %if posEvents.pol ==1
%         event_dt(posEvents.y(counter),posEvents.x(counter))=event_dt(posEvents.y(counter),posEvents.x(counter))+1;
%     %else
%     %    event_dt(posEvents.y(counter),posEvents.x(counter))=event_dt(posEvents.y(counter),posEvents.x(counter))-1;
%     %end
%     
%     counter = counter+1;
%     currentTime = posEvents.time(counter);
% end

% event_dt = event_dt/double(time_t1-time_t);


%%Optical flow computation
%Weighting matrix
w = [0.0625 0.25 0.375 0.25 0.0625];   %row vector, sum(w)=1
w2 = w.'*w;                            %w2, neighborhood weights, sum(w2)=1
% Axx = event_dx.^2;        %System Av=b, A=[Axx,Axy;Axy,Ayy],
% Axy = event_dx.*event_dy; %v=[Vx,Vy].', b=[Bx,By].'
% Ayy = event_dy.^2;
% Bx = event_dx.*event_dt;
% By = event_dy.*event_dt;

% keyboard

% Axx = conv2(event_dx.^2,w2,'same');        %System Av=b, A=[Axx,Axy;Axy,Ayy],
% Axy = conv2(event_dx.*event_dy,w2,'same'); %v=[Vx,Vy].', b=[Bx,By].'
% Ayy = conv2(event_dy.^2,w2,'same');
% Bx = conv2(event_dx.*event_dt,w2,'same');
% By = conv2(event_dy.*event_dt,w2,'same');
% 
% % keyboard
% detA = Axx.*Ayy-Axy.^2;                    %det(A)
% % 
% % %undet = logical((detA < THRESHOLD));                 %det(A)=0 means infinite solutions
% % 
% Ox = -(Ayy.*Bx-Axy.*By)./(eps+detA);        %Solve system
% Oy = (Axx.*By-Axy.*Bx)./(eps+detA);         % double - => + because y grows to botton instead to top
% Ox(abs(event_dt)<2)=0; Oy(abs(event_dt)<2==0)=0;

A = conv2(event_dx.^2,       w2, 'same');
B = conv2(event_dx.*event_dy,w2, 'same');
C = conv2(event_dy.^2,       w2, 'same');
D = -1./(eps+A.*C-B.^2);
E = conv2(event_dx.*event_dt,w2, 'same');
F = conv2(event_dy.*event_dt,w2, 'same');
% Compute the flow variables.
Ox = D.*(+A.*E -B.*F);
Oy = D.*(-B.*E +C.*F);
Ox=Ox.*(abs(event_dt)>1); Oy=Oy.*(abs(event_dt)>1);
