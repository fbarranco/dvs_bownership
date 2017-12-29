% % function estimateBoundariesForVideo
% % 
% % addpath(genpath('./toolbox'));
% % files = dir(fullfile('./background/video/complex6/', 'complex6TimeStamps_*.mat'));
% % sizex=128; sizey=128;
% % 
% % out = zeros(sizey,sizex,16);
% % 
% % load('./models/modelFinal_DVSFGV2_OTM4_5_TS_C3', 'model');
% % 
% % iter = 1;
% % 
% % for idx = 1:numel(files)
% %     
% %     load(fullfile('./background/video/complex6/', files(idx).name),  'posTimeStamp');    
% %     out(:,:,7) = posTimeStamp./1e4;
% % 
% %     [DVSBO_res, ucm]=detectDVSBOwnership(squeeze(out(:,:,7)), model, 0.7);
% % 
% %     
% %     [tmp] = findstr(files(idx).name, '_');
% %     newname = files(idx).name(1:tmp-1);    
% %     
% %        
% %     DVSBO_res2 = 1-imadjust(DVSBO_res,[.05 .075 .075; .6 .5 .5],[]);
% %     
% %     
% %     tmp = imresize(DVSBO_res2, [512 512]);
% %     
% %     
% %     %imwrite(DVSBO_res2, fullfile('./background/video/complex6/BOFigures/', strcat(newname, sprintf('%04d', iter), '.jpg')));
% %     %imwrite(DVSBO_res2, fullfile('./background/video/complex6/BOFigures/', strcat(newname, sprintf('%04d', iter), '.png')), 'Alpha', 1.4*ones(size(DVSBO_res2,1),size(DVSBO_res2,2)));
% %     imwrite(tmp, fullfile('./background/video/complex6/BOFigures/', strcat(newname, sprintf('%04d', iter), '.png')), 'Alpha', 1.4*ones(size(tmp,1),size(tmp,2)));
% %     imwrite(label2rgb(ucm), fullfile('./background/video/complex6/ucmSeg/', strcat(newname, sprintf('%04d', iter), '.jpg')));
% %     iter = iter+1;
% % end
% % 
% % rmpath(genpath('./toolbox'));



% % function estimateBoundariesForVideo
% % 
% % addpath(genpath('./toolbox'));
% % files = dir(fullfile('./background/video/complex6/', 'complex6TimeStamps_*.mat'));
% % sizex=128; sizey=128;
% % 
% % out = zeros(sizey,sizex,16);
% % 
% % load('./models/modelFinal_DVSFGV2_OTM4_5_TS_C3', 'model');
% % 
% % iter = 151+75+1; %First 25 frames are for cover
% % 
% % for idx = 1:numel(files)
% %     
% %     load(fullfile('./background/video/complex6/', files(idx).name),  'posTimeStamp');    
% %     out(:,:,7) = posTimeStamp./1e4;
% % 
% %     %[DVSBO_res, ucm]=detectDVSBOwnership(squeeze(out(:,:,7)), model, 0.7);
% %     [DVSBO_res, ucm]=detectDVSBOwnership(squeeze(out(:,:,7)), model, 0.7);
% % 
% %     
% %     [tmp] = findstr(files(idx).name, '_');
% %     newname = files(idx).name(1:tmp-1);    
% %     
% %        
% %     kk = DVSBO_res; kk(:,:,2)=DVSBO_res(:,:,3); kk(:,:,3)=DVSBO_res(:,:,2);
% %     
% %     DVSBO_res2 = 1-imadjust(kk,[.075 .075 .075; .6 .5 .5],[]);
% %     
% %     tmp = imresize(DVSBO_res2, [512 512]);
% % 
% %     
% %     %imwrite(DVSBO_res2, fullfile('./background/video/complex6/BOFigures/', strcat(newname, sprintf('%04d', iter), '.jpg')));
% %     %imwrite(DVSBO_res2, fullfile('./background/video/complex6/BOFigures/', strcat(newname, sprintf('%04d', iter), '.png')), 'Alpha', 1.4*ones(size(DVSBO_res2,1),size(DVSBO_res2,2)));
% %     imwrite(tmp, fullfile('./background/video/complex6/BOFigures/', strcat(newname, sprintf('%04d', iter), '.png')), 'Alpha', 1.4*ones(size(tmp,1),size(tmp,2)));
% %     imwrite(label2rgb(ucm), fullfile('./background/video/complex6/ucmSeg/', strcat(newname, sprintf('%04d', iter), '.jpg')));
% %     iter = iter+1;
% %     
% %     if iter == 249
% %         iter = 249+75+1;
% %     end
% %     if iter == 391
% %         iter = 391+75+1;
% %     end
% % 
% %     if iter == 539
% %         iter = 539+75+1;
% %     end
% %     
% %     if iter == 757
% %         iter = 757+75+1;
% %     end
% %     
% %     if iter == 923
% %         iter = 923+75+1;
% %     end
% % 
% %     if iter == 1121
% %         iter = 1121+75+1;
% %     end
% %     
% % 
% % %     if iter == 264+151+75*3
% % %         iter = 264+151+75*4+1;
% % %     end
% % %     if iter == 433+151+75*4
% % %         iter = 433+151+75*5+1;
% % %     end
% % %     if iter == 548+151+75*5
% % %         iter = 548+151+75*6+1;
% % %     end
% % %     if iter == 695+151+75*6
% % %         iter = 695+151+75*7+1;
% % %     end
% %     
% % end
% % 
% % rmpath(genpath('./toolbox'));





% dims 1 to 3:
% chnsOrient=cat(3, ftrsOrient.filteredOrientationFrame, ftrsOrient.orientationFrame,...
%      ftrsOrient.positionVectorOfTimeStamps); % 3 dims
% 
% dims 4 to 6:
% chnsMotion=cat(3, ftrsTGrad.Ox,ftrsTGrad.Oy, ftrsTGrad.posLastEventPosition); % 3 dims
% 
% dims 7:
% chnsTimeStamp=cat(3, ftrsTS.posTimeStamp./1e4); end % 1 dims
% 
% dims 8 to 16:
% chnsE=cat(3, ftrsOrient.hog,ftrsTGrad.flowTimeStamp./1e4); % 9 dims
% 
% Then send me the features as a final 128x128x16 matrix:
% featFinal=cat(3, chnsOrient, chnsMotion, chnsTimeStamp, chnsE); % 16 dims




function estimateBoundariesForVideo

addpath(genpath('./toolbox'));
files_timestamps = dir(fullfile('./background/video/complex6/', 'complex6TimeStamps_*.mat'));
files_orientation = dir(fullfile('./background/video/complex6/', 'complex6Orientation_*.mat'));
files_tempgradient = dir(fullfile('./background/video/complex6/', 'complex6TempGradient_*.mat'));
files_texture = dir(fullfile('./background/video/complex6/', 'complex6Texture_*.mat'));

sizex=128; sizey=128;

out = zeros(sizey,sizex,10);

load('./models/modelFinal_DVSFGV2_OTM4_5_all_TXMax_BGL3', 'model');

iter = 151+75+1; %First 25 frames are for cover

for idx = 1:numel(files_timestamps)
            
    load(fullfile('./background/video/complex6/', files_orientation(idx).name),  'filteredOrientationFrame', 'orientationFrame', 'positionVectorOfTimeStamps');
    out(:,:,1)=filteredOrientationFrame;
    out(:,:,2)=orientationFrame;
    out(:,:,3)=positionVectorOfTimeStamps;
    
    load(fullfile('./background/video/complex6/', files_tempgradient(idx).name), 'Ox', 'Oy', 'posLastEventPosition');    
    out(:,:,4)=Ox;
    out(:,:,5)=Oy;
    out(:,:,6)=posLastEventPosition;
    
    load(fullfile('./background/video/complex6/', files_timestamps(idx).name), 'posTimeStamp');        
    out(:,:,7) = posTimeStamp./1e4;
    
    load(fullfile('./background/video/complex6/', files_texture(idx).name), 'gaborFilterResponsesMax');        
    out(:,:,8) = gaborFilterResponsesMax(:,:,1);
    out(:,:,9) = gaborFilterResponsesMax(:,:,2);
    out(:,:,10) = gaborFilterResponsesMax(:,:,3);
       
    [DVSBO_res, ucm]=detectDVSBOwnership(out, model, 0.7);
    
    
    [tmp] = findstr(files_timestamps(idx).name, '_');
    newname = files_timestamps(idx).name(1:tmp-1);
    
       
    %kk = DVSBO_res; kk(:,:,2)=DVSBO_res(:,:,3); kk(:,:,3)=DVSBO_res(:,:,2);
    
    DVSBO_res2 = 1-imadjust(DVSBO_res,[.075 .075 .075; .6 .5 .5],[]);
    
    tmp = imresize(DVSBO_res2, [512 512]);

    
    %imwrite(DVSBO_res2, fullfile('./background/video/complex6/BOFigures/', strcat(newname, sprintf('%04d', iter), '.jpg')));
%     imwrite(DVSBO_res2, fullfile('./background/video/complex6/BOFigures/', strcat(newname, sprintf('%04d', iter), '.png')), 'Alpha', 1.4*ones(size(DVSBO_res2,1),size(DVSBO_res2,2)));
    imwrite(tmp, fullfile('./background/video/complex6/BOFigures/', strcat(newname, sprintf('%04d', iter), '.png')), 'Alpha', 1.4*ones(size(tmp,1),size(tmp,2)));
    imwrite(label2rgb(ucm), fullfile('./background/video/complex6/ucmSeg/', strcat(newname, sprintf('%04d', iter), '.jpg')));
    iter = iter+1;
    
    if iter == 249
        iter = 249+75+1;
    end
    if iter == 391
        iter = 391+75+1;
    end

    if iter == 539
        iter = 539+75+1;
    end
    
    if iter == 757
        iter = 757+75+1;
    end
    
    if iter == 923
        iter = 923+75+1;
    end

    if iter == 1121
        iter = 1121+75+1;
    end
    
    if rem(idx, 100)==0
        fprintf('Processing ==> %3.2f \n',idx/numel(files_timestamps)*100);
    end
end

rmpath(genpath('./toolbox'));
