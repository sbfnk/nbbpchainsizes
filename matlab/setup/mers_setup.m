clear;

% From Table S4 of Cauchemez et al. Lancet ID 2013
% Data(1,:) = size of cluster; timing of cluster
mers_cluster = [ ...

11 1 3 2 1
7 - 1
13 - 1
26-1

1 - 16
3 - 1
4 - 1
5 - 1
% Data(1) = # size 1 clusters, Data(2) = # size 2 clusters, etc
mers_clust_data = [27 1 4 3 2 0 1 0 0 0 0 0 1];
mers_clust_data(26) = 1

% 'Early' is before June 1, 2013 - only because that is a distinction that
% Cauchemez et al made in their Lancet ID (2013) paper.  It is unclear that
% this data has any particular significance

mers_early_clust_data = histc(mers_cluster(mers_cluster(:,2)<=366+150),1:26)'
mers_late_clust_data = histc(mers_cluster(mers_cluster(:,2)>366+150,1),1:max(mers_cluster(mers_cluster(:,2)>366+150,1)))'

% From Appendix of: Epidemiologic Clues to SARS Origin in China (EID 2004)
% The following are the transmission data for 9 clusters 26 patients
% Data(1) = # of dead ends, Data(2) = # who infected one, etc
sars_tran_data = [20 1 3 1 0 0 0 1]
% Note #1: main paper says that seven index cases caused 2*,9,1,4,8,2 and 3 cases
% respectively
% The transmissoin tree breakddown of the 9 clusters in the appndix is"
% 2 2 0 0 0 (* cluster corrsponding to the * of above)
% 0
% 3 0 0 0
% 0
% 0
% 0
% 0
% 1 0
% 7 2 0 0 0 0 0 0 0 0


save ('setup\MERS_DATA')