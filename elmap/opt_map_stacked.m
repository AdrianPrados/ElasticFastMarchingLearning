function opt_nodes = opt_map_stacked(clusters, data, weights, stretch, bend, in_nodes)
%alternative version where cvx optimizes a vector instead of a multi-column
%vector by stacking x, y, and/or z coordinates to make a single column
%vector. Recommended to use the other version opt_map.m.
[n_nodes, n_dims] = size(in_nodes);
n_data = size(data, 1);

if n_dims > 3
    disp('Number of dimensions not yet implemented!');
    exit();
end

n_total = n_nodes*n_dims;

%nodes_stacked = reshape(in_nodes, [n_total, 1]);
data_stacked = reshape(data, [n_data*n_dims, 1]);

I = eye(n_total);

%% setup K matrix
gamma = 1 / sum(weights);
K = zeros(n_total, n_data*n_dims);
for i=1:n_nodes
    cluster = clusters{i};
    for j=1:length(cluster)
        clustered_data_ind = cluster(j);
        K(i, clustered_data_ind) = weights(clustered_data_ind);
        if n_dims >= 2
            K(i+n_nodes, clustered_data_ind+n_data) = weights(clustered_data_ind);
        end
        if n_dims >= 3
            K(i+2*n_nodes, clustered_data_ind+2*n_data) = weights(clustered_data_ind);
        end
    end
end
%disp(K)
%disp(K*data)

%% setup E matrix
E = zeros(n_total-1, n_total);
e1 = diag(-1*ones(n_total-1, 1));
e2 = diag(ones(n_total-1, 1));
E(:, 1:end-1) = E(:, 1:end-1) + e1;
E(:, 2:end) = E(:, 2:end) + e2;
if n_dims >= 2
    E(n_nodes, :) = 0;
end
if n_dims >= 3
    E(2*n_nodes, :) = 0;
end

%% setup R matrix
R = zeros(n_total-2, n_total);
r1 = diag(ones(n_total-2, 1));
r2 = diag(-2*ones(n_total-2, 1));
R(:, 1:end-2) = R(:, 1:end-2) + r1;
R(:, 2:end-1) = R(:, 2:end-1) + r2;
R(:, 3:end) = R(:, 3:end) + r1;
if n_dims >= 2
    R(n_nodes-1, :) = 0;
    R(n_nodes, :) = 0;
end
if n_dims >= 3
    R(2*n_nodes-1, :) = 0;
    R(2*n_nodes, :) = 0;
end

%% solve optimization
cvx_begin quiet
    variable x(n_total)
    minimize(gamma*sum_square(I*x - K*data_stacked) + stretch*sum_square(E*x) + bend*sum_square(R*x))
    % add constraints later maybe??
cvx_end
opt_nodes = reshape(x, [n_nodes, n_dims]);
end