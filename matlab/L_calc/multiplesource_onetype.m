function logL = multiplesource_onetype(par_arr, data)
% Data(1,:) = #occurences #sources #offspring
% e.g. 3 cases produce 2 cases in the next generation
%
% par_arr(1) = R, par_arr(2) = k
% logL = log likelihood of data

r0 = par_arr(1);
k = par_arr(2);
i = data(:,2);
j = data(:,3);
logL = (gammaln(k*i+j)-gammaln(k*i)-gammaln(j+1) ...
    +j*log(r0/k)-(k*i+j)*log(1+ r0/k))'*data(:,1);


