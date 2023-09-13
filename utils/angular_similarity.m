function dist = angular_similarity(traj1, traj2)

if length(traj1) ~= length(traj2)
    disp('Size must match! Cannot compute.')
    dist = 0;
else
    sum = 0.0;
    for i = 1:length(traj1)-1
        v1 = traj1(i+1, :) - traj1(i, :);
        v2 = traj2(i+1, :) - traj2(i, :);
        %calc cosine similarity
        costheta = dot(v1, v2) / (norm(v1) * norm(v2));
        %calc angular distance
        if isnan(costheta)
            ang_dist = 0;
        else
            ang_dist = acos(costheta) / pi;
        end
        sum = sum + ang_dist;
    end
dist = sum / length(traj1);
end
end