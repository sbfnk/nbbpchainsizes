function logL = multiplesource_onetype(par_arr, data)
% Data(1,:) = #occurences #sources #offspring

r0 = par_arr(1);
k = par_arr(2);
i = data(:,2);
j = data(:,3);
logL = (gammaln(k*i+j)-gammaln(k*i)-gammaln(j+1) ...
    +j*log(r0/k)-(k*i+j)*log(1+ r0/k))'*data(:,1);


