function  pobs_thresh = perform_pobs_sens(anal_type)

bs_summary = zeros(1,7);
tic
pobs_thresh = 1
distinct = 1;
while distinct == 1
    if strcmp(anal_type,'mpx_ps')
         pobs_res = ML_compare_pobs('mpx_ps',pobs_thresh)
    end
    aic_scores = 2*pobs_res(:,5)'-2*[4 3 2 3 2 1];
%    [~,best] = max(aic_scores);
%    bs_summary(best) = bs_summary(best) +1;
    if(max(aic_scores(1:3)) - 2 < max(aic_scores(4:6)))
        distinct = 0;
    else
        pobs_thresh = pobs_thresh - 0.01
    end
end

% ML_compare output:
% Each row has: R_A k_A R_B k_B log L
% row 1 % two r, two k
% row 2 % two r, one k
% row 3 % two r, zero k
% row 4 % one r, two k
% row 5 % one r, one k
% row 6 % one r, zero k
