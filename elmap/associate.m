function clusters = associate(data, in_nodes)
n_data = size(data, 1);
n_nodes = length(in_nodes);
clusters = cell(length(in_nodes), 1);
dists = zeros(n_data, n_nodes);
for i = 1:n_data
    for j = 1:n_nodes
        dists(i, j) = norm(data(i, :) - in_nodes(j, :));
    end
end
[~, min_inds] = min(dists, [], 2);
for i = 1:n_data
    clusters{min_inds(i)}(end+1) = i;
%     if isempty(clusters{100,1}) == 1
%         disp("UPSSSS");
%         clusters{100,1} = 1000;
%     end

end
disp(clusters)
end