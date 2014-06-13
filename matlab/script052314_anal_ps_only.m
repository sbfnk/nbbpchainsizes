clear

MLres_mpx_ps = ML_compare('mpx_ps',[.5 .5],[.5 .5]);

mp1_arr = .04:.02:.7;
mp2_arr = .1:.02:.6;
cont_mpx_ps = contour_compare('mpx_ps',mp1_arr,mp2_arr);
r_arr = [.005 :.0025 : .5];
ci1D_mpx_ps = det_ci('mpx_ps',r_arr);
ci1D_mpx_ps = [r_arr;ci1D_mpx_ps];

save('data\script052314_mpx_ps')

num_bs = 1e4;

load('setup/MPX_DATA.mat')
num_hh = sum(mpx_all(:,1).*mpx_all(:,2));
num_ah = sum(mpx_ps)/(1-nbinpdf(0,MLres_mpx_ps(1,2),MLres_mpx_ps(1,2)/(MLres_mpx_ps(1,1)+MLres_mpx_ps(1,2))));
num_ah = round(num_ah);
two_r_mpx_ps_summary = perform_bs([MLres_mpx_ps(1,1:2) num_ah],[MLres_mpx_ps(1,3:4) num_hh],'animal_human', num_bs)
num_ah = sum(mpx_ps)/(1-nbinpdf(0,MLres_mpx_ps(1,2),MLres_mpx_ps(5,2)/(MLres_mpx_ps(5,1)+MLres_mpx_ps(5,2))));
num_ah = round(num_ah);
one_r_mpx_ps_summary = perform_bs([MLres_mpx_ps(5,1:2) num_ah],[MLres_mpx_ps(5,3:4) num_hh],'animal_human', num_bs)

save('data\script052314_mpx_ps')
