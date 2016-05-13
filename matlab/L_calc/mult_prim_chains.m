function logL = mult_prim_chains(par_arr, data)
% Data(1,:) = #occurences #primaries cluster-size
% e.g. A cluster of size 6 has 3 primary cases
%
% par_arr(1) = R, par_arr(2) = k
% logL = log likelihood of data

r0 = par_arr(1);
k = par_arr(2);
m = data(:,2);
j = data(:,3);


r_mj = log(m) - log(j) + gammaln(k*j+j-m) ...
    - gammaln(j-m+1) - gammaln(k*j) ...
    + (j-m)*log(r0/k) - (k*j+j-m)*log(1+r0/k);

logL = (r_mj)'*data(:,1);
