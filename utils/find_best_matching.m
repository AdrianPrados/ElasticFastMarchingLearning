function [new_traj, d2] = find_best_matching(traj1, traj2)
    N = length(traj2);
    new_traj = zeros(N,2);
    distances = pdist2(traj1, traj2);
    d2 = distances;
    for i = 1:N
        [~, index_of_minimum_value] = min(distances(:, i));
        disp(index_of_minimum_value);
        new_traj(i, :) = traj1(index_of_minimum_value, :);
        distances(index_of_minimum_value, :) = Inf;
    end
end