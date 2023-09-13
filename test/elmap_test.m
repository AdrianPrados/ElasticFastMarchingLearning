%% Example/test of elastic maps
%setup paths
addpath('elmap');
addpath('utils');
addpath('cvx-a64');
addpath('algorithms');
addpath('data');
addpath('examples');
addpath('fm2tools');

%setup simulated demos
N = 1000;
t = linspace(0, 10, N);
t = reshape(t, [N, 1]);
x1 = -0.005*abs((t-5).^3) + 0.1 * sin(t) - 0.5;
traj = [t, x1];

%weights/constants
w = ones(N, 1);
stretch = 0.7;
bend = 1.0;
init = traj(1:10:N, :); %random initial map, does not matter that much

[l, m] = estimate_params(traj, w, init);

%solve map
nodes = OriginalElasticMap(traj, w, stretch, bend, init, [1, length(init)], [0, -1; 10.1 -1.4]);
nodes3 = OriginalElasticMap(traj, w, l, m, init, [1, length(init)], [0, -1; 10.1 -1.4]);
nodes2 = ElasticMapExplicit(traj, w, stretch, bend, init, [1, length(init)], [0, -1; 10.1 -1.4]);
%nodes = ElasticMap(traj, w, stretch, bend, init, [], []);

%plot solution
figure;
hold on;

plot(traj(:, 1), traj(:, 2), 'k', 'linewidth', 5);
%plot(init(:, 1), init(:, 2), 'r', 'linewidth', 3);
plot(nodes(:, 1), nodes(:, 2), 'g', 'linewidth', 3);
plot(nodes2(:, 1), nodes2(:, 2), 'r', 'linewidth', 3);
plot(nodes3(:, 1), nodes3(:, 2), 'b', 'linewidth', 3);
plot(0, -1, 'b*')
plot(10, -1, 'm*')

%% Comparition of results
% Frechet 
Frech = frechet(nodes,traj)
Jerk = calc_jerk(nodes)
Angular = angular_similarity(nodes,traj)

Frech = frechet(nodes2,traj)
Jerk = calc_jerk(nodes2)
Angular = angular_similarity(nodes2,traj)

Frech = frechet(nodes3,traj)
Jerk = calc_jerk(nodes3)
Angular = angular_similarity(nodes3,traj)