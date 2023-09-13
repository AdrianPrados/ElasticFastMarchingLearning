function [points,count,constrains]= kinesthetic_teaching (M, dataset)

points = [];
constrains=[];
button = 1;
count = 1;
button1 = 1;
count1=1;

s = warndlg('Introduce points of the trajectory by clicking on the map.To finish, press any other button than primary click.','Help','modal');
uiwait(s);
        

hold on;
imagesc(M'); 
axis image;
axis off;
colormap gray(256);
axis xy;
title('Obstacles Map');

imagesc(M')
if  ~numel(dataset)==0
 plot(dataset(1,:), dataset(2,:),'.b');
end
axis image;
axis off;
colormap gray(256);
axis xy;
title('Trajectory Map');

fx = size(M,1); % x size of the map
fy = size(M,2); % y size of the map

while button == 1
    [x, y, button] = ginput(1);
    x = round(x);
    y = round(y);
    if button == 1 
        if x > 0 && y > 0 && x < fx && y < fy && M(x,y)~=0 % no obstacle and it is in the range
            points(:,count) = [x; y];          
            count = count + 1;
            if count > 2 
                if points(:,count-1) == points(:,count-2) % two equal points, avoid to save two equal points in the same demo.
                    points(:,count-1) = []; 
                    count = count - 1;
                end
            end
        elseif x < 0 || y < 0 || x > fx || y > fy  % Restriction to dont use outside points
            l = errordlg('Point out of map bounds, please select another point.',...
            'Start point selection error','modal');
            uiwait(l);            
        elseif  M(x,y) == 0 % Point in an obstacle.
            l = errordlg('Point in an obstacle, please select another point.',...
            'Start point selection error','modal');
            uiwait(l);            
        end
    end
    plot(x,y,'.r');
end
s1 = warndlg('Introduce points of the constrains (don put it far away from demonstration).','Help','modal');
uiwait(s1);
while button1 == 1
    [x1, y1, button1] = ginput(1);
    x1 = round(x1);
    y1 = round(y1);
    if button1 == 1 
        if x1 > 0 && y1 > 0 && x1 < fx && y1 < fy && M(x1,y1)~=0 % no obstacle and it is in the range
            constrains(:,count1) = [x1; y1];          
            count1 = count1 + 1;
            if count1 > 2 
                if constrains(:,count1-1) == constrains(:,count1-2) % two equal points, avoid to save two equal points in the same demo.
                    constrains(:,count1-1) = []; 
                    count1 = count1 - 1;
                end
            end
        elseif x1 < 0 || y1 < 0 || x1 > fx || y1 > fy  % Restriction to dont use outside points
            l1 = errordlg('Point out of map bounds, please select another point.',...
            'Start point selection error','modal');
            uiwait(l1);            
        elseif  M(x1,y1) == 0 % Point in an obstacle.
            l1 = errordlg('Point in an obstacle, please select another point.',...
            'Start point selection error','modal');
            uiwait(l1);            
        end
    end
    plot(x1,y1,'.g');
end
