function weights = calc_curv_weights(demos)
if iscell(demos)
    weights = cell(1, length(demos));
    for i=1:length(demos)
        w = zeros(length(demos{i}), 1);
        for j=2:length(demos{i})-1
            w(j) = norm(demos{i}(j+1, :) - 2*demos{i}(j, :) + demos{i}(j-1, :));
        end
        w(1) = w(2);
        w(end) = w(end-1);
        weights{i} = w;
    end
else
    weights = zeros(length(demos), 1);
    for j=2:length(demos)-1
        weights(j) = norm(demos(j+1, :) - 2*demos(j, :) + demos(j-1, :));
    end
    weights(1) = weights(2);
    weights(end) = weights(end-1);
end
end
