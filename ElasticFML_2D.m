%% Test of Elastic Fast Marching Learning
%setup paths
addpath('elmap');
addpath('utils');
addpath('cvx-a64');
addpath('algorithms');
addpath('test');
addpath('examples');
addpath('fm2tools');
addpath('data')

%% Setup simulated demos
N = 1000;
t = linspace(0, 10, N);
t = reshape(t, [N, 1]);
% Create your own data
n=4; %Number of data to be acquired (can be modified to more than 1)
data = [];
[x1,constrains] = CaptureData(n);

for j=1:n
    indices_originales{j} = linspace(1, size(x1{1,j}, 2), N);
    traj = interp1(x1{1,j}', indices_originales{1,j});
    data{j} = traj;
end

%Simulated data
% x1 = -0.005*abs((t-5).^3) + 0.1 * sin(t) - 0.5;
% n=1;
% traj = [t, x1];
% traj = abs(traj * 100) + 1;
% data = traj;
% constrains = [1, 100; 1000 100];

%weights/constants
init = traj(1:10:N, :); %random initial map, does not matter that much
constraints = [1, length(init)];

%% Call to ElasticMap algorithm for 2D
[nodes,nodesFML] = ElasticMap(data, init, [1, length(init)], constrains); 

%% Plot solution
figure(3);
hold on;

% plot(traj(:, 1), traj(:, 2), 'k', 'linewidth', 5);
% plot(init(:, 1), init(:, 2), 'r', 'linewidth', 3);
plot(nodes(:, 1), nodes(:, 2), 'b', 'linewidth', 3);
plot(constrains(1,1), constrains(1,2), 'b*')
plot(constrains(2,1), constrains(2,2), 'm*')


%% Execution of ElMap to compare results
w2 = [];
for i=1:n
    w2{i} = ones(N,1);
end
[stretch2, bend2, num_iter2] = estimate_params(data, w2, init);
disp([stretch2, bend2, num_iter2]);
ELMAPnodes = OriginalElasticMap(data,w2,stretch2,bend2,init,[1, length(init)], constrains,0);
figure(3);
hold on;
plot(ELMAPnodes(:, 1), ELMAPnodes(:, 2), 'm', 'linewidth', 3);
legend('Demonstration','FML','ElasticFML','Initial Point','Final Point','ElasticMap')
