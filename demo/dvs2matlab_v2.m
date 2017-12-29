function dvs2matlab_v2

addpath(genpath('../toolbox'));

try

UDP_TIMEOUT=1; % milliseconds
BUFFER_SIZE  = 8192*4;
PACKET_LENGTH = 8192;
DVSH=128;
DVSW=128;

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

fr=zeros(DVSH,DVSW);

fh=figure;
global pauseflag
pauseflag=0;
set(fh,'KeyPressFcn','global pauseflag; pauseflag=1-pauseflag');
cmap = colormap(jet);
cmap(1,:)=[1 1 1];

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
                                
%                 dr2=[dr2 ; (swapbytes(typecast(dr3,'uint32')))]; 
%                 temp=temp+1;
%                 if temp>8000,
%                     whileend=1;
%                 end
                
                dr2 = (swapbytes(typecast(dr3,'uint32')));
                temp=temp+1;         
                
                
                newtms=double(dr2(3:2:end));
                newadr=double(dr2(2:2:end));
                if numel(newadr) > numel(newtms)
                    newadr(end)=[];
                end
                                                
                if max(newtms) - min(newtms) > 2.5e05
                    newadr(newtms < (max(newtms)-min(newtms)/2)) = [];
                    newtms(newtms < (max(newtms)-min(newtms)/2)) = [];
                end
                                                
                adr = [adr; newadr];
                tms = [tms; newtms];
                
                if (tms(end)- tms(1))/1000 > 20
                   whileend=1;
%                    fprintf('%d\n', (tms(end)- tms(1))/1000);                   
                end             
%                 if temp >= 50
%                     keyboard
%                 end
            catch recMsg
%                 whileend=1;
%                 disp(temp);
            end
        end

        if isempty(adr)
            continue;
        end
        
        %adr_tmp=double(dr2(2:2:end));
        %tms_tmp=double(dr2(3:2:end));
        %numEv = min(numel(adr_tmp), numel(tms_tmp)); 
        
        %adr = adr_tmp(1:numEv); 
        %tms = tms_tmp(1:numEv);
        
        %adr(tms<tms(1))=[];
        %tms(tms<tms(1))=[];
        
%         % For Davis        
%         last_valid = min(size(adr,1), size(tms,1));
%         adr = adr(1:last_valid);
%         tms = tms(1:last_valid);
%         [x,y,pol,tms]=extractEventsDavis(adr, tms);
%         tmp_x = x; tmp_y = y; mask = (tmp_x>127) | (tmp_y>127);
%         x(mask)=[]; y(mask)=[]; pol(mask)=[]; tms(mask)=[];        
%         %onofflist = sub2ind([180 240], y+1, x+1);
%         pol(pol==0)=-1;
%         [out, ~ , ~] = extractFeatures_v2(x+1, y+1, pol, tms);
%         load('./models/modelFinal_DVSFGV2_OTM4_5_TS_C3', 'model');
        
                   
        [x,y,pol]=extractRetinaEventsFromAddr(adr);
        [out, ~ , ~] = extractFeatures_v2(x+1, y+1, pol, tms);
        load('../models/modelFinal_DVSFGV2_OTM4_5_TS_C3', 'model');
%         load('./models/modelFinal_DVSFGV2_OTM4_5_TS_R', 'model');
        
        
        
        %onofflist=x*DVSW+y+1;
        %fr=zeros(DVSW,DVSH);
        %fr(onofflist)=pol;
        
       
        [DVSBO_res, ucm]=detectDVSBOwnership(squeeze(out(:,:,7)), model, 0.6);
        
        subplot(2,1,1), subimage(DVSBO_res)
%         subplot(1,2,1), subimage(squeeze(out(:,:,7)))
        axis xy;
        axis square;
        axis off;
        title('Border ownership');
        ha =gca;
        uistack(ha,'bottom');
        haPos = get(ha,'position');
        %ha2=axes('position',[haPos(1:2), .1,.04,]);
        ha2=axes('position',[haPos(1)-0.03, haPos(2), .2, .17]);
        % To place the logo at the bottom left corner of the figure window
        % uncomment the line below and comment the above two lines
        % ha2=axes('position',[0, 0, .1,.04,]);
        % Adding a LOGO to the new axes
        % The logo file(jpeg, png, etc.) must be placed in the working path
        [x, map]=imread('legend.png');
        image(x)

        % Setting the colormap to the colormap of the imported logo image
        colormap (map)

        % Turn the handlevisibility off so that we don't inadvertently plot
        % into the axes again. Also, make the axes invisible
        set(ha2,'handlevisibility','off','visible','off')  

        
        
        subplot(2,1,2), subimage(label2rgb(ucm))
%          subplot(1,2,2), subimage(fr, [-1 1])
        axis xy;
        axis square;
        axis off;
        title('Object Segmentation');
        
        

        
        %imagesc(squeeze(out(:,:,7)));
%         imagesc(DVSBO_res);
        
% axis xy;
%         set(gca,'xtick',[],'ytick',[]);
%         axis square
%         box off
%         axis off            

            
            %         onofflist=x*DVSW+y+1;
        
        %out(:,:,1) = filteredOrientationFrame;
        %out(:,:,2) = orientationFrame;
        %out(:,:,3) = positionVectorOfTimeStamps;
        %out(:,:,4) = Ox;
        %out(:,:,5) = Oy;
        %out(:,:,6) = posLastEventPosition;
        %out(:,:,7) = posTimeStamp./1e4;
        %out(:,:,8:15) = hog;
        %out(:,:,16)= flowTimeStamp./1e4;        
        
        
%         fr=zeros(DVSW,DVSH);
%         fr(onofflist)=pol;
% 
%         if(pauseflag==0)&&(~isempty(tms)),
%             imagesc(fr,[-1 1]);
%             colormap gray
%             axis xy;
%             set(gca,'xtick',[],'ytick',[]);
%             axis square
%             box off
%             axis off            
%         end
        drawnow;	
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