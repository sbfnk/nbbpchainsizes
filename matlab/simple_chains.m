function logL = simple_chains(par_arr, data)
% data =  vector of # cases that produce chains of size 1,2,3,4,..,N

if par_arr(1) <= 0 | par_arr(2) <= 0
    logL = -Inf;
    return;
else
    r0 = par_arr(1);
    k = par_arr(2);
    j = 1:length(data);
    log_pdf = gammaln(k*j+j-1)-gammaln(k*j)-gammaln(j+1)+(j-1)*log(r0/k)-(k*j+j-1)*log(1+r0/k);
end
logL = data*log_pdf';

