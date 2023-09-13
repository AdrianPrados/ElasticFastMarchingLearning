function nodes = ElasticMapF(stretch, bend, initial, inds, constraints, F, Fstruct)
%use expectation-maximization to solve elastic maps
%Expectation: clustering data to nodes of elastic map
%Maximization: optimize location of nodes
%repeat until converged (clustering doesn't change) or max iters reached
%Note: the maximization used here is slower than a least-squares approach,
%but easier to understand and manipulate.
% INPUTS:
% initial -> initial map
%inds -> node index
%constrains -> initial and end points

opt_nodes = opt_map_F(stretch, bend, initial, inds, constraints, F, Fstruct); %maximization

nodes = opt_nodes; %return best/optimal map
end