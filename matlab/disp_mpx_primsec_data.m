figure(11)
subplot_arr = [2 2 1; 2 2 2; 2 2 3; 2 2 4];
mpx_prim_arr = [];
mpx_sec_arr = [];

data = load('setup\MPX_DATA');
mpx_prim_pure = data.mpx_primary(data.mpx_primary(:,2) == 1,:);
mpx_sec_pure = data.mpx_secondary(data.mpx_secondary(:,2) == 1,:);

for ii = 0:2
    mpx_prim_arr(ii+1) = sum(mpx_prim_pure(mpx_prim_pure(:,3) == ii,1));
    mpx_sec_arr(ii+1) = sum(mpx_sec_pure(mpx_sec_pure(:,3) == ii,1));
end
mpx_prim_arr(end+1) = sum(mpx_prim_pure(:,1))- sum(mpx_prim_arr);
mpx_sec_arr(end+1) = sum(mpx_sec_pure(:,1))- sum(mpx_sec_arr);

load('data\script011014_mpx_spx')
prim_pdf = zeros(6,length(mpx_prim_arr));
sec_pdf = zeros(6,length(mpx_sec_arr));
for mm = 1:6
    prim_pdf(mm,:) = calc_cluster_pdf([MLres_mpx(mm,1) MLres_mpx(mm,2) 1 -1 1 1],length(mpx_prim_arr));
    prim_pdf(mm,end) = 1-sum(prim_pdf(mm,1:end-1));
    sec_pdf(mm,:) = calc_cluster_pdf([MLres_mpx(mm,3) MLres_mpx(mm,4) 1 -1 1 1],length(mpx_sec_arr));
    sec_pdf(mm,end) = 1-sum(sec_pdf(mm,1:end-1));
end

[prim_prob,prim_ci] = binofit(mpx_prim_arr,sum(mpx_prim_arr),.05);
[sec_prob,sec_ci] = binofit(mpx_sec_arr,sum(mpx_sec_arr),.05);
colors = {'b','g','m'};

for ss = 1:4
    subplot(subplot_arr(ss,1),subplot_arr(ss,2),subplot_arr(ss,3))
    if (ss <= 2)
        xlab = 'Primary case offspring';
        prob = prim_prob;
        prob_ci = prim_ci;
    else
        xlab = 'Secondary case offspring';
        prob = sec_prob;
        prob_ci = sec_ci;
    end
    errorbar(1:length(prob),prob,prob-prob_ci(:,1)',prob_ci(:,2)'-prob,'.','Color',[0 0 0 ],'MarkerSize',20,'LineWidth',1.5)
    hold on
    for mm = 1:3
        if (mod(ss,2) == 1)
            plot(1:length(prob),prim_pdf(mm,:)','Color',colors{mm},'Linewidth',3);
        else
            plot(1:length(prob),prim_pdf(mm+3,:)','--','Color',colors{mm},'Linewidth',3);
        end
    end
    xlim([0.8 4.2])
    ylim([5e-4  1.5])
    xlabel(xlab)
    set(gca,'FontSize',15)
    set(gca,'YScale','Log')
    set(gca,'XTick',1:4)
    set(gca,'XTickLabel',{'0','1','2','>2'})
    set(gca,'YTick',[.001 .01 .1 1])
    set(gca,'YTickLabel',{'0.001','0.01','0.1','1.0'})
    hold off
end
