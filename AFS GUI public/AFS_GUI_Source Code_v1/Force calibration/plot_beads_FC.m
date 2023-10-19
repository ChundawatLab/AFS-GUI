function plot_beads_FC(FC_plot,M,ID)
% plot_trace_FC(FC_plot,M,ID). FC_plot is the corresponding plot in the GUI
% M is the data struct, ID contains the bead array to plot. The plot is
% downsampled to reduce noise in plot.


time=downsample(M.Time,10);

    for i=1:length(ID)
        for j = 1:length([M.ROI.bead])
            if ID(i) == M.ROI(j).bead % find matching beads
                z=downsample(M.ROI(j).z,10);
                hold (FC_plot,'on')
                plot(FC_plot,time,z.*10^6); % convert to micrometer
            end
        end
    end
end
