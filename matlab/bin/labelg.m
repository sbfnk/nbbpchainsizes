function labelg(xoff,yoff,lnum,fontsize)
% Just puts panel labels (e.g. 'A)') on a graph
% xoff and yoff are the offsets
% lnum indicates which letter


lnums = {'A)','B)','C)','D)','E)','F)','G)','H)','I)','J)','K)','L)','M)','N)','O)','P)','Q)','R)','S)','T)','U)','V)','W)','X)','Y)',};

xl = get(gca,'XLim');
yl = get(gca,'YLim');

if(strcmp(get(gca,'XScale'), 'linear'))
  xc =xl(1) - xoff*range(xl);
elseif(strcmp(get(gca,'XScale'), 'log'))
  xc =xl(1)/(xl(2)/xl(1))^xoff
end

if(strcmp(get(gca,'YScale'), 'linear'))
  yc =yl(2) + yoff*range(yl);
elseif(strcmp(get(gca,'YScale'), 'log'))
  yc =yl(2)*(yl(2)/yl(1))^yoff;
end

tt = text(xc, yc, lnums{lnum});
set(tt, 'FontSize', fontsize, 'FontWeight','bold')
