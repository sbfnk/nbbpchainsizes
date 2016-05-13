function L = L_call_bs(data1,data2,par_arr,data_type)
% Calls for log likelihood used in the bootstrap calculations.

if (strcmp(data_type,'simple_chain') + strcmp(data_type,'censor_large_chain'))
    L = simple_chains(par_arr(1:2),data1) + simple_chains(par_arr(3:4),data2);
end
if strcmp(data_type,'simple_generation')
    L = singlesource(par_arr(1:2),data1) + singlesource(par_arr(3:4),data2);
end
if strcmp(data_type,'animal_human')
    L = pointsource(par_arr(1:2),data1) + singlesource(par_arr(3:4),data2);
end
