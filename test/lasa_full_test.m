close all;
clear all;


addpath('elmap');
addpath('utils');
addpath('cvx-a64');
addpath('algorithms');
addpath('data');
addpath('examples');
addpath('fm2tools');
addpath('LASA_dataset');

% lasa_names = {'Angle','BendedLine','CShape','DoubleBendedLine','GShape', ...
%                 'heee','JShape','JShape_2','Khamesh','Leaf_1', ...
%                 'Leaf_2','Line','LShape','NShape','PShape', ...
%                 'RShape','Saeghe','Sharpc','Sine','Snake', ...
%                 'Spoon','Sshape','Trapezoid','Worm','WShape', ...
%                 'Zshape'};

lasa_names = {'Angle','BendedLine','CShape','DoubleBendedLine', ...
    'GShape','heee','JShape','JShape_2','Khamesh','Leaf_1','Leaf_2', ...
    'LShape','RShape','Sharpc', 'Sine','Snake','Spoon','Trapezoid', ...
    'WShape','Zshape'};

num_demos = 1;

for s = 1:length(lasa_names)
    close all;
    load(['LASA_dataset\DataSet\' lasa_names{s} '.mat']);
    disp(lasa_names{s});
    
    
    demonstrations = cell(1, num_demos);
    for i=1:num_demos
        demonstrations{i} = demos{i}.pos';
    end
    
    traj = demonstrations{1};
    N = length(traj);
    init = db_downsample(traj, 100);
    
    weights = calc_curv_weights(demonstrations);
    
    [l, m, num_iter] = estimate_params(demonstrations, weights, init);
    disp([l, m, num_iter]);
    inds = [1, length(init)];
    consts = [traj(1, :); traj(end, :)];
    elmap_nodes = OriginalElasticMap(demonstrations, weights, l, m, init, inds, consts, num_iter);
    [nodes_elmapFML, nodesFML] = ElasticMap(demonstrations, weights, init, inds, consts);
    
    frechs = zeros(num_demos, 3);
    hds = zeros(num_demos, 3);
    sses = zeros(num_demos, 3);
    mses = zeros(num_demos, 3);
    dtws = zeros(num_demos, 3);
    angs = zeros(num_demos, 3);
    jerks = zeros(num_demos, 3);
    
    for i=1:num_demos
        [frechs(i, 1), hds(i, 1), sses(i, 1), mses(i, 1), dtws(i, 1), angs(i, 1), jerks(i, 1)] = calc_similarity(demonstrations{i}, elmap_nodes);
        [frechs(i, 2), hds(i, 2), sses(i, 2), mses(i, 2), dtws(i, 2), angs(i, 2), jerks(i, 2)] = calc_similarity(demonstrations{i}, nodesFML);
        [frechs(i, 3), hds(i, 3), sses(i, 3), mses(i, 3), dtws(i, 3), angs(i, 3), jerks(i, 3)] = calc_similarity(demonstrations{i}, nodes_elmapFML);
    end
    disp(mses);
    %save results in struct
    results.frechet = frechs;
    results.hausdorff = hds;
    results.sse = sses;
    results.mse = mses;
    results.dtw = dtws;
    results.angular = angs;
    results.jerk = jerks;
    results.repros = {elmap_nodes, nodesFML, nodes_elmapFML};
    save(['results/LASA/' lasa_names{s} num2str(num_demos) '_results_lmauto.mat'], 'results')
end