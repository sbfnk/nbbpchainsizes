function L = L_call(dataset_num,data,par_arr)

switch(dataset_num)
    case 1 %MPX - primary vs secondary
        L = multiplesource_onetype(par_arr(1:2),data.mpx_primary) + multiplesource_onetype(par_arr(3:4),data.mpx_secondary);
    case 2 %SPX - primary vs secondary
        L = multiplesource_onetype(par_arr(1:2),data.spx_primary) + multiplesource_onetype(par_arr(3:4),data.spx_secondary);
    case 3 %Measles - US vs Canada
        L = simple_chains(par_arr(1:2),data.usa_measles_chains) + mult_prim_chains(par_arr(1:2),data.usa_measles_clusters) + simple_chains(par_arr(3:4),data.can_measles_csd);
    case 4 %MPX - point source vs secondary transmission
        if par_arr(2) > 1e3
            L = -inf;
            return
        end
        %In terms of ML value, these two methods should be equivalent, but choosing the first in
        %order to be consistent with pobs analysis
        L = pointsource(par_arr(1:2),data.mpx_ps) + mult_prim_chains(par_arr(3:4),data.mpx_prim_csize);
%        L = pointsource(par_arr(1:2),data.mpx_ps) + multiplesource_onetype(par_arr(3:4),data.mpx_all);
    case 5 %MERS: time dependence
        L = 0;
        for ii = 1:size(data.mers_cluster,1)
            r = par_arr(1) + (par_arr(3)-par_arr(1))*(data.mers_cluster(ii,2)-182)/365;
            alpha = 1/par_arr(2) + (1/par_arr(4)-1/par_arr(2))*(data.mers_cluster(ii,2)-182)/365;
            k = 1/alpha;
%            [data.mers_cluster(ii,:) r k]
            tmp_dist = zeros(1,data.mers_cluster(ii,1));
            tmp_dist(end) = 1;
            L = L + simple_chains([r k], tmp_dist);
        end
    case 6 %MERS vs SARS
        L = simple_chains(par_arr(1:2),data.mers_clust_data) + singlesource(par_arr(3:4),data.sars_tran_data);
    case 7 % MERS - early vs late
        L = simple_chains(par_arr(1:2),data.mers_early_clust_data) + simple_chains(par_arr(3:4),data.mers_late_clust_data);
end
