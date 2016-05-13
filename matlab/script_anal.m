% Setup
path(path,'setup')
path(path,'L_calc')
path(path,'bin')
mpx_setup
spx_setup
mers_setup
msls_setup

%%
% Model comparison and contour analysis of mpx and spx data setes
% (comparing primary and secondary transmission)

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
% This section does the analysis for the randomn network model (mentioned in the text) relating primary and
% secondary transmission

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
% Model comparison and contour analysis of measles data sets
% (comparing USA and Canada)

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
% Model comparison and contour analysis of monkeypos
% (comparing animal-human and human-human transmission)

MLres_mpx_ps = ML_compare('mpx_ps',[.5 .5],[.5 .5]);

mp1_arr = .04:.02:.7;
mp2_arr = .1:.02:.6;
cont_mpx_ps = contour_compare('mpx_ps',mp1_arr,mp2_arr);
r_arr = [.005 :.0025 : .5];
ci1D_mpx_ps = det_ci('mpx_ps',r_arr);
ci1D_mpx_ps = [r_arr;ci1D_mpx_ps];

save('data\script052314_mpx_ps')

%%
clear
% Model comparison and contour analysis of time-dependence of MERS
% transmisson (time is treated continuosly here.  These calculations aren't
% used in the paper).

MLres_mers_time = ML_compare('mers_time',[.5 .5],[.5 .5]);

me1_arr = .3:.02:1.5;
me2_arr = .02:.02:2;
r_arr = [.3 :.005 : 1.5];

cont_mers_time = contour_compare('mers_time',me1_arr,me2_arr);
ci1D_mers_time = det_ci('mers_time',r_arr);
ci1D_mers_time = [r_arr;ci1D_mers_time];

save('data\script032814_mers')

% Model comparison and contour analysis of MERS vs SARS (not shown in
% manuscript but including it anyways)
MLres_mers_sars = ML_compare('mers_sars',[.5 .5],[.5 .5]);
cont_mers_sars = contour_compare('mers_sars',me1_arr,me2_arr);
ci1D_mers_sars = det_ci('mers_sars',r_arr);
ci1D_mers_sars = [r_arr;ci1D_mers_sars];

save('data\script032814_mers')
% Model comparison and contour analysis of early vs late MERS.  This is the
% analysis shown in the paper.

MLres_mers_cauch = ML_compare('mers_cauch',[.5 .5],[.5 .5]);
cont_mers_cauch = contour_compare('mers_cauch',me1_arr,me2_arr);
ci1D_mers_cauch = det_ci('mers_cauch',r_arr);
ci1D_mers_cauch = [r_arr;ci1D_mers_cauch];

save('data\script032814_mers')
