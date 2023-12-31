%% Elastic Fast Marching Learning in 3D
% This script present the generation of EFML for 3D environments.

%% Learning in FM2: Modifying the W map according to the paths obtained in the training time.
%setup paths
addpath('elmap');
addpath('utils');
addpath('cvx-a64');
addpath('algorithms');
addpath('examples');
addpath('fm2tools');
addpath('test')
addpath('data')

%% Initializing variables.
% close all;
% clear all;
% clc;

sat = 0.4; % Saturation value for FML
aoi_size = 6;% Area of influence for FML
kappa = 0.6; % Value of the auto-learning limit
view_ori = [15,5];
p =[];
%% Loading the base map and the obstacles
% Follows the nex estructure: Wo(Y,X,Z) 
Wo_size = [180,180,180]; % Enough space for our ADAM robot, it can be change
Wo=ones(Wo_size);
Wo(1,:,:)=1;
Wo(Wo_size(1),:,:)=1;
Wo(:,1,:)=1;
Wo(:,Wo_size(2),:)=1;
Wo(:,:,1)=1;
Wo(:,:,Wo_size(3))=1; 

%% Obstacles can be added to the environemnt
% Wo(78.5:99.5, 41:66, 75:95)=0; % Box obstacle
Wo(50:90,16:41,1:100)=0; % Robot body (always necessary to don't have autocolisions)
% Wo(10:130,41:120,1:75)=0; % Table
% Wo_body = [20,20,20];
% %Wo_body = [10:20,10:20,10:20];
% Wo_cuerpo = ones(Wo_body);
% Wo_cuerpo(1,:,:)=0;
% Wo_cuerpo(Wo_size(1),:,:)=0;
% Wo_cuerpo(:,1,:)=0;
% Wo_cuerpo(:,Wo_size(2),:)=0;
%% World used to plot
W_nosat = bwdist(~ Wo);
W_nosat = rescale(double(W_nosat));
W_init = min(sat, W_nosat);
W = W_init;
Wpo = ones(size(W));
zero_index = find(W_init==0);
Wopoints = Wo;
n = 1;

%% 3D trajectories interpreter
matriz = [1 0 0 0.07;0 0.707 0.707 0.13;0 -0.707 0.707 1.15;0 0 0 1]; %Conversion matrix
matFiles = dir('/home/adrian/Escritorio/ElasticMaps/ElMapMatlab/RAIL/PressingAdam/Pressing5/*.mat'); %Filtered data to optime velocity of FML
matFiles2 = dir('/home/adrian/Escritorio/ElasticMaps/ElMapMatlab/RAIL/PressingAdam/Pressing5NoFilter/*.mat'); %No filetred data to compare
% matFiles = dir('/home/adrian/Escritorio/ElasticMaps/ElMapMatlab/RealExperiment/DemosADAM-PickPlace/PICK/Both/*.mat'); %Filtered data to optime velocity of FML
% matFiles2 = dir('/home/adrian/Escritorio/ElasticMaps/ElMapMatlab/RealExperiment/DemosADAM-PickPlace/PICK/Both/*.mat'); %Filtered data to optime velocity of FML

numfiles = length(matFiles);
q = cell(1, numfiles);
c = cell(1,numfiles);
met=cell(1,numfiles);
for k = 1:numfiles 
  teach = load(matFiles(k).name);% Load the data learned
  dataCo = load(matFiles2(k).name);
  teach_round = teach.LearnedPathSave' * 100; % LearnedPathSave' for the normal
  dataComp = dataCo.LearnedPathSave' * 100;
  met{k} = dataComp; %used for the metrics
  teach_round = [teach_round(1,:) + 10;teach_round(2,:) + 76;teach_round(3,:)]; %Conversion to matlab environment
  dataComparate = [dataComp(1,:) + 10;dataComp(2,:) + 76;dataComp(3,:)]; %Conversion to matlab environment
  teach = teach_round;
  figure(2);
  nombreLinea=sprintf('Linea %d',k);
  plot3(teach(1,:),teach(2,:),teach(3,:), 'Color',[0.5 0.5 0.5],'LineWidth',1.5,'DisplayName',nombreLinea);
  hold on;
%   plot3(dataComparate(1,:),dataComparate(2,:),dataComparate(3,:), 'r','LineWidth',1);
  q{k} = teach; % Used for teaching FML
  c{k} = dataComparate; %Used to compare agains elastic part
  

end
options.nb_iter_max = Inf;
options.Tmax        = sum(size(W));

%% Uncomment this to draw the solutions saved in results
% hold on;plot3(results.pathEFML(1,:),results.pathEFML(2,:),results.pathEFML(3,:),'Color',[0.3010 0.7450 0.9330],'LineWidth',6);
% hold on;plot3(results.pathEMap(1,:),results.pathEMap(2,:),results.pathEMap(3,:),'--','Color',[0.8500 0.3250 0.0980],'LineWidth',6);
% hold on;plot3(results.pathFML(1,:),results.pathFML(2,:),results.pathFML(3,:),':','Color',[0.4660 0.6740 0.1880],'LineWidth',6);
% hold on;plot3(results.pathEFML(1,1),results.pathEFML(2,1),results.pathEFML(3,1),'ko','MarkerSize',15,'MarkerFaceColor','k')
% hold on;plot3(results.pathEFML(1,end),results.pathEFML(2,end),results.pathEFML(3,end),'ko','MarkerSize',15,'MarkerFaceColor','k')
% hold on;plot3(results.pathEFML(1,9),results.pathEFML(2,9),results.pathEFML(3,9),'ko','MarkerSize',12,'MarkerFaceColor','k')

%% FML procces to generate the W matrix
tic
for k=1:length(q)

    %% Teaching the system.
    dataset = q{k};
    
    %% Getting a path from the learned data.

    for i = 1:length(dataset)-1
        options.end_points  = dataset(:,i+1);
        [D,~] = perform_fast_marching(W, dataset(:,i), options);
        path = compute_geodesic(D,dataset(:,i+1), options);
        i
        % A binary map is created with the path obtained.
        Wpoi = ones(size(W)); 
        s = size(path);
        if s(1) >1
            for j=1:s(2)
                % 2 and later 1 because of the x-y --> row-cols
                Wpoi(round(path(2,j)),round(path(1,j)),round(path(3,j))) = 0;
            end
        else
            disp('ENTRO');
             Wpoi(round(path(2)),round(path(1)),round(path(3))) = 0;
        end
        % Merging all the paths information.
        Wpo = min(Wpo,Wpoi);    
    end
end 

SE = strel('sphere', aoi_size);
Wpo = imdilate(~Wpo,SE);

Wp = rescale(bwdist(~Wpo), 0, 1-sat);
W = W + Wp;
W = W .* Wo;
toc
%plot_map3d(Wpo, 0.2, 10000, view_ori); % For workspace visualization
%% Path planning with the W learned map.
%%%%%% RAIL %%%%%%%
% Follows [Y;X;Z] for final point and [Y X Z] for initial points
end_point=[53.1;83.9;82.9];
options = [];
options.nb_iter_max = Inf;
options.Tmax = sum(size(W));
paths = [];

start_point = input('\n Start point [x y z] (0 to finish)[0]: ');

if isempty(start_point)
    start_point = 0;
end

count = 1;
% options.start_points  = end_point;

while start_point ~= 0
%     optionsD.end_points = end_point;
%     optionsD.nb_iter_max = Inf;
    tic
    [D,~] = perform_fast_marching(double(W), end_point ,options);
%     optionsA.start_points = end_point;
%     optionsA.nb_iter_max = Inf;
    path_l = compute_geodesic(D, start_point', options);
%     path_l(:,end+1) = start_point';
%     prueba = unique(round(path_l',2),'rows','legacy');
%     prueba= prueba';
%     path_l = flip(prueba,2);
    plot3(path_l(1,:),path_l(2,:),path_l(3,:),'g','LineWidth',3);
    toc
    paths{count} = path_l;
    count = count+1;
    last_start_points = start_point;

    %% ¡¡ Optional (does not affect in this case but is good to have it)
    % The process of self-learning is carried out. In the first case it is checked whether it can be done or not.
    % If it can be done, a new binary map is creted adn the previous one is
    % added.

    % 1. First step
    suma = 0;
    P =[];
    for i=1:length(path_l)
        po= W(round(path_l(1,i)),round(path_l(2,i)),round(path_l(3,i)));
        P = [P;po];
        suma = suma + po;
    end
    suma 
    resultado = suma / (length(path_l))

    % 2. Second step
    if resultado < kappa
        disp("Path auto-learned");
        Wpo2 = ones(size(W)); 
        s = size(path_l);
        if s(1) > 1
            for j=1:s(2)
                % 2 and later 1 because of the x-y --> row-cols
                Wpo2(round(path_l(1,j)),round(path_l(2,j)),round(path_l(3,j))) = 0;
            end
        else
            disp('ENTRO');
            Wpo2(round(path_l(1)),round(path_l(2)),round(path_l(3))) = 0;
        end
        % Merging all the paths information.
        Wpoini = ones(size(W));
        Wpoini = min(Wpoini,Wpo2);
        W1 = W;
        SE = strel('sphere', aoi_size);
        Wpoini = imdilate(~Wpoini,SE);
        Wp2 = rescale(bwdist(~Wpoini), 0, 1-sat);
        W = W + Wp2;
        W = W .*Wo;
        W(find(W>1))=1; % As we are adding 2 different matrix, we can have values upper than 1 that we need to control.
    else
      disp("Path not auto-learned");  
    end

    % A new path can be generated
    
    start_point = [];
    start_point = input('\n Start point [x y z] (0 to finish): '); 
    if isempty(start_point)
        start_point = 0;
    end
end

%% Implementation of ElasticMap
path_down = path_l(:,1:8:end); % Reduction of the points
% aux1=path_down(1,:);
% aux2=path_down(2,:);
% path_down(1,:) = aux2;
% path_down(2,:) = aux1;
pathFML = path_down; % Save FML path
[fx,fy,fz] = size(W); % Size of the full matrix
%Generation of the weigths from the matrix
h=1;
valI = [];
valJ = [];
valK = [];
for i= 1:fx
    for j=1:fy
        for k=1:fz
            if W(i,j,k) >= 0.6
                w(h)=W(i,j,k);
                valI = [valI;i];
                valJ = [valJ;j];
                valK = [valK;k];
                h = h+1;
            end
        end
        
    end
end
% We can use also this weigths
w = ones(length(dataComparate), 1);
n = numfiles;
constrains = [pathFML(1,1) pathFML(2,1) pathFML(3,1);pathFML(1,end) pathFML(2,end) pathFML(3,end)]; %Constrains
for i=1:n
    data{i} = c{1,i}';
end
w=double(w);
%Weigths in cell structure
for i =1:n
    wei{i}=w;
end
[stretch,bend,num_iters]= estimate_params(data,wei,pathFML');
stretch 
bend
num_iters
nodes = ElasticMap3D(data, wei, stretch, bend, [1, length(pathFML)], constrains,n,pathFML',1000);
hold on; plot3(nodes(:,1),nodes(:,2),nodes(:,3),'m','LineWidth',3);

%% Comparison agaisnt Elastic Map
w2 = ones(length(dataComparate), 1);
init = c{1,3}(:,1:35:length(c{1,3})); %random initial map, does not matter that much
for p=1:1:n
    wei2{p}=w2;
end
[stretch2,bend2,num_iter2]= estimate_params(data,wei2,init');
stretch2
bend2
num_iter2
ELMAPnodes = OriginalElasticMap(data,wei2,stretch2,bend2,init',[1, length(init)], constrains,1000);
hold on;
plot3(ELMAPnodes(:, 1), ELMAPnodes(:, 2),ELMAPnodes(:,3), 'y', 'linewidth', 3);
% legend("Raw Data (comparison)","Filtered data (acelerate FML)","FML","Elastic-FML","ElMap");


%% Postprocess of the path generated
%% Path from FML
pathFMLmod= flip(pathFML,2);
pathComparacion = pathFMLmod;
% for i=1:1:length(pathFML)
%     pathFML(1,i) = pathFML(1,i) - 76;
%     pathFML(2,i) = pathFML(2,i) - 10; 
% end
% aux = pathFML(1,:);
% aux2 = pathFML(2,:);
% pathFML(1,:) = aux2;
% pathFML(2,:) = aux;

auxa = pathComparacion(1,:);
auxb = pathComparacion(2,:);
pathComparacion(1,:) = auxb;
pathComparacion(2,:) = auxa;

%% Path from Elastic-FML
nodesEFML = nodes';
nodesEFML = flip(nodesEFML,2);
% for i=1:1:length(nodesEFML)
%     nodesEFML(1,i) = nodesEFML(1,i) - 76;
%     nodesEFML(2,i) = nodesEFML(2,i) - 10; 
% end
% auxE = nodesEFML(1,:);
% auxE2 = nodesEFML(2,:);
% nodesEFML(1,:) = auxE2;
% nodesEFML(2,:) = auxE;

%% Path from ElasticMap
nodesEMap = ELMAPnodes';
nodesEMap = flip(nodesEMap,2);
% for i=1:1:length(nodesEMap)
%     nodesEMap(1,i) = nodesEMap(1,i) - 76;
%     nodesEMap(2,i) = nodesEMap(2,i) - 10; 
% end
% auxEM = nodesEMap(1,:);
% auxEM2 = nodesEMap(2,:);
% nodesEMap(1,:) = auxEM2;
% nodesEMap(2,:) = auxEM;

%% Comparison metrics (save results)
% results = RAILMetrics(pathFMLmod,nodesEMap,nodesEFML,c);
% results.pathEFML = nodesEFML;
% results.pathEMap = nodesEMap;
% results.pathFML = pathFMLmod;

% task = 'Pressing3_3';
% save([task '_results.mat'], 'results')


%% Check the possible path 
% That part is for the ADAM robot
% [configuraciones,path_final] = CheckCollision(pathFML);