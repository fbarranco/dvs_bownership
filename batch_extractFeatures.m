% filenames={'car1', 'car2', 'car3', 'car4', 'car5', 'car6', 'car7', 'car8', 'bottle','carmoving1',...
%     'carmoving3','carmoving4'}; 
% filepath = './iccv_dataset';

% filenames = {'bottletext', 'megaphone', 'megaphonetext', 'recyclebin', 'recyclebintext', 'seat', 'seattext', 'suitcase', ...
%     'suitcasetext'};
% filepath = '/home/fran/Desktop/iccv_dataset/indoor/';

filenames={'car1', 'car2', 'car3', 'car6', 'car7', 'car8', ...
    'carmoving3','carmoving4'}; 
filepath = '/home/fran/Desktop/iccv_dataset/outdoor2/';


 sliceTime = 20000;
for i=8:numel(filenames)
    filenames{i}
    pathname = fullfile(filepath, filenames{i});
    
    % First, read the frames in selected folder
    selected = dir(fullfile(pathname, 'selected', '*.jpg'));
        
    for k = 1:numel(selected)
%        numFrame = sscanf(selected(k).name, [strcat(filenames{i}, 'Z') '_%04d']);
       numFrame = sscanf(selected(k).name, [filenames{i} '_%04d']);
       finalTime = numFrame * sliceTime;
       extractFeatures3(pathname, filenames{i}, finalTime);
    end
end



% filenames={'book', 'coffee', 'bottle', 'nips', 'panda', 'complex1', 'complex2', 'complex3', 'complex4', 'complex5', 'complex6'};

% filenames={'complex1Type0', 'complex2Type0', 'complex3Type0', 'complex4Type0', 'complex5Type0', 'complex6Type0', 'complex7Type0'...
%     'complex1Type1', 'complex2Type1', 'complex3Type1', 'complex4Type1', 'complex5Type1', 'complex6Type1', 'complex7Type1',...
%     'complex1Type2', 'complex2Type2', 'complex3Type2', 'complex4Type2', 'complex5Type2', 'complex6Type2', 'complex7Type2', 'complex9Type2',...
%     'bowlRotation', 'bowlTranslation', 'bowlZoom', 'boxRotation', 'boxTranslation', 'boxZoom',...
%     'circleRotation', 'circleTranslation', 'circleZoom', 'cupUdRotation', 'cupUdTranslation', 'cupUdZoom',...
%     'glueRotation', 'glueTranslation', 'glueZoom', 'jarRotation', 'jarTranslation', 'jarZoom',...
%     'nasaMugRotation', 'nasaMugTranslation', 'nasaMugZoom', 'staplerRotation', 'staplerTranslation', 'staplerZoom',...
%     'trashBinRotation', 'trashBinTranslation', 'trashBinZoom'};


% filenames={'complex1Type0', 'complex2Type0', 'complex3Type0', 'complex4Type0', 'complex5Type0', 'complex6Type0', 'complex7Type0'...
%     'complex1Type1', 'complex2Type1', 'complex3Type1', 'complex4Type1', 'complex5Type1', 'complex6Type1', 'complex7Type1',...
%     'complex1Type2', 'complex2Type2', 'complex3Type2', 'complex4Type2', 'complex5Type2', 'complex6Type2', 'complex7Type2', 'complex9Type2',...
%     'bowl', 'box', 'circle', 'cupUd', 'glue', 'jar', 'nasa', 'stapler', 'trashBin'};

% filenames={'bowl', 'box', 'circle', 'cupUd', 'glue', 'jar', 'nasaMug', 'stapler', 'trashBin',...
%     'complex1Type0','complex1Type1','complex1Type2','complex2Type0','complex2Type1','complex2Type2',...
%     'complex3Type0','complex3Type1','complex3Type2','complex4Type0','complex4Type1','complex4Type2',...
%     'complex5Type0','complex5Type1','complex5Type2','complex6Type0','complex6Type1','complex6Type2',...
%     'complex7Type0','complex7Type1','complex7Type2','complex9Type2','complexChallenge'};
% 
% filenames = {'nasaMug'};
% %filenames = {'complex2','complex3','complex4'}; 
%  
% % filenames={'circle', 'bowl', 'box', 'cupUd', 'glue', 'jar', 'pen', 'nasaMug', 'stapler', 'trashBin'};
%  
%  
% %filepath ='/nfshomes/barranco/Matlab/border_ownership/background/nobackground';
% % filepath = './background/cluttered background';
% filepath = './background/no background';
% % filepath = './background/newObjectsnewBg';
% % filepath = './background/oneObjectRTZ/rotation';
% % filepath = './background/oneObjectRTZ/translation';
% % filepath = './background/oneObjectRTZ/zoom';
% % filepath = './background/onetothreeObjectsRTZ';
% % filepath = './background/sequenceTemporalConsistency';
% 
% 
% % sliceTime = 5000;
% % for i=1:numel(filenames)
% %    pathname = fullfile(filepath, filenames{i});
% %    
% %    % First, read the frames in selected folder
% %    selected = dir(fullfile(pathname, 'selected', '*.jpg'));
% %        
% %    for k = 1:numel(selected)
% %       numFrame = sscanf(selected(k).name, [filenames{i} '_%04d']);
% %       finalTime = numFrame * sliceTime;
% %       %%%%%%%extractFeatures(pathname, filenames{i}, finalTime);
% %       %%%%% CHECK OUT IF YOU NEED ALL THE FEATURES OR ONLY THE TEXTURE
% %       extractFeatures3(pathname, filenames{i}, finalTime);
% %    end
% % end
% 
%  sliceTime = 20000;
% for i=1:numel(filenames)
%     filenames{i}
%     pathname = fullfile(filepath, filenames{i});
%     
%     % First, read the frames in selected folder
%     selected = dir(fullfile(pathname, 'selected', '*.jpg'));
%         
%     for k = 1:numel(selected)
% %        numFrame = sscanf(selected(k).name, [strcat(filenames{i}, 'Z') '_%04d']);
%        numFrame = sscanf(selected(k).name, [filenames{i} '_%04d']);
%        finalTime = numFrame * sliceTime;
%        %%%%%%%extractFeatures(pathname, filenames{i}, finalTime);
%        %%%%% CHECK OUT IF YOU NEED ALL THE FEATURES OR ONLY THE TEXTURE
% %        extractFeatures3(pathname, filenames{i}, finalTime);
% %        extractFeatures3(pathname, strcat(filenames{i},'Z'), finalTime);
%        extractFeatures3(pathname, filenames{i}, finalTime);
%     end
% end



%filenames = {'circle', 'bowl', 'box', 'cupUd', 'glue', 'jar', ...
%    'nasaMug', 'pen', 'stapler', 'trashBin'};
%filepath = 'sequences';
%
%sliceTime = 20000;
%
%for i=1:numel(filenames)      
%    pathname = fullfile(filepath, filenames{i});
%    
%    % First, read the frames in selected folder
%    selected = dir(fullfile(pathname, 'selected', '*.jpg'));
%        
%    for k = 1:numel(selected)
%       numFrame = sscanf(selected(k).name, [filenames{i} '_%04d']);
%       finalTime = numFrame * sliceTime;
%       extractFeatures(pathname, filenames{i}, finalTime);
%    end
%end


%filenames = {'circle', 'bowl'};
%filepath = '/nfshomes/barranco/Matlab/border_ownership/DiffMotion/';
%
%sliceTime = 20000;
%
%for i=1:numel(filenames)      
%    pathname = fullfile(filepath, filenames{i});
%    
%    % First, read the frames in selected folder
%    selected = dir(fullfile(pathname, 'selected', '*.jpg'));
%        
%    for k = 1:numel(selected)
%       numFrame = sscanf(selected(k).name, [filenames{i} '_%04d']);
%       finalTime = numFrame * sliceTime;
%       extractFeatures(pathname, filenames{i}, finalTime);
%    end
%end


%filenames = {'complex'};
%filepath = '/nfshomes/barranco/Matlab/border_ownership/sequenceTemporalConsistency1';
%
%sliceTime = 5000;
%
%for i=1:numel(filenames)
%    pathname = fullfile(filepath, filenames{i});
%    
%    % First, read the frames in selected folder
%    selected = dir(fullfile(pathname, 'selected', '*.jpg'));
%        
%    for k = 1:numel(selected)
%       numFrame = sscanf(selected(k).name, [filenames{i} '_%04d']);
%       finalTime = numFrame * sliceTime;
%       extractFeatures(pathname, filenames{i}, finalTime);
%    end
%end
