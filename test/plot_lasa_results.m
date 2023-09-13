close all;
clear all;

%setup paths
addpath('elmap');
addpath('utils');
addpath('cvx-a64');
addpath('algorithms');
addpath('data');
addpath('examples');
addpath('fm2tools');

shape_name = 'Zshape';
num_demos = 7;

load(['LASA_dataset\DataSet\' shape_name '.mat']);
demonstrations = cell(num_demos);
for i=1:num_demos
    demonstrations{i} = demos{i}.pos';
end

load(['results/LASA/' shape_name num2str(num_demos) '_results_lmauto.mat'], 'results');

elmap_result = results.repros{1};
FML_result = results.repros{2};
elmapFML_result = results.repros{3};


traj = demonstrations{1};
N = length(traj);
init = traj(1:10:N, :);

inds = [1, length(init)];
consts = [traj(1, :); traj(end, :)];

figure;
hold on;
for i=1:num_demos
    plot(demonstrations{i}(:, 1), demonstrations{i}(:, 2), 'k', 'linewidth', 3, 'DisplayName', 'Demonstration');
end
plot(elmap_result(:, 1), elmap_result(:, 2), 'r', 'linewidth', 3, 'DisplayName', 'ElMap');
plot(FML_result(:, 1), FML_result(:, 2), 'g', 'linewidth', 3, 'DisplayName', 'FML');
plot(elmapFML_result(:, 1), elmapFML_result(:, 2), 'b', 'linewidth', 3, 'DisplayName', 'ElMapFML');
for i=1:length(inds)
    plot(consts(i, 1), consts(i, 2), 'k.', 'markersize', 15, 'DisplayName', 'Constraints');
end
legend()