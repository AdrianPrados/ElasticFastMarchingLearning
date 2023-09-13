function ttl = calc_jerk(traj)
ttl = 0.0;
for i = 3:length(traj)-2
    ttl = ttl + norm(traj(i-2, :) + 2*traj(i-1, :) - 2*traj(i+1, :) - traj(i+2, :));
end
end