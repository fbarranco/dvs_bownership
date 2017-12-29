filenames={'complex1Type2', 'complex2Type2', 'complex3Type2', 'complex4Type2', 'complex5Type2', 'complex6Type2', 'complex7Type2', 'complex9Type2'};

% filenames={'complex1Type0', 'complex2Type0', 'complex3Type0', 'complex4Type0', 'complex5Type0', 'complex6Type0', 'complex7Type0'};
%     'complex1Type1', 'complex2Type1', 'complex3Type1', 'complex4Type1', 'complex5Type1', 'complex6Type1', 'complex7Type1',...
%     'complex1Type2', 'complex2Type2', 'complex3Type2', 'complex4Type2', 'complex5Type2', 'complex6Type2', 'complex7Type2', 'complex9Type2',...
%     'bowlRotation', 'bowlTranslation', 'bowlZoom', 'boxRotation', 'boxTranslation', 'boxZoom',...
%     'circleRotation', 'circleTranslation', 'circleZoom', 'cupUdRotation', 'cupUdTranslation', 'cupUdZoom',...
%     'glueRotation', 'glueTranslation', 'glueZoom', 'jarRotation', 'jarTranslation', 'jarZoom',...
%     'nasaMugRotation', 'nasaMugTranslation', 'nasaMugZoom', 'staplerRotation', 'staplerTranslation', 'staplerZoom',...
%     'trashBinRotation', 'trashBinTranslation', 'trashBinZoom'};


%filenames = {'complex2','complex3','complex4'}; 
 
 %filenames={'circle', 'bowl', 'box', 'cupUd', 'glue', 'jar', 'nasaMug', 'stapler', 'trashBin'};
 %filenames={'complex1Type1', 'complex2Type1', 'complex3Type1', 'complex4Type1', 'complex5Type1', 'complex6Type1', 'complex7Type1'};
%     'complex1Type1', 'complex2Type1', 'complex3Type1', 'complex4Type1', 'complex5Type1', 'complex6Type1', 'complex7Type1',...
%     'complex1Type2', 'complex2Type2', 'complex3Type2', 'complex4Type2', 'complex5Type2', 'complex6Type2', 'complex7Type2',...
%     'bowlRotation', 'bowlTranslation', 'bowlZoom', 'boxRotation', 'boxTranslation', 'boxZoom',...
%     'circleRotation', 'circleTranslation', 'circleZoom', 'cupUdRotation', 'cupUdTranslation', 'cupUdZoom',...
%     'glueRotation', 'glueTranslation', 'glueZoom', 'jarRotation', 'jarTranslation', 'jarZoom',...
%     'nasaMugRotation', 'nasaMugTranslation', 'nasaMugZoom', 'staplerRotation', 'staplerTranslation', 'staplerZoom',...
%     'trashBinRotation', 'trashBinTranslation', 'trashBinZoom'};

filepath = '/nfshomes/barranco/Matlab/border_ownership/background/nobackground';
%filepath = './background/cluttered';

sliceTime = 20000;
for i=1:numel(filenames) 
    filenames{i}
    pathname = fullfile(filepath, filenames{i});
    
    % First, read the frames in selected folder
    selected = dir(fullfile(pathname, 'selected', '*.jpg'));
        
    for k = 1:numel(selected)
       numFrame = sscanf(selected(k).name, [filenames{i} '_%04d']);
       finalTime = numFrame * sliceTime;
       %%%%%%%extractFeatures(pathname, filenames{i}, finalTime);
       %%%%% CHECK OUT IF YOU NEED ALL THE FEATURES OR ONLY THE TEXTURE
       extractFeatures3(pathname, filenames{i}, finalTime);
    end
end



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
