function ps_pdf = calc_ps_pdf(mean_obs,k,num)

if (k<0)
    ps_pdf=zeros(1,num);
    return
end
mu = fzero(@(x) x - mean_obs*(1-nbinpdf(0,k,1/(1+x/k))), mean_obs - 1);
ps_pdf = nbinpdf([0:num],k,1/(1+mu/k));
ps_pdf = ps_pdf(2:end)/(1-ps_pdf(1));
%[sum(ps_pdf) sum(ps_pdf.*[1:num])]
