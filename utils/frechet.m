function dist = frechet(traj1, traj2)
dist = 0;
for i=1:length(traj1)
    min_i = norm(traj1(i, :) - traj2(1, :));
    for j = 2:length(traj2)
        dist_ij = norm(traj1(i, :) - traj2(j, :));
        if dist_ij < min_i
            min_i = dist_ij;
        end
    end
    if min_i > dist
        dist = min_i;
    end
end
end