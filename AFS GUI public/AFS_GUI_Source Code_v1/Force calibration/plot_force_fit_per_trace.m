function [index] = plot_force_fit_per_trace(axis,M,bead_num)
% [index] = plot_force_fit_per_trace(axis,M,bead_num). Plots
% the selexted beads. Returns the indices of selected beads in M struct for
% subsequent operations.

index=[];
for j=1:length(M.ROI)
    for i = 1:length(bead_num)
        hold(axis,'on')
        if M.ROI(j).bead == bead_num(i)
            z_data=M.ROI(j).z(M.FC.P_on_idx:M.FC.P_off_idx); % loads in the temp z
            % data range from the (untouched) z-trace
            plot(axis,M.FC.Time_FC,z_data*10^6,'o',M.FC.Time_FC,M.ROI(j).z_FC*10^6,'x', M.FC.Time_FC,M.ROI(j).z_fit*10^6); %plots the raw
            % data, modified z and fitted curve, conversion from meter
            % to micrometer

            index=[index, j];
        end
    end
end
legend(axis,'raw data','smoothed data','fit','Location','southeast')
end