function clust_pdf = calc_cluster_pdf(par_arr,outbreak_size_limit)
% Calculates the expected pdf for the distribution of outbreak sizes.  The
% function will likely be modified often and incorporate various schemes for
% imperfect surveillance

r0 = par_arr(1);
k = par_arr(2);
pobs_mode = par_arr(5);
pobs = par_arr(6);

if(pobs_mode == 1 && pobs < 1)
    num_calc = min(100*outbreak_size_limit,1e4);
else
    num_calc = outbreak_size_limit;
end


% Outline of method:
% - Determine true pdf of chains (even with MNP > 1)
% - Adjust for imperfect observation

if par_arr(3) <= 1
    if r0 == 0
        true_clust_pdf = zeros(1,num_calc);
        true_clust_pdf(1) = 1;
    else
        j = 1:num_calc;
        log_real_clust_pdf = gammaln(k*j+j-1)-gammaln(k*j)-gammaln(j+1)+(j-1)*log(r0/k)-(k*j+j-1)*log(1+r0/k);
        true_clust_pdf = exp(log_real_clust_pdf);
    end
else
    ps_pdf = calc_ps_pdf(par_arr(3),par_arr(4),num_calc);
    if (r0 == 0)
        true_clust_pdf = ps_pdf;
    else
        ps_pdf = repmat(ps_pdf(1:min(num_calc,20)),num_calc,1);
        [m,j] = meshgrid(1:min(num_calc,20),1:num_calc);
        r_mj = log(m) - log(j) + gammaln(k*j+j-m) ...
            - gammaln(j-m+1) - gammaln(k*j) ...
            + (j-m)*log(r0/k) - (k*j+j-m)*log(1+r0/k);
    %     beta_mj = - log(j-1) + gammaln(m+k) + gammaln(k*j-k+j-m-1) ...
    %         - gammaln(j-m) - gammaln(m) - gammaln(k) - gammaln(k*j-k) ...
    %         + (j-1)*log(r0/k) - (k*j +j -1)*log(1+r0/k);
        r_mj = exp(r_mj).*ps_pdf;
        r_mj(~isfinite(r_mj)) = 0;
        true_clust_pdf = sum(r_mj');
    end

end

if (pobs_mode == 0 || pobs == 1)
    clust_pdf = true_clust_pdf;
    return;
end

j=1:num_calc;
prob0 = sum(exp(j*log(1-pobs)+log(true_clust_pdf)));
denominator = 1- prob0;
switch pobs_mode
    case 1 % i.i.d. case
        for jj = 1:outbreak_size_limit
            l = jj:length(true_clust_pdf);
            numerator(jj) = exp(jj*log(pobs/(1-pobs))-gammaln(jj+1))*sum(exp(log(true_clust_pdf(l))+l*log(1-pobs)+gammaln(l+1)-gammaln(l+1-jj)));
        end
        l = 1:length(true_clust_pdf);
        clust_pdf = numerator/denominator;
    case 2 % weighted cluster
        j = 1:length(true_clust_pdf);
        numerator = exp(log(true_clust_pdf(j))).*(1-(1-pobs).^j);
        clust_pdf = numerator(1:outbreak_size_limit)/denominator;     
end
