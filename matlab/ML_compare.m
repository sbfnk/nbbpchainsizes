function optres_arr = ML_compare(dataset,init_par1,init_par2)

mean_r = (init_par1(1) + init_par2(1))/2;
mean_k = sqrt(init_par1(2)*init_par2(2));

if strcmp(dataset,'mpx')
    dataset_num = 1;
    data = load('setup\MPX_DATA');
elseif strcmp(dataset,'spx')
    dataset_num = 2;
    data = load('setup\SPX_DATA');
elseif strcmp(dataset,'msls')
    dataset_num = 3;
    data = load('setup\MSLS_DATA');
elseif strcmp(dataset,'mpx_ps')
    dataset_num = 4;
    data = load('setup\MPX_DATA');
elseif strcmp(dataset,'mers_time')
    dataset_num = 5;
    data = load('setup\MERS_DATA');
% elseif strcmp(dataset,'mers_time_trunc')
%     dataset_num = 5;
%     data = load('setup\MERS_DATA');
%     data.mers_cluster=data.mers_cluster(2:end,:);
elseif strcmp(dataset,'mers_sars')
    dataset_num = 6;
    data = load('setup\MERS_DATA');
elseif strcmp(dataset,'mers_cauch')
    dataset_num = 7;
    data = load('setup\MERS_DATA');
elseif strcmp(dataset,'msls_trunc')
    dataset_num = 3;
    data = load('setup\MSLS_DATA');
    data.can_measles_csd = data.can_measles_csd(1:30)
end

optres_arr = zeros(6,5);
for mm = 1:6
    switch mm
        case 1 % two r, two k
            [opt_val,mL] = fminsearch(@(x) -L_call(dataset_num,data,[x(1) x(2) x(3) x(4)]),[init_par1 init_par2]);
        case 2 % two r, one k
            [x,mL] = fminsearch(@(x) -L_call(dataset_num,data,[x(1) x(2) x(3) x(2)]),[init_par1(1) mean_k init_par2(1)]);
            opt_val = [x x(2)];
        case 3 % two r, zero k
            [x,mL] = fminsearch(@(x) -L_call(dataset_num,data,[x(1) 1 x(2) 1]),[init_par1(1) init_par2(1)]);
            opt_val = [x(1) 1 x(2) 1];
        case 4 % one r, two k
            [x,mL] = fminsearch(@(x) -L_call(dataset_num,data,[x(1) x(2) x(1) x(3)]),[mean_r init_par1(2) init_par2(2)]);
            opt_val = [x(1) x(2) x(1) x(3)];
        case 5 % one r, one k
            [x,mL] = fminsearch(@(x) -L_call(dataset_num,data,[x(1) x(2) x(1) x(2)]),[mean_r mean_k]);
            opt_val = [x(1) x(2) x(1) x(2)];
        case 6 % one r, zero k
            [x,mL] = fminsearch(@(x) -L_call(dataset_num,data,[x(1) 1 x(1) 1]),[mean_r]);
            opt_val = [x(1) 1 x(1) 1];
    end
    optres_arr(mm,1:4) = opt_val;
    optres_arr(mm,5) = -mL;
end
%optres_arr(:,5) = optres_arr(:,5)-optres_arr(1,5);