function [nodes] = ElasticMap3D(data, weights, stretch, bend, inds, constraints,n,opt_nodes,num_iter)
if ~iscell(data)
    disp('WARNING: data must be a cell');
end
if iscell(data)
    dataEM = vertcat(data{:});
else
    dataEM = data';
end

if iscell(weights)
    w = vertcat(weights{:});
end
%% repeat until converged
assoc = associate(dataEM, opt_nodes); % expectation
i = 0;
Check = 1;
while (Check) && (i < num_iter) % Cambia a i < i ¡¡¡
    i = i + 1;
    disp(['Iteration: ' num2str(i)]);
    old_assoc = assoc;
    opt_nodes = opt_map(old_assoc, dataEM, w, stretch, bend, opt_nodes, inds, constraints);
    %opt_nodes = opt_map_stacked(old_assoc, data, weights, stretch, bend, opt_nodes);
    assoc = associate(dataEM, opt_nodes);
    Check = ~isequal(old_assoc, assoc);
end
nodes = opt_nodes; %return best/optimal map
end

