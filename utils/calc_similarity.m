function [frech, hausdorff, sse, mse, dtw_dist, angular, jerk] = calc_similarity(traj1, traj2)
traj1_ds = find_best_matching(traj1, traj2);
frech = frechet(traj1, traj2);
hausdorff = HausdorffDist(traj1, traj2);
sse = norm(sum((traj1_ds - traj2).^2));
mse = norm(mean((traj1_ds - traj2).^2));
dtw_dist = dtw(traj1', traj2');
angular = angular_similarity(traj1_ds, traj2);
jerk = calc_jerk(traj2);
end