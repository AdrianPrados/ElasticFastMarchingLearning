function opt_nodes = opt_map(clusters, data, weights, stretch, bend, in_nodes, inds, constraints)
%optimize elastic map using a convex formulation
[n_nodes, n_dims] = size(in_nodes);
n_data = size(data, 1);


%% setup K & A matrix
gamma = 1 / sum(weights);
K = zeros(n_nodes, n_data);
for i=1:n_nodes
    cluster = clusters{i};
    for j=1:length(cluster)
        clustered_data_ind = cluster(j);
        K(i, clustered_data_ind) = weights(clustered_data_ind);
    end
end
node_sums = sum(K, 2);
A = diag(node_sums);

%% setup E matrix
% Pulling forces??
E = zeros(n_nodes-1, n_nodes);
e1 = diag(-1*ones(n_nodes-1, 1));
e2 = diag(ones(n_nodes-1, 1));
E(:, 1:end-1) = E(:, 1:end-1) + e1;
E(:, 2:end) = E(:, 2:end) + e2;

%% setup R matrix
%Forces of each ribs??
R = zeros(n_nodes-2, n_nodes);
r1 = diag(ones(n_nodes-2, 1));
r2 = diag(-2*ones(n_nodes-2, 1));
R(:, 1:end-2) = R(:, 1:end-2) + r1;
R(:, 2:end-1) = R(:, 2:end-1) + r2;
R(:, 3:end) = R(:, 3:end) + r1;

%% solve optimization
cvx_begin quiet
    variable x(n_nodes, n_dims) % Variable de dimensiones n_nodes X n_dims
    minimize(sum(gamma*sum_square(A*x - K*data) + stretch*sum_square(E*x) + bend*sum_square(R*x))) %-> min(Uy+Ue+Ur)
    for i=1:length(inds)
        norm(x(inds(i), :) - constraints(i, :)) <= 0; %can change later so constraints are not met exactly
    end
cvx_end
opt_nodes = x;
end