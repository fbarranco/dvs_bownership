function dvs2matlab

try

UDP_TIMEOUT=1; % milliseconds
BUFFER_SIZE  =8192*6;
PACKET_LENGTH=8192;
DVSH=128; DVSW=128; %DVS
% DVSH=180; DVSW=240; %Davis

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

dr=zeros(BUFFER_SIZE,1,'int8');

% fr=zeros(DVSH,DVSW);

fh=figure;
global pauseflag
pauseflag=0;
set(fh,'KeyPressFcn','global pauseflag; pauseflag=1-pauseflag');

try

    while 1==1,
        whileend=0;
	    dr2=[];
        temp=0;
        while whileend==0,
            try
                socket.receive(packet);
                dr(1:BUFFER_SIZE)=packet.getData; dr3=dr(1:packet.getLength);
                dr2=[dr2 ; (swapbytes(typecast(dr3,'uint32')))]; 
                temp=temp+1;
                if temp>500,
                    whileend=1;
                end
            catch recMsg
                whileend=1;
                %disp(temp);
            end
        end

        adr=double(dr2(1:2:end));
        tms=double(dr2(2:2:end));

        % For DVS
        if size(adr,1)>20
            [x,y,pol]=extractRetinaEventsFromAddr(adr);
            onofflist=x*DVSW+y+1;
            %%%%%%%
        
%         % For Davis
%         if size(adr,1)>20
%             last_valid = min(size(adr,1), size(tms,1));
%             adr = adr(1:last_valid);
%             tms = tms(1:last_valid);
%             [x,y,pol,tms]=extractEventsDavis(adr, tms);
%             onofflist = sub2ind([180 240], y+1, x+1);
%             pol(pol==0)=-1;
%             %%%%%%%%

            fr=zeros(DVSH,DVSW);
            fr(onofflist)=pol;

            if(pauseflag==0)&&(~isempty(tms)),

                imagesc(fr,[-1 1]);
                colormap gray
                axis xy;
                set(gca,'xtick',[],'ytick',[]);
                axis square
                box off
                axis off

            end
            drawnow;
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