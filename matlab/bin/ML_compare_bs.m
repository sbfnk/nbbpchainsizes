function optres_arr = ML_compare_bs(bs_data1,bs_data2,init_par1,init_par2,sim_type)
% Model comparison for parametric bootstrapped data.  The outline is
% similar to the ML_compare function

mean_r = (init_par1(1) + init_par2(1))/2;
mean_k = sqrt(init_par1(2)*init_par2(2));

optres_arr = zeros(6,5);
for mm = 1:6
%L_call_bs(data1,data2,par_arr,data_type)
switch mm
        case 1 % two r, two k
            [opt_val,mL] = fminsearch(@(x) -L_call_bs(bs_data1,bs_data2,[x(1) x(2) x(3) x(4)],sim_type),[init_par1 init_par2]);
        case 2 % two r, one k
            [x,mL] = fminsearch(@(x) -L_call_bs(bs_data1,bs_data2,[x(1) x(2) x(3) x(2)],sim_type),[init_par1(1) mean_k init_par2(1)]);
            opt_val = [x x(2)];
        case 3 % two r, zero k
            [x,mL] = fminsearch(@(x) -L_call_bs(bs_data1,bs_data2,[x(1) 1 x(2) 1],sim_type),[init_par1(1) init_par2(1)]);
            opt_val = [x(1) 1 x(2) 1];
        case 4 % one r, two k
            [x,mL] = fminsearch(@(x) -L_call_bs(bs_data1,bs_data2,[x(1) x(2) x(1) x(3)],sim_type),[mean_r init_par1(2) init_par2(2)]);
            opt_val = [x(1) x(2) x(1) x(3)];
        case 5 % one r, one k
            [x,mL] = fminsearch(@(x) -L_call_bs(bs_data1,bs_data2,[x(1) x(2) x(1) x(2)],sim_type),[mean_r mean_k]);
            opt_val = [x(1) x(2) x(1) x(2)];
        case 6 % one r, zero k
            [x,mL] = fminsearch(@(x) -L_call_bs(bs_data1,bs_data2,[x(1) 1 x(1) 1],sim_type),[mean_r]);
            opt_val = [x(1) 1 x(1) 1];
    end
    optres_arr(mm,1:4) = opt_val;
    optres_arr(mm,5) = -mL;
end
