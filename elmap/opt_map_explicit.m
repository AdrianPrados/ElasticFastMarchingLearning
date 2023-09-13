function opt_nodes = opt_map_explicit(clusters, data, weights, stretch, bend, in_nodes)
%optimize elastic map using an explicit formulation
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

%% set up optimization functions

    function cost = Uy(x)
        cost = gamma * norm(A*x - K*data)^2;
    end

    function cost = Ue(x)
        cost = stretch * norm(E*x)^2;
    end

    function cost = Ur(x)
        cost = bend * norm(R*x)^2;
    end

opt_fun_explicit = @(x)Uy(x) + Ue(x) + Ur(x);

%% solve optimization
opt_nodes = fminunc(opt_fun_explicit, in_nodes);
end