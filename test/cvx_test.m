%% Testing CVX notation
m = 20; n = 10; p = 4;
rng('default')
A = randn(m,n); b = randn(m,2);
C = randn(p,n); d = randn(p,2); e = rand;
constraints = {C * x == d, norm( x, Inf ) <= e};
cvx_begin
    variable x(n, 2)
    minimize( norm( A * x - b, 2 ) )
    subject to
        %constraints{1};
        %constraints{2};
        C * x == d
        norm( x, Inf ) <= e
cvx_end