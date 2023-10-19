function M=remove_beads_StDz(M, std_z_max)
% M=remove_beads_StDz(M, std_z_max). M is the data struct and std_z_max
% is the threshold of the standard deviation in z above which beads will be
% removed as part of the automated SFC.


Std_z=[M.ROI.StDz]';
idx_remove=find(Std_z>std_z_max);
M.ROI(idx_remove) = []; %removes the traces from struct

end