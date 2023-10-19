function [ID]=find_stuck_beads(M,co,w)
% ID=find_stuck_beads(M,co), where M is the main data struct and ID an
% array of ROIs which appear to be stuck and may be used for drift
% corrction. co is the limit which is used as a search criteria (in
% nanometer). Manual inspection of each trace is still necessary. The
% traces are averaged by a window of w frames to reduce the influence of
% tracking errors

% initialize array
ID=[];

    for i=1:length(M.ROI)
        z_temp=smoothdata(M.ROI(i).z*10^9,w); %conversion to nanometer and smooth data to reduce the risk of outliers messing up the search
        B=find(z_temp<co & z_temp>co*(-1)); %checks which z are within bounds
        size_z=size(z_temp);
        size_B=size(B);
        if size_z(1)==size_B(1) % if all z positions are within bounds as for a stuck bead, then the B-array is the same size as z_temp. If not, then B is smaller
            ID=[ID M.ROI(i).bead]; % sums up all bead numbers which appear to be stuck
        end
    end
end
