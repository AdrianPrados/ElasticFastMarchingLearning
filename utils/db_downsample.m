function new_traj = db_downsample(old_traj, num_points)
[n_pts, n_dims] = size(old_traj);
total_dist = 0;
new_traj = zeros(num_points, n_dims);
for i=1:n_pts-1
    total_dist = total_dist + norm(old_traj(i+1, :) - old_traj(i, :));
end
interval_len = total_dist / (num_points - 1);
cur_len = 0.0;
new_traj(1, :) = old_traj(1, :);
cur_ind = 2;
for i=1:n_pts-1
    if cur_len >= interval_len
        new_traj(cur_ind, :) = old_traj(i, :);
        cur_ind = cur_ind + 1;
        cur_len = cur_len - interval_len;
    end
    cur_len = cur_len + norm(old_traj(i+1, :) - old_traj(i, :));
end
new_traj(cur_ind, :) = old_traj(n_pts, :);
end