%% Msls - sensitivity to large cluster
clear

MLres_msls_trunc = ML_compare('msls_trunc',[2 .5],[.5 .5]);

save('data\script042814_msls_trunc')
%% Measles - bootsrap

clear
num_bs = 1e4;
load('data\script011014_msls')
load('setup/MSLS_DATA.mat')
MLres_msls = ML_compare('msls',[2 .5],[.5 .5]);
num_can = sum(can_measles_csd);
num_usa = size(usa_measles_clusters,1)+sum(usa_measles_chains);
two_r_msls_summary = perform_bs([MLres_msls(1,1:2) num_usa],[MLres_msls(1,3:4) num_can],'simple_chain', num_bs)
one_r_msls_summary = perform_bs([MLres_msls(5,1:2) num_usa],[MLres_msls(5,3:4) num_can],'simple_chain', num_bs)

save('data\script042814bs_msls')
%% Measles w/ largest chain censored - bootsrap

clear
num_bs = 1e4;
load('setup/MSLS_DATA.mat')
MLres_msls = ML_compare('msls',[2 .5],[.5 .5]);
num_can = sum(can_measles_csd);
num_usa = size(usa_measles_clusters,1)+sum(usa_measles_chains);
two_r_msls_cens_summary = perform_bs([MLres_msls(1,1:2) num_usa],[MLres_msls(1,3:4) num_can],'censor_large_chain', num_bs)
one_r_msls_cens_summary = perform_bs([MLres_msls(5,1:2) num_usa],[MLres_msls(5,3:4) num_can],'censor_large_chain', num_bs)

save('data\script042814bs_msls_cens')
%% MERS - bootstrap

clear
num_bs = 1e4;
load('data\script032814_mers')
load('setup/MERS_DATA.mat')
MLres_mers_cauch = ML_compare('mers_cauch',[.5 .5],[.5 .5]);
num_early = sum(mers_early_clust_data);
num_late = sum(mers_late_clust_data);
two_r_mers_summary = perform_bs([MLres_mers_cauch(1,1:2) num_early],[MLres_mers_cauch(1,3:4) num_late],'simple_chain', num_bs)
one_r_mers_summary = perform_bs([MLres_mers_cauch(5,1:2) num_early],[MLres_mers_cauch(5,3:4) num_late],'simple_chain', num_bs)

save('data\script042814bs_mers')
%% MPX - primary and seocndary - bootstrap
clear
num_bs = 1e4;
load('data\script011014_mpx_spx')

load('setup/MPX_DATA.mat')
MLres_mpx = ML_compare('mpx',[2 .5],[.5 .5]);
num_prim = sum(mpx_primary(:,1).*mpx_primary(:,2));
num_sec = sum(mpx_secondary(:,1).*mpx_secondary(:,2));
two_r_mpx_summary = perform_bs([MLres_mpx(1,1:2) num_prim],[MLres_mpx(1,3:4) num_sec],'simple_generation', num_bs)
one_r_mpx_summary = perform_bs([MLres_mpx(5,1:2) num_prim],[MLres_mpx(5,3:4) num_sec],'simple_generation', num_bs)

save('data\script042814bs_mpx_prim_sec')

%% SPX - primary and seocndary - bootstrap
clear
num_bs = 1e4;
load('data\script011014_mpx_spx')

load('setup/SPX_DATA.mat')
MLres_spx = ML_compare('spx',[2 .5],[.5 .5]);
num_prim = sum(spx_primary(:,1).*spx_primary(:,2));
num_sec = sum(spx_secondary(:,1).*spx_secondary(:,2));
two_r_spx_summary = perform_bs([MLres_spx(1,1:2) num_prim],[MLres_spx(1,3:4) num_sec],'simple_generation', num_bs)
one_r_spx_summary = perform_bs([MLres_spx(5,1:2) num_prim],[MLres_spx(5,3:4) num_sec],'simple_generation', num_bs)

save('data\script042814bs_spx')

%% MPX - animal vs human transmission - bootstrap
clear
num_bs = 1e4;
load('data\script052314_mpx_ps')

load('setup/MPX_DATA.mat')
num_hh = sum(mpx_all(:,1).*mpx_all(:,2));
num_ah = sum(mpx_ps)/(1-nbinpdf(0,MLres_mpx_ps(1,2),MLres_mpx_ps(1,2)/(MLres_mpx_ps(1,1)+MLres_mpx_ps(1,2))));
num_ah = round(num_ah);
two_r_mpx_ps_summary = perform_bs([MLres_mpx_ps(1,1:2) num_ah],[MLres_mpx_ps(1,3:4) num_hh],'animal_human', num_bs)
num_ah = sum(mpx_ps)/(1-nbinpdf(0,MLres_mpx_ps(1,2),MLres_mpx_ps(5,2)/(MLres_mpx_ps(5,1)+MLres_mpx_ps(5,2))));
num_ah = round(num_ah);
one_r_mpx_ps_summary = perform_bs([MLres_mpx_ps(5,1:2) num_ah],[MLres_mpx_ps(5,3:4) num_hh],'animal_human', num_bs)

save('data\script052314bs_mpx_ps')

%% 
% Monkeypox animal vs human transmission results - sensitivity to
% observation probability
clear
load('data\script052314bs_mpx_ps')
pobs_mxp_ps_thresh = perform_pobs_sens('mpx_ps')
'Saving'
save('data\script0523014bs_mpx_ps')
%%

% Displaying the result

'Msls - sensitivity to large cluster'
load('data\script042814_msls_trunc')
MLres_msls_trunc

'Measles - bootsrap'
load('data\script042814bs_msls')
two_r_msls_summary
one_r_msls_summary

'Measles w/ largest chain censored - bootsrap'
load('data\script042814bs_msls_cens')
two_r_msls_cens_summary
one_r_msls_cens_summary

'MERS'
load('data\script042814bs_mers')
two_r_mers_summary
one_r_mers_summary

'MPX - primary and seocndary'
load('data\script042814bs_mpx_prim_sec')
two_r_mpx_summary
one_r_mpx_summary


'SPX - primary and seocndary'
load('data\script042814bs_spx')
two_r_spx_summary
one_r_spx_summary


'MPX - animal vs human'
load('data\script052314bs_mpx_ps')
two_r_mpx_ps_summary
one_r_mpx_ps_summary
pobs_mxp_ps_thresh

