function update_main_plots(M,beadlist,planar_plot,normal_plot)  
% update_main_plots(M,beadlist,planar_plot,normal_plot), M is the main data
% struct, beadlist is the cell array of beads from the list box and
% planar_plot and normal_plot are the two main graphs for x/y and z/p vs
% time, respectively. Plots the selected bead. For multiple selections,
% only the first bead will be plotted.

% extract the first number from the bead selection and convert to double
ID=regexp(beadlist{1},'\d+','match'); 
IDx=str2double(ID);

% find index of bead in M.ROI.bead
IDx=find([M.ROI.bead]==IDx);

% plot x/y (convert to nm)
plot(planar_plot,M.Time,M.ROI(IDx).x .*10^9,M.Time,M.ROI(IDx).y .*10^9)
% legend(planar_plot,'Bead '+ string(ID),'Location','northeast') % temp legend to check if beads are displayed correctly
legend(planar_plot,'x','y', 'Location','northwest')

% plot z and p (on different y axis). Plot z last, so that zoom in GUI
% works for z trace and not power trace.
yyaxis(normal_plot,"right")
ylabel(normal_plot,'Power (%)')
plot(normal_plot,M.Time,M.Power ,'DisplayName','Power')
yyaxis(normal_plot,"left")
ylabel(normal_plot,'z (nm)')
plot(normal_plot,M.Time,M.ROI(IDx).z .*10^9 , 'DisplayName','z')
legend(normal_plot, 'show','Location','northwest')
    
end