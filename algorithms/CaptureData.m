function [demos,constrains] = CaptureData(n)
mapname = 'data/map_obs.png';   % Map the learning will learn over.
%mapname = 'examples/map.png';
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
constrains = [];
%demos = cell(1,n); % Aqui se gaurda el path  
%% Simulation of kinesthetic teaching.
% Generation of the values using the mouse
for k=1:n
    [dataset,~,constrains] = kinesthetic_teaching (map', p);
    p = [p dataset]; % This line is just to help plotting previous points.
    demos{k} = dataset;
    constrains= constrains';
end
end

