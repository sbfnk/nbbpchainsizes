function contour_arr = contour_compare(dataset,r_arr1,r_arr2)
% Computes the likelihood of various datasets (specified by 'dataset') overy a lattice of points
% specified by r_arr1, r_arr2 and returns the results.  This can then be
% used to plot contours
%
% As indicated below, contour_arr stores three contours, depending on
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
end

contour_arr = zeros(3,length(r_arr1),length(r_arr2));
for mm = 1:3
    for aa = 1:length(r_arr1)
        [mm aa length(r_arr1)]
        r1 = r_arr1(aa);
        for bb = 1:length(r_arr2)
            r2 = r_arr2(bb);
            switch mm
                case 1 % two r, two k
                    [~,mL] = fminsearch(@(x) -L_call(dataset_num,data,[r1 x(1) r2 x(2)]),[1 1]);
                case 2 % two r, one k
                    [~,mL] = fminsearch(@(x) -L_call(dataset_num,data,[r1 x(1) r2 x(1)]),[1]);
                case 3 % two r, zero k
                    mL = -L_call(dataset_num,data,[r1 1 r2 1]);
            end
            contour_arr(mm,aa,bb) = -mL;
        end
    end
end

for mm = 1:3
    contour_arr(mm,:,:) = contour_arr(mm,:,:) - max(max(contour_arr(mm,:,:)));
end

