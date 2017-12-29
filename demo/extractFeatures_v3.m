function [Ox, Oy] = extractFeatures_v3(posx, posy, pol, time)

    sizey = 128; sizex = 128;
    events.x = posx; events.y = posy; events.pol = pol; events.time = time-time(1);
    
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     [Ox, Oy] = visualFlow_v3(events);
        
end