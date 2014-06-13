function [h_main, h_inset]=inset_spx(main_handle, inset_handle,inset_size,fignum)

% The function plotting figure inside figure (main and inset) from 2 existing figures.
% inset_size is the fraction of inset-figure size, default value is 0.35
% The outputs are the axes-handles of both.
% 
% An examle can found in the file: inset_example.m
% 
% Moshe Lindner, August 2010 (C).

if nargin==2
    inset_size=0.35;
    fignum = 12;
end

inset_size=inset_size*.7;
figure(fignum),clf
set(gcf,'Position',[20 100 800 500])

new_fig=gcf;
main_handle
main_fig = findobj(main_handle,'Type','axes');
h_main = copyobj(main_fig,new_fig);
for hh = 1:length(h_main)
    set(h_main(hh),'Position',get(main_fig(hh),'Position'));
end
inset_fig = findobj(inset_handle,'Type','axes');
h_inset = copyobj(inset_fig,new_fig);
ax=get(main_fig(1),'Position');
% set(h_inset,'Position', [.7*ax(1)+ax(3)-inset_size .5*ax(2)+ax(4)-inset_size inset_size inset_size])
% set(h_inset,'Position', [.8*ax(1)+ax(3)-inset_size 1.1-.5*ax(2)-ax(4) inset_size inset_size])
set(h_inset,'Position', [.23 .69 .16 .16])
% % For 052313 version
% set(h_inset,'Position', [.65 .55 .22 .22])
