function [h_main, h_inset]=inset_spx(main_handle, inset_handle,inset_size,fignum)

% This function plots figure inside figure (main and inset) from 2 existing figures.
% It is used to plot the inset for the figure showing the impact of
% smallpox control
%
% inset_size is the fraction of inset-figure size
% The outputs are the axes-handles of both.
% 
% Adapted from Moshe Lindner, August 2010 (C).

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
set(h_inset,'Position', [.23 .69 .16 .16])
