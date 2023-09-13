function nodes = OriginalElasticMap(data, weights, stretch, bend, initial, inds, constraints, num_iter)
%use expectation-maximization to solve elastic maps
%Expectation: clustering data to nodes of elastic map
%Maximization: optimize location of nodes
%repeat until converged (clustering doesn't change) or max iters reached
%Note: the maximization used here is slower than a least-squares approach,
%but easier to understand and manipulate.
if iscell(data)
    dataEM2 = vertcat(data{:});
else
    dataEM2 = data;
end

if iscell(weights)
    weights = vertcat(weights{:});
end

if iscell(data)
    data = vertcat(data{:});
end
if iscell(weights)
    weights = vertcat(weights{:});
end

old_assoc = associate(data, initial); %expectation
opt_nodes = opt_map(old_assoc, data, weights, stretch, bend, initial, inds, constraints); %maximization
%opt_nodes = opt_map_stacked(old_assoc, data, weights, stretch, bend, initial);

%% repeat until converged
assoc = associate(data, opt_nodes);
i = 0;
while (~isequal(old_assoc, assoc)) && (i < num_iter)
    i = i + 1;
    disp(['Iteration: ' num2str(i)]);
    old_assoc = assoc;
    opt_nodes = opt_map(old_assoc, data, weights, stretch, bend, opt_nodes, inds, constraints);
    %opt_nodes = opt_map_stacked(old_assoc, data, weights, stretch, bend, opt_nodes);
    assoc = associate(data, opt_nodes);
end
nodes = opt_nodes; %return best/optimal map
end

