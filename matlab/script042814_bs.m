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
%% MERS

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
%% MPX - primary and seocndary
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

%% SPX - primary and seocndary
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

%% MPX - animal vs human
clear
num_bs = 1e4;
load('data\script011014_mpx_ps')

load('setup/MPX_DATA.mat')
MLres_mpx_ps = ML_compare('mpx_ps',[2 .5],[.5 .5]);
num_hh = sum(mpx_all(:,1).*mpx_all(:,2));
num_ah = sum(mpx_ps)/(1-nbinpdf(0,MLres_mpx_ps(1,2),MLres_mpx_ps(1,2)/(MLres_mpx_ps(1,1)+MLres_mpx_ps(1,2))));
num_ah = round(num_ah);
two_r_mpx_ps_summary = perform_bs([MLres_mpx_ps(1,1:2) num_ah],[MLres_mpx_ps(1,3:4) num_hh],'animal_human', num_bs)
num_ah = sum(mpx_ps)/(1-nbinpdf(0,MLres_mpx_ps(1,2),MLres_mpx_ps(5,2)/(MLres_mpx_ps(5,1)+MLres_mpx_ps(5,2))));
num_ah = round(num_ah);
one_r_mpx_ps_summary = perform_bs([MLres_mpx_ps(5,1:2) num_ah],[MLres_mpx_ps(5,3:4) num_hh],'animal_human', num_bs)

save('data\script0428014bs_mpx_ps')
%%
clear
load('data\script0428014bs_mpx_ps')
pobs_mxp_ps_thresh = perform_pobs_sens('mpx_ps')
'Saving'
save('data\script0523014bs_mpx_ps')
%%

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
load('data\script0428014bs_mpx_ps')
two_r_mpx_ps_summary
one_r_mpx_ps_summary
pobs_mxp_ps_thresh

% Results 043014
%
% Msls - sensitivity to large cluster
% MLres_msls_trunc =
%     0.5060    0.3227    0.5966    0.2707 -246.6693
%     0.5059    0.3080    0.5966    0.3080 -246.6994
%     0.5059    1.0000    0.5967    1.0000 -251.1747
%     0.5275    0.3194    0.5275    0.2623 -246.8951
%     0.5297    0.3034    0.5297    0.3034 -246.9389
%     0.5297    1.0000    0.5297    1.0000 -251.6056
%     
% Measles - bootsrap
% two_r_msls_summary =
%     0.1364    0.5516    0.0246    0.0745    0.2059    0.0070    0.5460
% one_r_msls_summary =
%     0.0265    0.1356    0.0016    0.1350    0.6992    0.0021    0.0489
% 
% Measles w/ largest chain censored - bootsrap
% two_r_msls_cens_summary =
%     0.0656    0.3477    0.0379    0.1270    0.3927    0.0291    0.2665
% one_r_msls_cens_summary =
%     0.0187    0.1067    0.0034    0.1287    0.7380    0.0045    0.0353
%     
% MERS
% two_r_mers_summary =
%     0.0003    0.1641    0.4432    0.2506    0.0175    0.1243    0.3760
% one_r_mers_summary =
%     0.0022    0.0159    0.1710    0.0677    0.1338    0.6094    0.0618
%     
% MPX - primary and seocndary
% two_r_mpx_summary =
%     0.0801    0.1353    0.0436    0.2188    0.3848    0.1374    0.0935
% one_r_mpx_summary =
%     0.0230    0.1054    0.0361    0.1296    0.5892    0.1167    0.0479
%     
% SPX - primary and seocndary
% two_r_spx_summary =
%     0.9818         0         0    0.0182         0         0    0.9406
% one_r_spx_summary =
%     0.0380    0.1350         0    0.1205    0.7065         0    0.0508
% 
% MPX - animal vs human
% two_r_mpx_ps_summary =
%     0.0004    0.8346    0.1634    0.0015    0.0001         0    0.9800
% one_r_mpx_ps_summary =
%     0.0032    0.0461    0.1334    0.0268    0.3278    0.4627    0.0241
% pobs_mxp_ps_thresh =
%     0.4400
