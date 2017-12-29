% filenames = {'circle', 'bowl', 'box', 'cup_ud', 'glue', 'jar', ...
%     'nasa_mug', 'pen', 'pen2', 'stapler', 'trash_bin'};
% filepath = './sequences/';

filenames = {'circle', 'bowl', 'box', 'cupUd', 'glue', 'jar', ...
    'nasaMug', 'stapler', 'trashBin', 'complex_challenge', 'complex9_2', ...
    'complex1_0', 'complex2_0', 'complex3_0', 'complex4_0', 'complex5_0', 'complex6_0', 'complex7_0',...
    'complex1_1', 'complex2_1', 'complex3_1', 'complex4_1', 'complex5_1', 'complex6_1', 'complex7_1',...
    'complex1_2', 'complex2_2', 'complex3_2', 'complex4_2', 'complex5_2', 'complex6_2', 'complex7_2'};
filepath = '/nfshomes/barranco/Matlab/border_ownership/newSequences/';

sliceTime = 20000;
initialTime = 1;
finalTime = 10000000000;

for i=1:numel(filenames)
    createFrames(filepath, filenames{i}, initialTime, finalTime, sliceTime);
end

