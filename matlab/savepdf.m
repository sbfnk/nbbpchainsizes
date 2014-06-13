function savepdf(ofile)

set(gcf,'PaperPositionMode','Auto')
pp = get(gcf,'PaperPosition');
set(gcf,'PaperSize',pp(3:4));

saveas(gcf,ofile,'pdf')
% saveas(gcf,ofile)
