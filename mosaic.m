function mosaic(frames)

for ii=1:size(frames,3)
    new_frames(:,:,ii) = flipud(frames(:,:,ii)');
end


[ny, nx, num_frames] = size(new_frames);
n_col = floor(sqrt(num_frames*nx/ny));
n_row = ceil(num_frames / n_col);


ker2 = 1;
for ii  = 1:n_col
   ker2 = conv(ker2,[1/4 1/2 1/4]);
end


II = new_frames(1:n_col:end,1:n_col:end,1);

[ny2,nx2] = size(II);

kk_c = 1;
II_mosaic = [];
for jj = 1:n_row
    
    II_row = [];    
    for ii = 1:n_col
        
        if kk_c <= num_frames            
            I = new_frames(1:n_col:end,1:n_col:end,kk_c);            
        else            
            I = zeros(ny2,nx2);            
        end
                        
        II_row = [II_row I];
        
        if ii ~= n_col,            
            II_row = [II_row zeros(ny2,3)];            
        end               
        kk_c = kk_c + 1;        
    end
    
    nn2 = size(II_row,2);    
    if jj ~= n_row
        II_row = [II_row; zeros(3,nn2)];
    end    
    II_mosaic = [II_mosaic ; II_row];    
end

figure(2);
%image(II_mosaic);
imagesc(II_mosaic);
%colormap(gray(256));
set(gca,'Xtick',[])
set(gca,'Ytick',[])
axis('image');

end
