function plot_stuck_beads_GUI(M,ID,w,x_plot,y_plot,z_plot)
% plot_stuck_beads_GUI(M,ID,w,x_plot,y_plot,z_plot). M is the data struct,
% ID is bead index numbers to plot and x_plot,y_plot,z_plot are the axis
% handles for the GUI.

%% calculate average drift in x y and z
% same code as in correct_drift_z

x_stuck=[];
y_stuck=[];
z_stuck=[];

beadID_list=[M.ROI.bead]; %get list of all beads

for i=1:length(ID)
    j=find(ID(i)==beadID_list); % find the correct index of the beads which are used for drift correction
    x_stuck=[x_stuck M.ROI(j).x];
    y_stuck=[y_stuck M.ROI(j).y];
    z_stuck=[z_stuck M.ROI(j).z];
end
if length(ID)>1 
    z_stuck_mean=mean(z_stuck')'; %transpose z_stuck so that each row in the 
    % original trace is averaged and then transpose once more to flip it back
    % to a Nx1 array
    z_stuck_mean=smoothdata(z_stuck_mean,w); %now we have one averaged and 
    % smoothened z-trace which can be subtracted from all other traces
else % if only one trace for drift correction is selected, then there is no need to average between selected traces
    z_stuck_mean=smoothdata(z_stuck,w);
end

%repeat the same calculation for x and y trace
if length(ID)>1
    x_stuck_mean=mean(x_stuck')';
    x_stuck_mean=smoothdata(x_stuck_mean,w);
    y_stuck_mean=mean(y_stuck')';
    y_stuck_mean=smoothdata(y_stuck_mean,w);
else
    x_stuck_mean=smoothdata(x_stuck,w);
    y_stuck_mean=smoothdata(y_stuck,w);
end

%%  plot data
time=M.Time;
plot(x_plot,time,x_stuck_mean.*10^9); %in nm
plot(y_plot,time,y_stuck_mean.*10^9); %in nm
plot(z_plot,time,z_stuck_mean.*10^9); %in nm


end