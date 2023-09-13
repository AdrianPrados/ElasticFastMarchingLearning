function data = load_adam_data(task, demo_num)
data = cell(5, 1);
for i=1:5
%     load(['RAIL\' task 'Adam\' task num2str(i) '\LearnedPath' num2str(demo_num) '.mat'], 'LearnedPathSave'); 
    load(['RAIL/' task 'Adam/' task num2str(i) '/LearnedPath' num2str(demo_num) '.mat'], 'LearnedPathSave'); %For Ubuntu
    data{i} = LearnedPathSave';
end
% data(3) = [];
end