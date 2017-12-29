filenames = {'glueRotation', 'glueTranslation', 'glueZoom', 'jarRotation', 'jarTranslation', 'jarZoom',...
     'nasaMugRotation', 'nasaMugTranslation', 'nasaMugZoom', 'staplerRotation', 'staplerTranslation', 'staplerZoom',...
     'trashBinRotation', 'trashBinTranslation', 'trashBinZoom'};

filepath = '/nfshomes/barranco/Matlab/border_ownership/background';

sliceTime = 20000;
for i=1:numel(filenames)      
    pathname = fullfile(filepath, filenames{i});
    
    % First, read the frames in selected folder
    selected = dir(fullfile(pathname, 'selected', '*.jpg'));
        
    for k = 1:numel(selected)
       numFrame = sscanf(selected(k).name, [filenames{i} '_%04d']);
       finalTime = numFrame * sliceTime;
       extractFeatures(pathname, filenames{i}, finalTime);
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


%filenames = {'complex'};
%filepath = '/nfshomes/barranco/Matlab/border_ownership/sequenceTemporalConsistency2';
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