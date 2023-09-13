%% Example of use in 2 dimensions
% Developed by Adrian Prados

%%
close all;
clear all;

% Adding to path the algorithms folder. This is not required if it is
% permanently included in the Matlab path.
if isempty(regexp(path,['algorithms' pathsep], 'once'))
    addpath([pwd, '/../algorithms']);    % path algorithms
end

if isempty(regexp(path,['fm2tools' pathsep], 'once'))
    addpath([pwd, '/../fm2tools']);    % path algorithms
end


% Parameters:
n = 3;                     % Number of demonstrations.
mapname = 'data/map_obs.png';   % Map the learning will learn over.
%mapname = 'examples/map.png';
sat = 0.1;                % Saturation, between 0 and 1.
aoi_size = 3;             % Pixels of the area of influence.
 
% Initialization.
% That part is just if you want an empty space
%################################
imagen = imread(mapname);
imagen(:,:) = 0;
imagen(1,1) = 1; % Se necesita poner un obstaculo siempre, si no peta, no se por que pero asi funciona
map = ~flipdim(imagen,1);
% ################################
% That part is used if you want to use an image as a map
% map = ~flipdim(imread(mapname),1);
% disp(map)
p =[];                                 
%demos = cell(1,n); % Aqui se gaurda el path  
%% Simulation of kinesthetic teaching.
% Generation of the values using the mouse
for k=1:n
    dataset = kinesthetic_teaching (map', p);
    p = [p dataset]; % This line is just to help plotting previous points.
    demos{k} = dataset; 
end

%% Executing the FML algorithm.
tic
[F, T, end_point, dx, dy] = FML(map, demos, sat, aoi_size);


% To see the velocity matrix representation
figure()
imshow(F')

% Getting some reproductions from the initial poitns of the demos.
for i = 1:n
    start_point = demos{i}(:,1);
    path = compute_geodesic(T, round(start_point));
    starts(:, i) = start_point;
    paths{i} = path(:,1:100:end);
end
toc

%% Plotting results.
imagesc(map);
colormap gray(256);
hold on;
axis xy;
box on;
h = streamslice(-dx,-dy); % Reproductions field with stream lines.
set(h,'color','b');

for i = 1:length(paths)  
    ff = plot(paths{i}(1,:),paths{i}(2,:),'b','LineWidth',3);
    f = plot(starts(1,i),starts(2,i),'k.','markersize',30);
end

for i = 1:n
    g = scatter(demos{i}(1,:),demos{i}(2,:),'.r');
end

plot(end_point(1),end_point(2),'k*','markersize',15,'linewidth',3);

set(gca,'xtick',[], 'ytick',[]);
hold off;
axis image


