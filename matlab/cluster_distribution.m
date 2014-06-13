function cluster_dist = cluster_distribution(r0,k,n_ps,k_ps,pobs,max_outbreak_size,num_sim)
% Generates disease outbreak data with or w/o point source distribution
% r0 = mean secondary infections per infected individual
% k = dispersion parameter of offspring distribution
% n_ps = mean of point sourse distribution
% k_ps = dispersion parameter of point source distribution
% (If k_ps = -1, then the # of index cases is always n_ps)
% pobs = Observiaton bias
%   pobs(1) = mode of bias [0 perfect surveillance, 1 i.i.d. bias
%                                 2 weighted cluster bias]
%   pobs(2) = individual level probability of observation
% max_g = maximum # of generations simulated
% num_sim = number of simulations
%

cluster_dist=zeros(1,2);

n = 0;

if~(k_ps == -1 || n_ps == 1)
    mu = fzero(@(x) x - n_ps*(1-nbinpdf(0,k_ps,1/(1+x/k_ps))), n_ps - 1);
end

while (n < num_sim)
    if(k_ps == -1 || n_ps == 1)
        popsize = n_ps;
    else
        popsize = 0;
        while (popsize == 0)
            popsize = gen_nb_dist(mu,k_ps,1,1);
        end
    end
    
    outbreak_size = popsize;
    while (popsize > 0 && outbreak_size < max_outbreak_size)
        nb_dist = gen_nb_dist(r0,k,popsize,1);
        popsize = sum(nb_dist);
        outbreak_size = outbreak_size + popsize;
    end
    if pobs(1) == 1 % i.i.d case
        outbreak_size = binornd(outbreak_size,pobs(2));
    elseif pobs(1) == 2 % weighted cluster case
        if(rand() < (1-pobs(2))^outbreak_size)
            outbreak_size = 0;
        end
    end
%     outbreak_size
    if (outbreak_size > 0)
        if (outbreak_size > size(cluster_dist,1));
            cluster_dist(outbreak_size,1) = 0;
        end
        cluster_dist(outbreak_size,1) = cluster_dist(outbreak_size,1)+ 1;
        if (popsize> 0)
            cluster_dist(outbreak_size,2) = cluster_dist(outbreak_size,2)+ 1;
        end
        n = n+1;
    end
end
