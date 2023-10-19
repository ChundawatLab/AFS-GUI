function M=remove_outliers_FC_M_struct(M,fo_l,fo_u,kp_l,kp_u,phip_l,phip_u,rsq_l,rsq_u,z_l,z_u)
% M=remove_outliers_FC_M_struct(M,f0_l,f0_u,kp_l,kp_u,phip_l,phip_u,rsq_l,rsq_u,z_l,z_u),
% where M is the M struct and the following variables are the cut-off
% limits for the fit parameters. Removes all entries which are outside the
% bounds defined by the cut-off variables and returns the updated M struct.


% initialize arrays
fo=[];
kp=[];
phip=[];
rsq=[];
z=[];

% populate arrays (loop because of fo,kp,phip)
for k = 1:length(M.ROI)
    fo=[fo,M.ROI(k).fitp(1)];
    kp=[kp,M.ROI(k).fitp(2)];
    phip=[phip,M.ROI(k).fitp(3)];
    rsq=[rsq,M.ROI(k).RSQ];
    z = [z,M.ROI(k).znode];
end

% find indices of beads which need to be removed
idx_remove_fo=find(fo<fo_l | fo>fo_u);
idx_remove_kp=find(kp<kp_l | kp>kp_u);
idx_remove_phip=find(phip<phip_l | phip>phip_u);
idx_remove_rsq=find(rsq<rsq_l | rsq>rsq_u);
idx_remove_z=find(z<z_l | z>z_u);

% combine indices and remove them from struct
idx_remove=unique([idx_remove_fo,idx_remove_kp,idx_remove_phip,idx_remove_rsq,idx_remove_z]);
M.ROI(idx_remove)=[];
end