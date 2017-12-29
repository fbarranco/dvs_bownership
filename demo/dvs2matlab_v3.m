function dvs2matlab_v3

addpath(genpath('../toolbox'));

try

UDP_TIMEOUT=1; % milliseconds
BUFFER_SIZE  =8192*8;
PACKET_LENGTH=8192;
% DVSH=128; DVSW=128;
DVSH=180; DVSW=240; %Davis

[Y,X] = meshgrid(1:DVSW, 1:DVSH);

import java.io.*
import java.net.DatagramSocket
import java.net.DatagramPacket
import java.net.InetAddress

socket = DatagramSocket(8991);
onclh = onCleanup(@()mycleanup(socket));


socket.setSoTimeout(UDP_TIMEOUT);
socket.setReuseAddress(1);
socket.setReceiveBufferSize(BUFFER_SIZE);
packet = DatagramPacket(zeros(BUFFER_SIZE,1,'int8'),PACKET_LENGTH);
cnt_is_even = 0;

dr=zeros(BUFFER_SIZE,1,'int8');

fr=zeros(DVSH,DVSW);

fh=figure;
global pauseflag
pauseflag=0;
set(fh,'KeyPressFcn','global pauseflag; pauseflag=1-pauseflag');

try

    while 1,
        whileend=0;
	    adr=[];
        tms=[];
        temp=0;
        
        while whileend==0,
            try
                socket.receive(packet);
                dr(1:BUFFER_SIZE)=packet.getData; dr3=dr(1:packet.getLength);                              
                
                dr2 = (swapbytes(typecast(dr3,'uint32')));
                temp=temp+1;                         
                
                newtms=double(dr2(3:2:end));
                newadr=double(dr2(2:2:end));
                if numel(newadr) > numel(newtms)
                    newadr(end)=[];
                end
                                                
%                 if max(newtms) - min(newtms) > 2.5e05
%                     newadr(newtms < (max(newtms)-min(newtms)/2)) = [];
%                     newtms(newtms < (max(newtms)-min(newtms)/2)) = [];
%                 end
                                                
                adr = [adr; newadr];
                tms = [tms; newtms];
                
                if (tms(end)- tms(1))/1000 > 20
                   whileend=1;               
                end             
            catch recMsg
%                 whileend=1;
%                 disp(temp);
            end
        end

        if isempty(adr)
            continue;
        end
                                
        
%         [x,y,pol]=extractRetinaEventsFromAddr(adr);
% %         onofflist=x*DVSW+y+1;
% %         fr=zeros(DVSW,DVSH);
% %         fr(onofflist)=pol;


        % For Davis    
        if size(adr,1)>20
            last_valid = min(size(adr,1), size(tms,1));
            adr = adr(1:last_valid);
            tms = tms(1:last_valid);
            [x,y,pol,tms]=extractEventsDavis(adr, tms);
%             onofflist = sub2ind([180 240], y+1, x+1);
%             pol(pol==0)=-1;
%             fr=zeros(DVSH,DVSW);
%             fr(onofflist)=pol;
            %%%

%             [Ox, Oy] = extractFeatures_v3(x(1:2:end)+1, y(1:2:end)+1, pol(1:2:end), tms(1:2:end));
            [Ox, Oy] = extractFeatures_v3(x+1, y+1, pol, tms);
            Ox(abs(Ox)>2)=0; Oy(abs(Oy)>2)=0;


            if cnt_is_even==1
%                 imagesc(fr, [-1 1]), colormap  gray, axis xy, hold on
%                imagesc(Ox), colormap  gray, axis xy, hold on
                 X(flipud(Ox)==0 & flipud(Oy)==0)=NaN; Y(flipud(Ox)==0 & flipud(Oy)==0)=NaN;
                 quiver((-Ox), -(Oy), 6), title('Normal flow'), axis off, axis xy
                cnt_is_even =0;
            else
                cnt_is_even = 1;
            end

            drawnow
        end
    end
	       
catch pollingError
    pollingError.message
    pollingError.stack
end

socket.close;

%disp('finished');

catch functionError
    functionError.message
    functionError.stack
end

end

function mycleanup(socket)
    socket.close
    %disp('socket closed');
end

function myKeyPressFcn(src,event)
    set(fh,'UserData',1-get(fh,'UserData'));
end