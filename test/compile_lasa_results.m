%% compile lasa results
clear all;
close all;
% use only shapes with results for single and multiple demos
lasa_names = {'Angle','BendedLine','CShape','DoubleBendedLine', ...
    'GShape','heee','JShape','JShape_2','Khamesh','Leaf_1','Leaf_2', ...
    'LShape','RShape','Sharpc', 'Sine','Snake','Spoon','Trapezoid', ...
    'WShape','Zshape'};


num_demos = 7;
metrics = {'Name', 'Frechet_Elmap', 'Frechet_FML', 'Frechet_ElmapFML', ...
    'Hausdorff_Elmap', 'Hausdorff_FML', 'Hausdorff_ElmapFML', ...
    'SSE_Elmap', 'SSE_FML', 'SSE_ElmapFML', 'MSE_Elmap', 'MSE_FML', 'MSE_ElmapFML', ...
    'DTW_Elmap', 'DTW_FML', 'DTW_ElmapFML', 'Angular_Elmap', 'Angular_FML', ...
    'Angular_ElmapFML', 'Jerk_Elmap', 'Jerk_FML', 'Jerk_ElmapFML'};

metrics_types = {'string', 'double', 'double', 'double', 'double', ...
    'double', 'double', 'double', 'double', 'double', 'double', 'double', ...
    'double', 'double', 'double', 'double', 'double', 'double', 'double', ...
    'double', 'double', 'double'};

full_tab = table('Size',[num_demos*length(lasa_names), length(metrics)], 'VariableTypes', metrics_types, 'VariableNames', metrics);
avg_tab = table('Size',[length(lasa_names), length(metrics)], 'VariableTypes', metrics_types, 'VariableNames', metrics);
sum_tab = table('Size',[length(lasa_names), length(metrics)], 'VariableTypes', metrics_types, 'VariableNames', metrics);

for s = 1:length(lasa_names)
    shape_name = lasa_names{s};
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
    
    for i=1:num_demos
        full_tab((s-1)*num_demos+i, 1) = {[shape_name num2str(i)]};
        full_tab((s-1)*num_demos+i, 2) = {results.frechet(i, 1)};
        full_tab((s-1)*num_demos+i, 3) = {results.frechet(i, 2)};
        full_tab((s-1)*num_demos+i, 4) = {results.frechet(i, 3)};
        full_tab((s-1)*num_demos+i, 5) = {results.hausdorff(i, 1)};
        full_tab((s-1)*num_demos+i, 6) = {results.hausdorff(i, 2)};
        full_tab((s-1)*num_demos+i, 7) = {results.hausdorff(i, 3)};
        full_tab((s-1)*num_demos+i, 8) = {results.sse(i, 1)};
        full_tab((s-1)*num_demos+i, 9) = {results.sse(i, 2)};
        full_tab((s-1)*num_demos+i, 10) = {results.sse(i, 3)};
        full_tab((s-1)*num_demos+i, 11) = {results.mse(i, 1)};
        full_tab((s-1)*num_demos+i, 12) = {results.mse(i, 2)};
        full_tab((s-1)*num_demos+i, 13) = {results.mse(i, 3)};
        full_tab((s-1)*num_demos+i, 14) = {results.dtw(i, 1)};
        full_tab((s-1)*num_demos+i, 15) = {results.dtw(i, 2)};
        full_tab((s-1)*num_demos+i, 16) = {results.dtw(i, 3)};
        full_tab((s-1)*num_demos+i, 17) = {results.angular(i, 1)};
        full_tab((s-1)*num_demos+i, 18) = {results.angular(i, 2)};
        full_tab((s-1)*num_demos+i, 19) = {results.angular(i, 3)};
        full_tab((s-1)*num_demos+i, 20) = {results.jerk(i, 1)};
        full_tab((s-1)*num_demos+i, 21) = {results.jerk(i, 2)};
        full_tab((s-1)*num_demos+i, 22) = {results.jerk(i, 3)};
    end
    avg_tab(s, 1) = {shape_name};
    avg_tab(s, 2) = {mean(results.frechet(:, 1))};
    avg_tab(s, 3) = {mean(results.frechet(:, 2))};
    avg_tab(s, 4) = {mean(results.frechet(:, 3))};
    avg_tab(s, 5) = {mean(results.hausdorff(:, 1))};
    avg_tab(s, 6) = {mean(results.hausdorff(:, 2))};
    avg_tab(s, 7) = {mean(results.hausdorff(:, 3))};
    avg_tab(s, 8) = {mean(results.sse(:, 1))};
    avg_tab(s, 9) = {mean(results.sse(:, 2))};
    avg_tab(s, 10) = {mean(results.sse(:, 3))};
    avg_tab(s, 11) = {mean(results.mse(:, 1))};
    avg_tab(s, 12) = {mean(results.mse(:, 2))};
    avg_tab(s, 13) = {mean(results.mse(:, 3))};
    avg_tab(s, 14) = {mean(results.dtw(:, 1))};
    avg_tab(s, 15) = {mean(results.dtw(:, 2))};
    avg_tab(s, 16) = {mean(results.dtw(:, 3))};
    avg_tab(s, 17) = {mean(results.angular(:, 1))};
    avg_tab(s, 18) = {mean(results.angular(:, 2))};
    avg_tab(s, 19) = {mean(results.angular(:, 3))};
    avg_tab(s, 20) = {mean(results.jerk(:, 1))};
    avg_tab(s, 21) = {mean(results.jerk(:, 2))};
    avg_tab(s, 22) = {mean(results.jerk(:, 3))};
    
    sum_tab(s, 1) = {shape_name};
    sum_tab(s, 2) = {sum(results.frechet(:, 1))};
    sum_tab(s, 3) = {sum(results.frechet(:, 2))};
    sum_tab(s, 4) = {sum(results.frechet(:, 3))};
    sum_tab(s, 5) = {sum(results.hausdorff(:, 1))};
    sum_tab(s, 6) = {sum(results.hausdorff(:, 2))};
    sum_tab(s, 7) = {sum(results.hausdorff(:, 3))};
    sum_tab(s, 8) = {sum(results.sse(:, 1))};
    sum_tab(s, 9) = {sum(results.sse(:, 2))};
    sum_tab(s, 10) = {sum(results.sse(:, 3))};
    sum_tab(s, 11) = {sum(results.mse(:, 1))};
    sum_tab(s, 12) = {sum(results.mse(:, 2))};
    sum_tab(s, 13) = {sum(results.mse(:, 3))};
    sum_tab(s, 14) = {sum(results.dtw(:, 1))};
    sum_tab(s, 15) = {sum(results.dtw(:, 2))};
    sum_tab(s, 16) = {sum(results.dtw(:, 3))};
    sum_tab(s, 17) = {sum(results.angular(:, 1))};
    sum_tab(s, 18) = {sum(results.angular(:, 2))};
    sum_tab(s, 19) = {sum(results.angular(:, 3))};
    sum_tab(s, 20) = {sum(results.jerk(:, 1))};
    sum_tab(s, 21) = {sum(results.jerk(:, 2))};
    sum_tab(s, 22) = {sum(results.jerk(:, 3))};
    
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
end