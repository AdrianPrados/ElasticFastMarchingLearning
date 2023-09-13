function [results] = RAILMetrics(FML,ElMap,EFML,m)
    %% Frechet
    
    disp('Frechet FML')
    frFMLmat = [];
    angFMLmat = [];
    for i=1:1:length(m)
        %Frechet
        path1 = FML/100;
        path2 =m{1,i}/100;
        frFML = frechet(path1',path2');
        results.frechetFML{i} = frFML;
        frFMLmat = [frFMLmat frFML];
        %Angular
        len1 = length(path1);
        len2 = length(path2);
        if len1 < len2
            x_prueba = resample(path1(1,:),len2,len1);
            y_prueba = resample(path1(2,:),len2,len1);
            z_prueba = resample(path1(3,:),len2,len1);
        else
            x_prueba = resample(path1(1,:),len1,len2);
            y_prueba = resample(path1(2,:),len1,len2);
            z_prueba = resample(path1(3,:),len1,len2);
            
        end
        
        pathNormalized = [x_prueba;y_prueba;z_prueba];
        disp('Angular')
        results.angFML{i}=angular_similarity(pathNormalized',path2');
        angFMLmat = [angFMLmat angular_similarity(pathNormalized',path2')];
        % Jerk
        results.jerkFML{i}=calc_jerk(path1');
%         calc_jerk(path2')
        

    end
    results.meanfrFML = mean(frFMLmat);
    results.meanangFML = mean(angFMLmat);

    disp('Frechet ELMAP')
    frEMapmat = [];
    angEMapmat = [];
    for i=1:1:length(m)
        path1 = ElMap/100;
        path2 =m{1,i}/100;
        frElMap = frechet(path1',path2');
        results.frechetElMap{i} = frElMap ;
        frEMapmat = [frEMapmat frElMap];
        %Angular
        len1 = length(path1);
        len2 = length(path2);
        if len1 < len2
            x_prueba = resample(path1(1,:),len2,len1);
            y_prueba = resample(path1(2,:),len2,len1);
            z_prueba = resample(path1(3,:),len2,len1);
        else
            x_prueba = resample(path1(1,:),len1,len2);
            y_prueba = resample(path1(2,:),len1,len2);
            z_prueba = resample(path1(3,:),len1,len2);
            
        end
        
        pathNormalized = [x_prueba;y_prueba;z_prueba];
        disp('Angular')
        results.angElMap{i}=angular_similarity(pathNormalized',path2');
        angEMapmat = [angEMapmat angular_similarity(pathNormalized',path2')];
        % Jerk
        results.jerkElMap{i}=calc_jerk(path1');
%         calc_jerk(path2')
    end
    results.meanfrEMap = mean(frEMapmat);
    results.meanangEMap = mean(angEMapmat);

    disp('Frechet ElasticFML')
    frEFMLmat = [];
    angEFMLmat = [];
    for i=1:1:length(m)
        path1 = EFML/100;
        path2 =m{1,i}/100;
        frEFML = frechet(path1',path2');
        results.frechetEFML{i} = frEFML;
        frEFMLmat = [frEFMLmat frEFML];
        %Angular
        len1 = length(path1);
        len2 = length(path2);
        if len1 < len2
            x_prueba = resample(path1(1,:),len2,len1);
            y_prueba = resample(path1(2,:),len2,len1);
            z_prueba = resample(path1(3,:),len2,len1);
        else
            x_prueba = resample(path1(1,:),len1,len2);
            y_prueba = resample(path1(2,:),len1,len2);
            z_prueba = resample(path1(3,:),len1,len2);
            
        end
        
        pathNormalized = [x_prueba;y_prueba;z_prueba];
        disp('Angular')
        results.angEFML{i}=angular_similarity(pathNormalized',path2');
        angEFMLmat = [angEFMLmat angular_similarity(pathNormalized',path2')];
        % Jerk
        results.jerkEFML{i}=calc_jerk(path1');
%         calc_jerk(path2')
    end
    results.meanfrEFML = mean(frEFMLmat);
    results.meanangEFML = mean(angEFMLmat);
end

