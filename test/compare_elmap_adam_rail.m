%% COMPARE ELMAP W/ RAIL
%setup path
addpath('elmap');
addpath('utils');

%setup constants
N_repro = 25;
LAMBDA = 10.0;
MU = 10.0;

%run data
task = 'Pressing';
num_demos = 5;

%for recording results
frechs = zeros(num_demos, 9);
angs = zeros(num_demos, 9);
jerks = zeros(num_demos, 9);
maps = cell(num_demos, 9);

%run through demos
for i=1:num_demos
    %load data & setup for elmap optimization
    data = load_adam_data(task, i);
    init_ds = db_downsample(data{1}, N_repro);
    [~, n_dims] = size(init_ds);
    init_pts = cell(length(data), 1);
    end_pts = zeros(length(data), n_dims);
    for j=1:length(data)
        init_pts{j} = data{j}(1, :);
        end_pts(j, :) = data{j}(end, :);
    end
    mean_end_pt = mean(end_pts);
    full_data = vertcat(data{:});
    weights = ones(length(full_data), 1);
    
    %run elmap from each initial point & record results
    for j=1:length(data)
        nodes = OriginalElasticMap(full_data, weights, LAMBDA, MU, init_ds, ...
            [1, N_repro], vertcat(init_pts{j}, mean_end_pt));
        jerk_val = calc_jerk(nodes);
        max_frech = 0.0;
        max_ang = 0.0;
        for k=1:length(data)
            max_frech = max(max_frech, frechet(nodes, data{k}));
            max_ang = max(max_ang, angular_similarity(nodes, db_downsample(data{k}, N_repro)));
        end
        frechs(i, j) = max_frech;
        angs(i, j) = max_ang;
        jerks(i, j) = jerk_val;
        maps{i, j} = nodes;
    end
end
%save results in struct
results.frechet = frechs;
results.angular = angs;
results.jerk = jerks;
results.repros = maps;
save(['results\' task '_adam_results.mat'], 'results')
