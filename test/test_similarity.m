%% Testing similarity functions

addpath('elmap');
addpath('utils');

t = linspace(0, 10, 100);
x1 = -0.005*abs((t-5).^3) + 0.1 * sin(t) - 0.5;
x2 = -0.05*(t-5).^2 + 0.1 * cos(t);

traj1 = [t', x1'];
traj2 = [t', x2'];

disp(['Frechet Dist: ', num2str(frechet(traj1, traj2))]);
disp(['Angular Sim: ', num2str(angular_similarity(traj1, traj2))]);
disp(['Jerk Traj1: ', num2str(calc_jerk(traj1))]);
disp(['Jerk Traj2: ', num2str(calc_jerk(traj2))]);

figure;
hold on;
plot(t, x1, 'r');
plot(t, x2, 'g');