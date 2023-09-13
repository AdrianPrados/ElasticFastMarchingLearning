function plot_adam_repros(task, demo_num)
data = load_adam_data(task, demo_num);
load(['results\' task '_adam_results.mat'], 'results');
maps = results.repros;
for i=1:9
    plot3(data{i}(:, 1), data{i}(:, 2), data{i}(:, 3), 'k', 'linewidth', 2);
    plot3(maps{demo_num, i}(:, 1), maps{demo_num, i}(:, 2), maps{demo_num, i}(:, 3), 'r', 'linewidth', 3);
    hold on;
end
grid on;
xlabel('x')
ylabel('y')
zlabel('z')
end