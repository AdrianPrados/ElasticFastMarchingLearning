function opt_nodes = opt_map_F(stretch, bend, in_nodes, inds, constraints, F, Fstruct)
%optimize elastic map using F
[n_nodes, ~] = size(in_nodes);

%% setup E matrix
% Pulling forces??
E = zeros(n_nodes-1, n_nodes);
e1 = diag(-1*ones(n_nodes-1, 1));
e2 = diag(ones(n_nodes-1, 1));
E(:, 1:end-1) = E(:, 1:end-1) + e1;
E(:, 2:end) = E(:, 2:end) + e2;

%% setup R matrix
%Forces of each ribs??
R = zeros(n_nodes-2, n_nodes);
r1 = diag(ones(n_nodes-2, 1));
r2 = diag(-2*ones(n_nodes-2, 1));
R(:, 1:end-2) = R(:, 1:end-2) + r1;
R(:, 2:end-1) = R(:, 2:end-1) + r2;
R(:, 3:end) = R(:, 3:end) + r1;

%% set up optimization functions

    function cost = UF(x)
        cost = 0;
        for i=1:length(x)
            fx = interp1([Fstruct.axi(1) Fstruct.axi(2)],[0.5 Fstruct.sizeY],x(i, 1), 'linear','extrap');
            fy = interp1([Fstruct.axi(3) Fstruct.axi(4)],[0.5 Fstruct.sizeX],x(i, 2), 'linear','extrap');
            %disp([round(fx), round(fy)])
            cost = cost - F(min(max(round(fx), 1), Fstruct.sizeY), min(max(round(fy), 1), Fstruct.sizeX));
        end
        cost = cost / length(x);
        %disp(['UF ' num2str(cost)]) 
    end

    function cost = Ue(x)
        cost = stretch * norm(E*x)^2;
        %disp(['Ue ' num2str(cost)]) 
    end

    function cost = Ur(x)
        cost = bend * norm(R*x)^2;
        %disp(['Ur ' num2str(cost)]) 
    end

    function cost = consts_objective(x)
       cost = 0;
       for i = 1:length(inds)
           cost = cost + 1e9 * norm(x(inds(i), :) - constraints(i, :));
       end
       cost = 0;
    end

opt_fun_explicit = @(x)UF(x) + Ue(x) + Ur(x) + consts_objective(x);

%% solve optimization
options = optimset('MaxFunEvals',1e8);
opt_nodes = fminunc(opt_fun_explicit, in_nodes, options);
%opt_nodes = fminsearch(opt_fun_explicit, in_nodes, options);
end