clear all;clc;
task = 'REACHING';
demo_num = 1;
data = cell(10, 1);
matriz = [1 0 0 0.07;0 0.707 0.707 0.13;0 -0.707 0.707 0.92;0 0 0 1];
ADAM=[];
for i=1:10
    load(['RAIL/' task '/' num2str(i) '.mat'], 'dataset');
    data{i} = dataset(demo_num).pos'* 0.4902;
    data{i}(4,:) = 1;

end
data(3) = []; % Elimnate the third user demonstrations

for j=1:1:length(data)
    CONV = data{j};
    for k=1:1:length(CONV)
        puntoCorrected = matriz*CONV(:,k);
        ADAM{j,k} = puntoCorrected;
    end
end
box = [];
fBox = [];
for h=1:1:length(data)
    for l=1:1:1000
        box= ADAM{h,l}(1:3);
        fBox = [fBox box];
    end
     LearnedPath{h}= fBox';
%      LearnedPath{h} = LearnedPath{h}(1:10:end,:);
     fBox = [];
end
% LearnedPath = LearnedPath(:,1:10:end);
LearnedPath = LearnedPath';
disp("DONE")
for l=1:1:length(LearnedPath)
    file_name = ['NLearnedPath' num2str(l)];
    LearnedPathSave = LearnedPath{l,:};
    save(file_name,'LearnedPathSave');
end
