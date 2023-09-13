%% Testing CVX optimization of elmap outside function

addpath('elmap');
addpath('utils');

in_nodes = init;
data = traj;
weights = w;

[n_nodes, n_dims] = size(in_nodes);
n_data = size(data, 1);

%% setup K matrix
K = zeros(n_nodes, n_data);
for i=1:n_nodes
    cluster = clusters{i};
    for j=1:length(cluster)
        clustered_data_ind = cluster(j);
        K(i, clustered_data_ind) = weights(clustered_data_ind);
    end
end

%% setup E matrix
E = zeros(n_nodes-1, n_nodes);
e1 = diag(-1*ones(n_nodes-1, 1));
e2 = diag(ones(n_nodes-1, 1));
E(:, 1:end-1) = E(:, 1:end-1) + e1;
E(:, 2:end) = E(:, 2:end) + e2;

%% setup R matrix
R = zeros(n_nodes-2, n_nodes);
r1 = diag(ones(n_nodes-2, 1));
r2 = diag(-2*ones(n_nodes-2, 1));
R(:, 1:end-2) = R(:, 1:end-2) + r1;
R(:, 2:end-1) = R(:, 2:end-1) + r2;
R(:, 3:end) = R(:, 3:end) + r1;

%% solve optimization
cvx_begin
    variable x(n_nodes, n_dims)
    minimize(sum(sum_square(x - K*data) + stretch*sum_square(E*x) + bend*sum_square(R*x)))
    % add constraints later maybe??
cvx_end
opt_nodes = x;