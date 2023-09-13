%% Example/test of elastic maps with F
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
stretch = 10.0;
bend = 20.0;
init = traj(1:10:N, :); %random initial map, does not matter that much
%rng('default');
%init = init + normrnd(0, 0.05, size(init));

%generate F matrix
data = traj;
n=1;
%map = ones(300,500);
sat = 0.3;                % Saturation, between 0 and 1.
aoi_size = 10;             % Pixels of the area of influence.
plot(data(:, 1), data(:, 2), 'r', 'linewidth', 3);
% axis padded % Add a little space 
axi = axis;
f=gca;
set(gca,'xtick',[],'ytick',[]);
exportgraphics(f,'map.png','ContentType','image')
%With that we can add obstacles in 2D
map = imread('map.png');
map = rgb2gray(map);
map= imbinarize(map);
map = flipdim(map,1);
[sizeX,sizeY] = size(map);
%Generate a free space with the dimensions of the path
mapFree= ones(sizeX,sizeY);
mapFree(1,1) = 0;
% mapFree(end,:) = 0;
% mapFree(:,1) = 0;
% mapFree(:,end) = 0;

for i=1:n
    dataX = interp1([axi(1) axi(2)],[0.5 sizeY],data(:,1));
    dataY = interp1([axi(3) axi(4)],[0.5 sizeX],data(:,2));
    demos{i} = [dataX';dataY'];    
end

% for k=1:n
%     demos{k} = data'; 
% end
[F, T, end_point, dx, dy] = FML(mapFree, demos, sat, aoi_size);

Fstruct.axi = axi;
Fstruct.sizeX = sizeX;
Fstruct.sizeY = sizeY;

%solve map
nodes = ElasticMapF(stretch, bend, init, [1, length(init)], [0, -1; 10 -1], F, Fstruct);

%plot solution
figure;
hold on;

plot(traj(:, 1), traj(:, 2), 'k', 'linewidth', 5);
plot(init(:, 1), init(:, 2), 'r', 'linewidth', 3);
plot(nodes(:, 1), nodes(:, 2), 'g', 'linewidth', 3);
plot(0, -1, 'b*')
plot(10, -1, 'm*')