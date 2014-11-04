function logL = pointsource_pobs(par_arr, pobs,data)
% data =  vector of # cases that produces an observation of 1,2,...,N offspring
% par_arr(1) = R, par_arr(2) = k
% p_obs = probability of observing a case
% logL = log likelihood of data

max_size = 10;

tpdf = zeros(1,length(data));
for jj = 0:length(data);
    cond_L = zeros(1,max_size+1);
    if pobs == 1
        % Matlab uses different parameterization than R, k.
        cond_L = nbinpdf(jj,par_arr(2),1/(1+par_arr(1)/par_arr(2)));
    else
        for ii = jj:max_size;
            % cond_L(ii+1) = prob of observing jj cases out of ii cases;
            cond_L(ii+1) = nbinpdf(ii,par_arr(2),1/(1+par_arr(1)/par_arr(2)))*nchoosek(ii,jj)*pobs^jj*(1-pobs)^(ii-jj);
        end
    end
    tpdf(jj+1) = sum(cond_L);
end
% To get the observed probability distribution, you have to normalize by
% the chance that no cases in the cluster are seen.
prob0 = tpdf(1);
tpdf = tpdf(2:end)/(1-prob0);


logL = data*log(tpdf');

