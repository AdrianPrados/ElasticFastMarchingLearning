function nodes = ElasticMapExplicit(data, weights, stretch, bend, initial, inds, constraints)
%use expectation-maximization to solve elastic maps
%Expectation: clustering data to nodes of elastic map
%Maximization: optimize location of nodes
%repeat until converged (clustering doesn't change) or max iters reached
%Note: the maximization used here is slower than a least-squares approach,
%but easier to understand and manipulate.
% INPUTS:
% data -> demonstration
% weights
% initial -> initial map
%inds -> node index
%constrains -> initial and end points

if iscell(data)
    data = vertcat(data{:});
end
if iscell(weights)
    weights = vertcat(weights{:});
end

%% insert constraints
for i = 1:length(inds)
    data = vertcat(data, constraints(i, :));
    weights = vertcat(weights, [1e3]);
end

old_assoc = associate(data, initial); %expectation
opt_nodes = opt_map_explicit(old_assoc, data, weights, stretch, bend, initial); %maximization

%% repeat until converged
assoc = associate(data, opt_nodes); % expectation
i = 0;
Check = 1;
while (Check) && (i < 50)
    i = i + 1;
    disp(['Iteration: ' num2str(i)]);
    old_assoc = assoc;
    opt_nodes = opt_map_explicit(old_assoc, data, weights, stretch, bend, opt_nodes);
    assoc = associate(data, opt_nodes);
    Check = ~isequal(old_assoc, assoc);
end
nodes = opt_nodes; %return best/optimal map
end