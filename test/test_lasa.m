
addpath('elmap');
addpath('utils');
addpath('cvx-a64');
addpath('LASA_dataset');

lasa_names = {'Angle','BendedLine','CShape','DoubleBendedLine','GShape', ...
                'heee','JShape','JShape_2','Khamesh','Leaf_1', ...
                'Leaf_2','Line','LShape','NShape','PShape', ...
                'RShape','Saeghe','Sharpc','Sine','Snake', ...
                'Spoon','Sshape','Trapezoid','Worm','WShape', ...
                'Zshape'};
            
for s = 1:length(lasa_names)
    load(['LASA_dataset/DataSet/' lasa_names{s} '.mat']);
    traj = demos{1}.pos';
    N = length(traj);
    w = ones(N, 1);
    init = traj(1:10:N, :); %random initial map, does not matter that much

    [l, m, iters] = estimate_params(traj, w, init);
    nodes = OriginalElasticMap(traj, w, l, m, init, [], [],iters);
    
    figure;
    hold on;

    plot(traj(:, 1), traj(:, 2), 'k', 'linewidth', 5);
    plot(nodes(:, 1), nodes(:, 2), 'r', 'linewidth', 3);
end