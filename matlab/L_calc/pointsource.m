function logL = pointsource(par_arr, data)
% data =  vector of # cases that produces an observation of 1,2,...,N offspring

prob0 = nbinpdf(0,par_arr(2),1/(1+par_arr(1)/par_arr(2)));
tpdf = nbinpdf(1:length(data),par_arr(2),1/(1+par_arr(1)/par_arr(2)))/(1-prob0);

logL = data*log(tpdf');

