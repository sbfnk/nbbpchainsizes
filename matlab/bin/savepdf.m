function savepdf(ofile)
% Just saves the figures that are created in pdf format

set(gcf,'PaperPositionMode','Auto')
pp = get(gcf,'PaperPosition');
set(gcf,'PaperSize',pp(3:4));

saveas(gcf,ofile,'pdf')
% saveas(gcf,ofile)
