function  pobs_thresh = perform_pobs_sens(anal_type)
% Uses bootstrapping to determine if there is a value of p_obs that would
% change whether or not there is an insignificant difference in
% animal-human vs human-human transmission of monkeypox.
%
% It only makes sense to use this function if there is a statistically
% significant difference in observation when perfect surveillance is
% assumed (which was the case for early versions of our analysis, but no
% the later versions).  So this function is currently not useful.

bs_summary = zeros(1,7);
tic
pobs_thresh = 1
distinct = 1;
while distinct == 1
    if strcmp(anal_type,'mpx_ps')
         pobs_res = ML_compare_pobs('mpx_ps',pobs_thresh)
    end
    aic_scores = 2*pobs_res(:,5)'-2*[4 3 2 3 2 1];
    if(max(aic_scores(1:3)) - 2 < max(aic_scores(4:6)))
        distinct = 0;
    else
        pobs_thresh = pobs_thresh - 0.01
    end
end
