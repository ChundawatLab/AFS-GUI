function M=remove_beads_RSQ(M, R)
% M=remove_beads_RSQ(M, R). M is the data struct and R is the R^2
% threshold. Beads having an R^2 less than the threshold will be removed
% from the struct.

Rsq=[M.ROI.RSQ]';
idx_remove=find(Rsq<R);
M.ROI(idx_remove) = []; %removes the traces from struct

end