function nb_dist =gen_nb_dist(r0,k,m,n)
% Adapted from Jamie Lloyd-Smith's jnbinrnd
% r0 = mean
% k = dispersion parameter as defined in Jamie's '05 paper
%   k =1 --> geometric dist w/ Var = ro(r0 +1)
%   k = Inf --> Poisson dist w/ Var = r0

nb_dist = poissrnd(gamrnd(k,r0/k,m,n));

% Note that matlab uses r,p for the negative binomial parameters where r is
% 'k' and p is 'k/(r0+k)'