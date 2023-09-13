%% Developed by Adrián Prados
% clear all;
% close all;
% Adding to path the algorithms folder. This is not required if it is
% permanently included in the Matlab path.
if isempty(regexp(path,['algorithms' pathsep], 'once'))
    addpath([pwd, '/../algorithms']);    % path algorithms
end

if isempty(regexp(path,['fm2tools' pathsep], 'once'))
    addpath([pwd, '/../fm2tools']);    % path algorithms
end

% Parameters:
sat = 1; % Between 0 and 1.

% Load map and adapt it
% imagen = imread('../data/pies.png');
imagen = imread('Inicial.jpg');
imagen = imcomplement(imagen(:,:,1));
% imagen(:,:) = 0;
% imagen(1,1) = 1; % It is neccesary to put a very tiny object in the map
map = ~flipdim(imagen,1);

% load("labHokuyo.mat");
% map = occupancyMatrix(map);
% map = flipdim(map,1); % To change the Y coordinates.

% These points can be set with ginput or other input methods. They have to
% be integers at last.
start = [32; 267];
goal = [259; 37]; 

% Plotting map
figure(1);
hold on;
imagesc(map);
colormap gray(256);
axis xy;
axis image;
axis off;
plot(start(1), start(2), 'rx', 'MarkerSize', 15);
plot(goal(1), goal(2), 'k*', 'MarkerSize', 15);

%% Fast Marching Square
[F, T, path, vels, times] = FM2(map, sat, start, goal);

%% Updating map
figure(1)
hold on
plot(path(1,:), path(2,:), 'b-', 'LineWidth', 3);

%% Plotting velocities map.
figure(2);
imagesc(F);
colormap gray(256);
axis xy;
axis image;
axis off;

%% Plotting times-of-arrival map.
figure(3)
imagesc(T);
colormap jet;
axis xy;
axis image;
axis off;

%% Showing times info.
str = sprintf('Time for F map: %f\nTime for T map: %f.',times(1),times(2));
disp(str);