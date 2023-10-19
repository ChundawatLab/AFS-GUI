function plot_force_profile_GUI(M,ID,z_fp,axis)
% plot_force_profile_GUI(M,ID,z_fp,axis). M is the data struct, ID is bead array to plot.
% z_fp is the array for the force profile.

    hold (axis,"on")

    for i=1:length(ID)
        for j = 1:length(M.ROI)

            if (ID(i)==M.ROI(j).bead) % compare bead ID in M struct with ID array and if match, then plot
                F=force_at_z(M,j,z_fp); % obtain the force
                plot(axis,z_fp,F) % plot
            end
        end
    end
    plot(axis,z_fp,zeros(length(z_fp)),'LineWidth',2,'Color','r') %plots a 
    % red line for F=0


end