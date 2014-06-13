path(path,'setup')
mpx_setup
spx_setup
mers_setup
path(path,'L_calc')

%%
clear

MLres_mpx = ML_compare('mpx',[2 .5],[.5 .5]);
MLres_spx = ML_compare('spx',[2 .5],[.5 .5]);

m1_arr = .05:.02:.7;
m2_arr = .05:.02:.7;
cont_mpx = contour_compare('mpx',m1_arr,m2_arr);
s1_arr = .5:.05:10;
s2_arr = .3:.05:2;
cont_spx = contour_compare('spx',s1_arr,s2_arr);
r_arr = [.2: .005 : .5];
ci1D_mpx = det_ci('mpx',r_arr);
ci1D_mpx = [r_arr;ci1D_mpx];
r_arr = [.5 :.005 : 3];
ci1D_spx = det_ci('spx',r_arr);
ci1D_spx = [r_arr;ci1D_spx];

%%
% clear
% load('data\script041813_mpx_spx')

data = load('setup\MPX_DATA');
r_arr = 0.01: .01 : .8;
net_res_mpx = zeros(length(r_arr),3);
for rr = 1:length(r_arr)
    r = r_arr(rr);
    [k,mL] = fminsearch(@(x) -L_call(1,data,[r x r*(1+1/x) (1+x)]),1);
    net_res_mpx(rr,:) = [r, k, -mL];
end
[net_r0k,mL] = fminsearch(@(x) -L_call(1,data,[x(1) x(2) x(1)*(1+1/x(2)) (1+x(2))]),[.5 1]);
net_r0k = [net_r0k (-mL-L_call(1,data,[MLres_mpx(1,1:4)]))];
[net_r0k_1Dmin] = fminsearch(@(x) abs(-mL -1.92 -L_call(1,data,[x(1) x(2) x(1)*(1+1/x(2)) (1+x(2))])),[net_r0k(1)*.8 net_r0k(2)]);
[net_r0k_1Dmax] = fminsearch(@(x) abs(-mL -1.92 -L_call(1,data,[x(1) x(2) x(1)*(1+1/x(2)) (1+x(2))])),[net_r0k(1)*1.2 net_r0k(2)]);
clear('data')

save('data\script011014_mpx_spx')
%%
clear

MLres_msls = ML_compare('msls',[2 .5],[.5 .5]);

ms1_arr = .3:.02:1.5;
ms2_arr = .3:.02:1.5;
cont_msls = contour_compare('msls',ms1_arr,ms2_arr);
r_arr = [.3 :.005 : 1.5];
ci1D_msls = det_ci('msls',r_arr);
ci1D_msls = [r_arr;ci1D_msls];

save('data\script011014_msls')

%%
clear

MLres_mpx_ps = ML_compare('mpx_ps',[.5 .5],[.5 .5]);

mp1_arr = .01:.002:.20;
mp2_arr = .1:.02:.6;
cont_mpx_ps = contour_compare('mpx_ps',mp1_arr,mp2_arr);
r_arr = [.005 :.0025 : .5];
ci1D_mpx_ps = det_ci('mpx_ps',r_arr);
ci1D_mpx_ps = [r_arr;ci1D_mpx_ps];

save('data\script011014_mpx_ps')
%%
clear

MLres_mers_time = ML_compare('mers_time',[.5 .5],[.5 .5]);

me1_arr = .3:.02:1.2;
me2_arr = .3:.02:1.2;
r_arr = [.3 :.005 : 1.5];

cont_mers_time = contour_compare('mers_time',me1_arr,me2_arr);
ci1D_mers_time = det_ci('mers_time',r_arr);
ci1D_mers_time = [r_arr;ci1D_mers_time];
% MLres_mers_time_trunc = ML_compare('mers_time_trunc',[.5 .5],[.5 .5]);
% cont_mers_time_truc = contour_compare('mers_time_trunc',me1_arr,me2_arr);
% ci1D_mers_time_trunc = det_ci('mers_time_trunc',r_arr);
% ci1D_mers_time_trunc = [r_arr;ci1D_mers_time_trunc];

save('data\script032814_mers')

MLres_mers_sars = ML_compare('mers_sars',[.5 .5],[.5 .5]);
cont_mers_sars = contour_compare('mers_sars',me1_arr,me2_arr);
ci1D_mers_sars = det_ci('mers_sars',r_arr);
ci1D_mers_sars = [r_arr;ci1D_mers_sars];

save('data\script032814_mers')
%%
clear
load('data\script032814_mers')

MLres_mers_cauch = ML_compare('mers_cauch',[.5 .5],[.5 .5]);
cont_mers_cauch = contour_compare('mers_cauch',me1_arr,me2_arr);
ci1D_mers_cauch = det_ci('mers_cauch',r_arr);
ci1D_mers_cauch = [r_arr;ci1D_mers_cauch];

save('data\script032814_mers')
