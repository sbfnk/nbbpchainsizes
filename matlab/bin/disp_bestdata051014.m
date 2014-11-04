function disp_bestdata051014(data_name, best_models)
%data_name = 'mpx_primsec'
%data_name = 'mers'
%subplot_arr = [2 2 1; 2 2 2; 2 2 3; 2 2 4];
subplot_arr = [2 3 3; 2 3 3; 2 3 6; 2 3 6];
A_arr = [];
B_arr = [];

if strcmp(data_name,'mpx_primsec')
    data = load('setup\MPX_DATA');
    A_pure = data.mpx_primary(data.mpx_primary(:,2) == 1,:);
    B_pure = data.mpx_secondary(data.mpx_secondary(:,2) == 1,:);
    A_xlab = {'Primary case','offspring'};
    B_xlab = {'Secondary case','offspring'};
    load('data\script011014_mpx_spx')
    MLres = MLres_mpx;
    datatype = 'generation';
end

if strcmp(data_name,'mpx_ps')
    data = load('setup\MPX_DATA');
    A_pure = data.mpx_ps;
    B_pure = data.mpx_all(data.mpx_all(:,2) == 1,:);
    A_xlab = {'Animal-to-human','transmission'};
    B_xlab = {'Human-to-human','transmission'};
    load('data\script011014_mpx_ps')
    MLres = MLres_mpx_ps;
    datatype = 'animal_human';
end

if strcmp(data_name,'spx')
    data = load('setup\SPX_DATA');
    A_pure = data.spx_primary(data.spx_primary(:,2) == 1,:);
    B_pure = data.spx_secondary(data.spx_secondary(:,2) == 1,:);
    A_xlab = {'Primary case','offspring'};
    B_xlab = {'Secondary case','offspring'};
    load('data\script011014_mpx_spx')
    MLres = MLres_spx;
    datatype = 'generation';
end

if strcmp(data_name,'msls')
    data = load('setup\MSLS_DATA');
    A_pure =  data.usa_measles_chains;
    B_pure = data.can_measles_csd;
    A_xlab = {'United States','chain size'};
    B_xlab = {'Canada','chain size'};
    load('data\script011014_msls')
    MLres = MLres_msls;
    datatype = 'chain';
end

if strcmp(data_name,'mers')
    data = load('setup\MERS_DATA');
    A_pure =  data.mers_early_clust_data;
    B_pure = data.mers_late_clust_data;
    A_xlab = {'Pre-June 2013','chain size'};
    B_xlab = {'Post-June 2013','chain size'};
    load('data\script032814_mers')
    MLres = MLres_mers_cauch;
    datatype = 'chain';
end

if strcmp(datatype,'generation')
    for ii = 0:2
        A_arr(ii+1) = sum(A_pure(A_pure(:,3) == ii,1));
        B_arr(ii+1) = sum(B_pure(B_pure(:,3) == ii,1));
    end
    A_arr(end+1) = sum(A_pure(:,1))- sum(A_arr);
    B_arr(end+1) = sum(B_pure(:,1))- sum(B_arr);

    A_pdf = zeros(6,length(A_arr));
    B_pdf = zeros(6,length(B_arr));
    for mm = 1:6
        A_pdf(mm,:) = nbinpdf(0:length(A_arr)-1, MLres(mm,2),MLres(mm,2)/(MLres(mm,1)+MLres(mm,2)));
        A_pdf(mm,end) = 1-sum(A_pdf(mm,1:end-1));
        B_pdf(mm,:) = nbinpdf(0:length(B_arr)-1, MLres(mm,4),MLres(mm,4)/(MLres(mm,3)+MLres(mm,4)));
        B_pdf(mm,end) = 1-sum(B_pdf(mm,1:end-1));
    end
    
    xtick_labels = {'0','1','2','>2'};
end

if strcmp(datatype,'chain')
    A_arr(1:3) = A_pure(1:3);
    B_arr(1:3) = B_pure(1:3);
    A_arr(end+1) = sum(A_pure)- sum(A_arr)
    B_arr(end+1) = sum(B_pure)- sum(B_arr)

    A_pdf = zeros(6,length(A_arr));
    B_pdf = zeros(6,length(B_arr));
    for mm = 1:6
        A_pdf(mm,:) = calc_cluster_pdf([MLres(mm,1) MLres(mm,2) 1 -1 1 1],length(A_arr));
        A_pdf(mm,end) = 1-sum(A_pdf(mm,1:end-1));
        B_pdf(mm,:) = calc_cluster_pdf([MLres(mm,3) MLres(mm,4) 1 -1 1 1],length(A_arr));
        B_pdf(mm,end) = 1-sum(B_pdf(mm,1:end-1));
    end
    
    xtick_labels = {'1','2','3','>3'};
end

if strcmp(datatype,'animal_human')

    A_arr = A_pure(1:3);
    A_arr(4) = sum(A_pure) - sum(A_arr);
    for ii = 0:2
        B_arr(ii+1) = sum(B_pure(B_pure(:,3) == ii,1));
    end
    B_arr(end+1) = sum(B_pure(:,1))- sum(B_arr);

    A_pdf = zeros(6,4);
    B_pdf = zeros(6,length(B_arr));
    for mm = 1:6
        trueA_pdf = nbinpdf(0:3, MLres(mm,2),MLres(mm,2)/(MLres(mm,1)+MLres(mm,2)));
        A_pdf(mm,1:3) = trueA_pdf(2:end)/(1-trueA_pdf(1));
        A_pdf(mm,end) = 1-sum(A_pdf(mm,1:end-1));
        B_pdf(mm,:) = nbinpdf(0:length(B_arr)-1, MLres(mm,4),MLres(mm,4)/(MLres(mm,3)+MLres(mm,4)));
        B_pdf(mm,end) = 1-sum(B_pdf(mm,1:end-1));
    end
    
    xtick_labels = {'1','2','3','>3'};
    xtick_labels_B = {'0','1','2','>2'};
end

colors = {'b','g','m','b--','g--','m--'};
for ss = 1:4
    subplot(subplot_arr(ss,1),subplot_arr(ss,2),subplot_arr(ss,3))
    if (ss == 1)
        xlab = A_xlab;
        [prob,prob_ci] = binofit(A_arr,sum(A_arr),.05);
        prob(prob==0) = 1e-10;
        prob_ci(prob_ci==0) = 1e-10;
        est_pdf = A_pdf;
    elseif (ss == 3)
        xlab = B_xlab;
        [prob,prob_ci] = binofit(B_arr,sum(B_arr),.05);
        prob(prob==0) = 1e-10;
        prob_ci(prob_ci==0) = 1e-10;
        est_pdf = B_pdf;
    end
    for bb = 1:length(best_models)
        plot(1:length(prob),est_pdf(best_models(bb),:)',colors{best_models(bb)},'Linewidth',3);
        hold on
    end
    errorbar(1:length(prob),prob,prob-prob_ci(:,1)',prob_ci(:,2)'-prob,'.','Color',[0 0 0 ],'MarkerSize',20,'LineWidth',1.5)
    xlim([0.8 4.2])
    ylim([5e-4  1])
    xlabel(xlab)
    ylabel({'Density'})
    set(gca,'FontSize',16)
%    set(gca,'YScale','Log')
    set(gca,'XTick',1:4)
    
    if (strcmp(datatype,'animal_human') && ss > 2)
        set(gca,'XTickLabel',xtick_labels_B)
    else
        set(gca,'XTickLabel',xtick_labels)
    end
    set(gca,'YTick',[.2 .6 1])
    set(gca,'YTickLabel',{'0.2','0.6','1.0'})
%     set(gca,'YTick',[.2 .4 .6 .8 1])
%     set(gca,'YTickLabel',{'0.2','0.4','0.6','0.8','1.0'})
%     set(gca,'YTick',[.001 .01 .1 1])
%     set(gca,'YTickLabel',{'0.001','0.01','0.1','1.0'})

    if (ss == 1)
        labelg(.6,0.05,2,16)
    elseif (ss == 3)
        labelg(.6,0.05,3,16)
    end
%     hold off
end
