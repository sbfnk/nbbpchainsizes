function logL = singlesource(par_arr, data)
% data =  vector of # cases that produce 0,1,2,...,N offspring
% par_arr(1) = R, par_arr(2) = k
% logL = log likelihood of data

tpdf = nbinpdf([0:(length(data)-1)],par_arr(2),1/(1+par_arr(1)/par_arr(2)));

logL = data*log(tpdf');

