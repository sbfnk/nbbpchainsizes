function logL = pointsource(par_arr, data)
% data =  vector of # point-source exposures that produces an observation
% of 1,2,...,N primary cases
%
% par_arr(1) = R, par_arr(2) = k
% logL = log likelihood of data

% We'll normalize against the chance of seeing no primary cases
prob0 = nbinpdf(0,par_arr(2),1/(1+par_arr(1)/par_arr(2)));
tpdf = nbinpdf(1:length(data),par_arr(2),1/(1+par_arr(1)/par_arr(2)))/(1-prob0);

logL = data*log(tpdf');

