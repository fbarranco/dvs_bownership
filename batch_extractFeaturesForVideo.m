
filenames={'complex6'};

%filepath ='/nfshomes/barranco/Matlab/border_ownership/background/nobackground';
filepath = './background/video';


sliceTime = 20000;
for ii=1:numel(filenames)
    
    pathname = fullfile(filepath, filenames{ii});
       
    [a,t]=loadaerdat2(fullfile(pathname, strcat(filenames{ii}, '.aedat')));   
        
    % First, read the frames in selected folder
    selected = dir(fullfile(pathname, 'selected', '*.jpg'));
        
    for k = 1:numel(selected)
       numFrame = sscanf(selected(k).name, [filenames{ii} '_%04d']);
       finalTime = numFrame * sliceTime;
       
       extractFeaturesForVideo(pathname, filenames{ii}, finalTime, a, t);
    end
end



