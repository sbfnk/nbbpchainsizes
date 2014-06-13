% colors = {'b','g','r','m','c','k'}
colors = {'b','g','m','b','g','m'}
for ss = 5:7
    figure(ss),clf;
    if ss == 2
        h1 = figure(2),clf;
    end
    hold on;
    switch(ss)
        case 1
            'mpx'
            load('data\script011014_mpx_spx')
            x_arr = m1_arr;
            y_arr = m2_arr;
            cont_data = cont_mpx;
            MLres = MLres_mpx;
            ci1D = ci1D_mpx;
%             xr = [.101 .6];
%             yr = [.1 .6];
            xr = [.001 .6];
            yr = [0 .6];
            loc = 'NorthWest'
            xlab = 'R - Primary';
            ylab = 'R - Secondary';
%             o_app = 'mpx'
            best_mm = 5;
        case 2
            'spx'
            load('data\script011014_mpx_spx')
            x_arr = s1_arr;
            y_arr = s2_arr;
            cont_data = cont_spx;
            MLres = MLres_spx;
            ci1D = ci1D_spx;
            xr = [0.1 6];
            yr = [0 6];
            loc = 'East'
            xlab = 'R - Primary';
            ylab = 'R - Secondary';
%             o_app = 'spx'
            best_mm = 1;
        case 3
            'msls'
            load('data\script011014_msls')
            x_arr = ms1_arr;
            y_arr = ms2_arr;
            cont_data = cont_msls;
            MLres = MLres_msls;
            ci1D = ci1D_msls;
            xr = [.31 1.3];
            yr = [.3 1.3];
            loc = 'SouthEast'
            xlab = 'R - United States';
            ylab = 'R - Canada';
            best_mm = 2;
        case 4
            'mpx_ps'
            load('data\script011014_mpx_ps')
            x_arr = mp1_arr;
            y_arr = mp2_arr;
            cont_data = cont_mpx_ps;
            MLres = MLres_mpx_ps;
            ci1D = ci1D_mpx_ps;
            xr = [0.01 0.5];
            yr = [0 0.5];
            loc = 'SouthEast'
            xlab = 'R - animal-to-human';
            ylab = 'R - human-to-human';
            best_mm = 2;
        case 5
            'mers_time'
            load('data\script032814_mers')
            x_arr = mt1_arr;
            y_arr = mt2_arr;
            cont_data = cont_mers_time;
            MLres = MLres_mers_time;
            ci1D = ci1D_mers_time;
            xr = [0.01 3];
            yr = [0 3];
            loc = 'North'
            xlab = 'R - July 2012';
            ylab = 'R - July 2013';
            best_mm = 6;
        case 6
            'mers_sars'
            load('data\script032814_mers')
            x_arr = ms1_arr;
            y_arr = ms2_arr;
            cont_data = cont_mers_sars;
            MLres = MLres_mers_sars;
            ci1D = ci1D_mers_sars;
            xr = [0.01 2.6];
            yr = [0 2.6];
            loc = 'SouthEast'
            xlab = 'R - MERS';
            ylab = 'R - SARS';
            best_mm = 5; % Not set yet
        case 7
            'mers_cauch'
            load('data\script032814_mers')
            x_arr = me1_arr;
            y_arr = me2_arr;
            cont_data = cont_mers_cauch;
            MLres = MLres_mers_cauch;
            ci1D = ci1D_mers_cauch;
            xr = [0.01 2];
            yr = [0 2];
            loc = 'East'
            xlab = 'R - before June 2013';
            ylab = 'R - after June 2013';
            best_mm = 3; % Not set yet
    end
    for mm = 1:3
        plot([-1 -2],[-1 -2],'-','color',colors{mm},'LineWidth',3)
    end
    if ss == 1
        plot([-9 -8],[-9 -8],'r','LineWidth',3)
    end
    meth_str = {'None','$k_A=k_B$','$k_A=k_B=1$','$R_A = R_B$','$R_A = R_B, k_A=k_B$','$R_A = R_B, k_A=k_B=1$'};
    best_L= 2*MLres(best_mm,5);
    npar = [4 3 2 3 2 1];
    for mm = [6 5 3 4 2 1]
        mtext = round(10*MLres(mm,:))/10;
        mtext(6) = -2*MLres(mm,5)+best_L+2*npar(mm)-2*npar(best_mm);
        mtext(6) = round(10*mtext(6))/10;
        strcat([meth_str{mm},' & ',num2str(npar(mm)),' & ',num2str(mtext(1)),' & ',num2str(mtext(2)),' & ',num2str(mtext(3)),' & ',num2str(mtext(4)),' & ',num2str(mtext(5)),' & ',num2str(mtext(6))])
    end
    plot(xr,xr,'--','Color',[.5 .5 .5],'LineWidth',3)
    for mm = [1]
        plot(MLres(mm,1),MLres(mm,3),'.','color','k','MarkerSize',24)
    end
    for mm = 1:3
        contour(x_arr,y_arr,squeeze(cont_data(mm,:,:))',[-3 -3],'color',colors{mm},'LineWidth',3)
    end
    for mm = 4:6
        fi = find(ci1D(mm-2,:)> -1.92,1);
        ll = (ci1D(1,fi-1)*(ci1D(mm-2,fi)+1.92)-ci1D(1,fi)*(ci1D(mm-2,fi-1)+1.92))/(ci1D(mm-2,fi)-ci1D(mm-2,fi-1));
        li = fi+ find(ci1D(mm-2,fi+1:end)< -1.92,1);
        ul = (ci1D(1,li-1)*(ci1D(mm-2,li)+1.92)-ci1D(1,li)*(ci1D(mm-2,li-1)+1.92))/(ci1D(mm-2,li)-ci1D(mm-2,li-1));
        ci_arr = [ll MLres(mm,1) ul]
        plot(ci_arr,ci_arr+(mm-5)*mean(xr+yr)*.02','--','color',colors{mm},'Linewidth',3)
        plot(ci_arr(2),ci_arr(2)+(mm-5)*mean(xr+yr)*.02','.','color',colors{mm},'MarkerSize',24)
    end
    set(gca,'FontSize',20)
    xlabel(xlab)
    ylabel(ylab)
    xlim(xr)
    ylim(yr)
    
    if ss == 1
        plot(net_res_mpx(:,1),net_res_mpx(:,1).*(1+1./net_res_mpx(:,2)),':','Color',[.5 .5 .5],'LineWidth',3)
        plot(net_r0k(1),net_r0k(1)*(1+1/net_r0k(2)),'.','color','r','MarkerSize',24)
        xl = round(net_r0k_1Dmin(:,1)*100);
        xu = round(net_r0k_1Dmax(:,1)*100);
        plot(net_res_mpx(xl:xu,1),net_res_mpx(xl:xu,1).*(1+1./net_res_mpx(xl:xu,2)),'r','LineWidth',3)
        legend({'k_A and k_B inferred separately','k_A = k_B inferred as one parameter','k_A = k_B = 1 assumed','Network model'},'Location',loc,'FontSize',14)
        'Network L'
        MLres(1,5)+net_r0k(3)
        'Network AIC'
        2*(MLres(1,5)+net_r0k(3)-MLres(best_mm,5))
    else
        legend({'k_A and k_B inferred separately','k_A = k_B inferred as one parameter','k_A = k_B = 1 assumed'},'Location',loc,'FontSize',14)
    end
    legend boxoff
end



%%
% 'spx'
% load('data\script041813_mpx_spx')
% x_arr = s1_arr;
% y_arr = s2_arr;
% cont_data = cont_spx;
% MLres = MLres_spx;
% ci1D = ci1D_spx;
% xr = [0.1 8];
% yr = [0 1];
% loc = 'NorthEast'
% xlab = 'R - Primary';
% ylab = 'Control';
% 
% h2 = figure(5),clf;
% cont_data = contour(x_arr,y_arr,squeeze(cont_data(1,:,:))',[-3 -3]);
% cont_data = cont_data(:,2:end);
% figure(5),clf;
% hold on;
% 
% plot(MLres(1,1),MLres(1,3)/MLres(1,1),'b.','MarkerSize',24)
% % contour(x_arr,y_arr,squeeze(cont_data(mm,:,:))',[-3 -3],'color',colors{mm},'LineWidth',3)
% plot(cont_data(1,:),cont_data(2,:)./cont_data(1,:),'b','LineWidth',3)
% set(gca,'FontSize',20)
% xlabel(xlab)
% ylabel(ylab)
% xlim(xr)
% ylim(yr)
% 
% inset_spx(h1,h2)
% figure(2), close
% figure(5), close

%%
% figure(1)
% savepdf('Figs/mpx011014')
% figure(6)
% savepdf('Figs/spx011014')
% figure(3)
% savepdf('Figs/msls011014')
% figure(4)
% savepdf('Figs/mpx_ps011014')

figure(5)
savepdf('Figs/mers_time040314')
figure(6)
savepdf('Figs/mers_sars040314')
figure(7)
savepdf('Figs/mers_cauch040314')
