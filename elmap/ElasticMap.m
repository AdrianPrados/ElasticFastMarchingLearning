function [nodes,nodesFML] = ElasticMap(data, initial, inds, constraints)
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

% old_assoc = associate(data, initial); %expectation
% opt_nodes = opt_map(old_assoc, data, weights, stretch, bend, initial, inds, constraints); %maximization
%opt_nodes = opt_map_stacked(old_assoc, data, weights, stretch, bend, initial);

if ~iscell(data)
    disp('WARNING: data must be a cell');
end

n = length(data);
%% First idea to implement -> if we exchange the proccess using the FML for the generation of the first solution.
%map = ones(300,500);
sat = 0.3;                % Saturation, between 0 and 1.
aoi_size = round(20 / sqrt(n));             % Pixels of the area of influence.
for k=1:n
    plot(data{1,k}(:, 1), data{1,k}(:, 2), 'r', 'linewidth', 3);
    hold on
end
% axis padded % Add a little space 
axi = axis;
f=gca;
set(gca,'xtick',[],'ytick',[]);
exportgraphics(f,'mapSol.png','ContentType','image')
%With that we can add obstacles in 2D
map = imread('mapSol.png');
map = rgb2gray(map);
map= imbinarize(map);
map = flipdim(map,1);
[sizeX,sizeY] = size(map);
%Generate a free space with the dimensions of the path
mapFree= ones(sizeX,sizeY);
mapFree(1,1) = 0;

for i=1:n
    dataX = interp1([axi(1) axi(2)],[0.5 sizeY],data{1,i}(1:10:end,1));
    dataY = interp1([axi(3) axi(4)],[0.5 sizeX],data{1,i}(1:10:end,2));
    demos{i} = [dataX';dataY'];    
end

% for k=1:n
%     demos{k} = data'; 
% end
[F, T, end_point, dx, dy] = FML(mapFree, demos, sat, aoi_size);

%% Weight estimation
% Can use the same weight (1)
N = 1000;
w = ones(N, 1);
% Can use the weight obtained by F matrix
[fx,fy] = size(F);
k=1;
valI = [];
valJ = [];
for i= 1:fx
    for j=1:fy
        if F(i,j) == 1.3
            w(k)=F(i,j);
            valI = [valI;i];
            valJ = [valJ;j];
            k = k+1;
        end
    end
end
%Weigths in cell structure
for i =1:n
    wei{i}=w;
end
% Velocity matrix and reconfiguration
figure()
imshow(F')
initialX = interp1([axi(1) axi(2)],[0.5 sizeY],constraints(1,1));
initialY = interp1([axi(3) axi(4)],[0.5 sizeX],constraints(1,2));
initialPoint = [initialX;initialY];
endX = interp1([axi(1) axi(2)],[0.5 sizeY],constraints(2,1));
endY = interp1([axi(3) axi(4)],[0.5 sizeX],constraints(2,2));
endPoint = [endX;endY];

for i = 1:1 % Can be change to more than one solution
    start_point = initialPoint;
    [D,~]=perform_fast_marching(F,round(endPoint));
    path = compute_geodesic(D, round(start_point));
    starts(:, i) = start_point;
    paths{i} = path(:,1:end);
    L = length(paths{1});
    l = length(initial);
    indexRe = linspace(1, L, l);
    XReconfig=interp1(paths{1}(1,:), indexRe);
    YReconfig=interp1(paths{1}(2,:), indexRe);
    pathsE{i}=[XReconfig;YReconfig];
end


for i=1:1
    optX = interp1([0.5 sizeY],[axi(1) axi(2)],pathsE{i}(1,:));
    optY = interp1([0.5 sizeX],[axi(3) axi(4)],pathsE{i}(2,:));
    opt_nodes = [optX;optY]';
end



%% Plot the values of FML 
figure(3);
for i=1:n
    plot(data{1,i}(:, 1), data{1,i}(:, 2), 'r', 'linewidth', 3);
    hold on
end
plot(opt_nodes(:,1), opt_nodes(:,2), 'g', 'linewidth', 3);
nodesFML = opt_nodes;
hold off
%% Elastic reconfiguration repeated until converged
if iscell(data)
    dataEM = vertcat(data{:});
%     dataEM=dataEM(1:60:end,:);
else
    dataEM = data;
end

if iscell(wei)
    weights = vertcat(wei{:});
end     
[stretch, bend, num_iter] = estimate_params(dataEM, weights, opt_nodes);
disp([stretch, bend, num_iter]);
assoc = associate(dataEM, opt_nodes); % expectation
i = 0;
Check = 1;
while (Check) && (i < num_iter) 
    i = i + 1;
    disp(['Iteration: ' num2str(i)]);
    old_assoc = assoc;
    opt_nodes = opt_map(old_assoc, dataEM, weights, stretch, bend, opt_nodes, inds, constraints);
    %opt_nodes = opt_map_stacked(old_assoc, data, weights, stretch, bend, opt_nodes);
    assoc = associate(dataEM, opt_nodes);
    Check = ~isequal(old_assoc, assoc);
end
nodes = opt_nodes; %return best/optimal map
end