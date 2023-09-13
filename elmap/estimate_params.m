function [lambda, mu, num_iter] = estimate_params(data, weights, in_nodes)
[n_nodes, n_dim] = size(in_nodes);
if iscell(data)
    data = vertcat(data{:});
end
if iscell(weights)
    weights = vertcat(weights{:});
end

if iscell(in_nodes)
    in_nodes = vertcat(in_nodes{:});
end
%disp(data)
sf = max(max(data, [], 1) - min(data, [], 1)) / n_dim;
%sf = 1;
%% estimate approximation nrg
clusters = associate(data, in_nodes);
gamma = 1 / sum(weights);
ux_sum = 0.0;
for i=1:n_nodes
    cluster = clusters{i};
    for j=1:length(cluster)
        clustered_data_ind = cluster(j);
        ux_sum = ux_sum + weights(clustered_data_ind)*norm(in_nodes(i, :) - data(clustered_data_ind, :))^2;
    end
end
ux = ux_sum * gamma;

%% estimate stretching nrg
ue_sum = 0.0;
for i=1:n_nodes-1
    ue_sum = ue_sum + norm(in_nodes(i+1, :) - in_nodes(i, :))^2;
end
lambda = 1.2 * ux / (ue_sum*sf);

%% estimate bending nrg
ur_sum = 0.0;
for i=2:n_nodes-1
    ur_sum = ur_sum + norm(in_nodes(i+1, :) - 2*in_nodes(i, :) + in_nodes(i-1, :))^2;
end
mu = 1.1 * ux / (ur_sum*sf);

%% estimate iterations
dist_data = 0.0;
dist_init = 0.0;
for i=1:length(data)-1
    dist_data = dist_data + norm(data(i+1, :) - data(i, :));
end
for i=1:n_nodes-1
    dist_init = dist_init + norm(in_nodes(i+1, :) - in_nodes(i, :));
end
num_iter = ceil(dist_data / dist_init);
end
