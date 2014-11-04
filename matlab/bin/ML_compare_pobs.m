function optres_arr = ML_compare_pobs(dataset,pobs)

if strcmp(dataset,'mpx_ps')
    dataset_num = 4;
    data = load('setup\MPX_DATA');
    init_par1 = [.5 .5];
    init_par2 = [.5 .5];
    mean_r = .5;
    mean_k = .5;
end


optres_arr = zeros(6,5);
for mm = 1:6
    switch mm
        case 1 % two r, two k
            [opt_val,mL] = fminsearch(@(x) -L_call_pobs(dataset_num,data,[x(1) x(2) x(3) x(4)],pobs),[init_par1 init_par2]);
        case 2 % two r, one k
            [x,mL] = fminsearch(@(x) -L_call_pobs(dataset_num,data,[x(1) x(2) x(3) x(2)],pobs),[init_par1(1) mean_k init_par2(1)]);
            opt_val = [x x(2)];
        case 3 % two r, zero k
            [x,mL] = fminsearch(@(x) -L_call_pobs(dataset_num,data,[x(1) 1 x(2) 1],pobs),[init_par1(1) init_par2(1)]);
            opt_val = [x(1) 1 x(2) 1];
        case 4 % one r, two k
            [x,mL] = fminsearch(@(x) -L_call_pobs(dataset_num,data,[x(1) x(2) x(1) x(3)],pobs),[mean_r init_par1(2) init_par2(2)]);
            opt_val = [x(1) x(2) x(1) x(3)];
        case 5 % one r, one k
            [x,mL] = fminsearch(@(x) -L_call_pobs(dataset_num,data,[x(1) x(2) x(1) x(2)],pobs),[mean_r mean_k]);
            opt_val = [x(1) x(2) x(1) x(2)];
        case 6 % one r, zero k
            [x,mL] = fminsearch(@(x) -L_call_pobs(dataset_num,data,[x(1) 1 x(1) 1],pobs),[mean_r]);
            opt_val = [x(1) 1 x(1) 1];
    end
    optres_arr(mm,1:4) = opt_val;
    optres_arr(mm,5) = -mL;
end

[~,best_mm] = max(optres_arr(:,5)'-[4 3 3 2 2 1]) 
meth_str = {'None','$k_A=k_B$','$k_A=k_B=1$','$R_A = R_B$','$R_A = R_B, k_A=k_B$','$R_A = R_B, k_A=k_B=1$'};
MLres = optres_arr;
best_L= 2*MLres(best_mm,5);
npar = [4 3 2 3 2 1];
for mm = [6 5 3 4 2 1]
    mtext = round(10*MLres(mm,:))/10;
    mtext(6) = -2*MLres(mm,5)+best_L+2*npar(mm)-2*npar(best_mm);
    mtext(6) = round(10*mtext(6))/10;
    strcat([meth_str{mm},' & ',num2str(npar(mm)),' & ',num2str(mtext(1)),' & ',num2str(mtext(2)),' & ',num2str(mtext(3)),' & ',num2str(mtext(4)),' & ',num2str(mtext(5)),' & ',num2str(mtext(6))])
end

%optres_arr(:,5) = optres_arr(:,5)-optres_arr(1,5);