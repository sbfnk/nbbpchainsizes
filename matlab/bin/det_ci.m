function ci_arr = det_ci(dataset,r_arr)
% Computes the likelihood of various datasets (specified by 'dataset') when
% a single value of r is assumed for the two populations being compared
% (specified by r_arr) and returns the results.  This is used to plot the
% 1-D confindence intervals in the figures.
%
% As indicated below, ci_arr stores three arrays, depending on
% whether k is assumed to be 1, a single value of k is used or two values
% of k are used.

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
elseif strcmp(dataset,'mers_sars')
    dataset_num = 6;
    data = load('setup\MERS_DATA');
elseif strcmp(dataset,'mers_cauch')
    dataset_num = 7;
    data = load('setup\MERS_DATA');
end

ci_arr = zeros(3,length(r_arr));
for rr = 1:length(r_arr)
    r = r_arr(rr);
    for mm = 1:3
        switch mm
            case 1 % one r, two k
                [~,mL] = fminsearch(@(x) -L_call(dataset_num,data,[r x(1) r x(2)]),[1 1]);
            case 2 % one r, one k
                [~,mL] = fminsearch(@(x) -L_call(dataset_num,data,[r x(1) r x(1)]),[1]);
            case 3 % one r, zero k
                mL = -L_call(dataset_num,data,[r 1 r 1]);
        end
        ci_arr(mm,rr) = -mL;
    end
end
for mm = 1:3
    ci_arr(mm,:) = ci_arr(mm,:) - max(ci_arr(mm,:));
end