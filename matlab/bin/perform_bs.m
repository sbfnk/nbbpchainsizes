function  bs_summary = perform_bs(sim_arr1,sim_arr2,sim_type, num_bs)
%sim_arr = [R0 k num_clusters]
%
%bs_sum(1:6) = fraction of bootstraps favoring model 1:6
%bs_sum(7) = fraction of boostraps favoring two distinct Rs

bs_summary = zeros(1,7);
tic
for bb = 1:num_bs
    if mod(bb,20) == 0
        toc,tic;
        [bb num_bs]
    end
    if strcmp(sim_type,'simple_chain')
         bs_data1 = cluster_distribution(sim_arr1(1),sim_arr1(2),1,-1,[1 1],1e4,sim_arr1(3));
         bs_data1 = bs_data1(:,1)';
         bs_data2 = cluster_distribution(sim_arr2(1),sim_arr2(2),1,-1,[1 1],1e4,sim_arr2(3));
         bs_data2 = bs_data2(:,1)';
    end
    if strcmp(sim_type,'simple_generation')
         bs_data_raw = nbinrnd(sim_arr1(2),sim_arr1(2)/(sim_arr1(1)+sim_arr1(2)),1,sim_arr1(3));
         bs_data1 = histc(bs_data_raw,0:max(bs_data_raw));
         bs_data_raw = nbinrnd(sim_arr2(2),sim_arr2(2)/(sim_arr2(1)+sim_arr2(2)),1,sim_arr2(3));
         bs_data2 = histc(bs_data_raw,0:max(bs_data_raw));
    end
    if strcmp(sim_type,'animal_human')
         bs_data_raw = nbinrnd(sim_arr1(2),sim_arr1(2)/(sim_arr1(1)+sim_arr1(2)),1,sim_arr1(3));
         bs_data1 = histc(bs_data_raw,0:max(bs_data_raw));
         bs_data1 = bs_data1(2:end); % Truncate the unobserved infection dead-ends in animals
         bs_data_raw = nbinrnd(sim_arr2(2),sim_arr2(2)/(sim_arr2(1)+sim_arr2(2)),1,sim_arr2(3));
         bs_data2 = histc(bs_data_raw,0:max(bs_data_raw));
    end
    if strcmp(sim_type,'censor_large_chain')
         bs_data1 = cluster_distribution(sim_arr1(1),sim_arr1(2),1,-1,[1 1],1e4,sim_arr1(3));
         bs_data1 = bs_data1(:,1)';
         bs_data2 = cluster_distribution(sim_arr2(1),sim_arr2(2),1,-1,[1 1],1e4,sim_arr2(3));
         bs_data2 = bs_data2(:,1)';
         if (length(bs_data1) >= length(bs_data2))
             bs_data1 = bs_data1(1:(end-1));
         else
             bs_data2 = bs_data2(1:(end-1));
         end
    end
    bsrun_res = ML_compare_bs(bs_data1,bs_data2,sim_arr1(1:2),sim_arr2(1:2),sim_type);
    bsrun_res(:,5);
    aic_scores = 2*bsrun_res(:,5)'-2*[4 3 2 3 2 1];
    [~,best] = max(aic_scores);
    bs_summary(best) = bs_summary(best) +1;
    if(max(aic_scores(1:3)) - 2 > max(aic_scores(4:6)))
        bs_summary(7) = bs_summary(7) +1;
    end
end
bs_summary = bs_summary/num_bs;

% ML_compare output:
% Each row has: R_A k_A R_B k_B log L
% row 1 % two r, two k
% row 2 % two r, one k
% row 3 % two r, zero k
% row 4 % one r, two k
% row 5 % one r, one k
% row 6 % one r, zero k
