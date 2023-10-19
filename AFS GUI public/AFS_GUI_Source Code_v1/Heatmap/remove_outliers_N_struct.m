function N=remove_outliers_N_struct(N,fo_l,fo_u,kp_l,kp_u,phip_l,phip_u,rsq_l,rsq_u,z_l,z_u)
% N=remove_outliers_N_struct(N,f0_l,f0_u,kp_l,kp_u,phip_l,phip_u,rsq_l,rsq_u,z_l,z_u),
% where N is the N structt and the following variables are the cut-off
% limits for the fit parameters. Removes all entries which are outside the
% bounds defined by the cut-off variables and returns the updated N struct.

% find indices in N struct outside bounds
    fo=[N.fo];
    idx_remove_fo=find(fo<fo_l | fo>fo_u);
    
    kp=[N.kp];
    idx_remove_kp=find(kp<kp_l | kp>kp_u);
    
    phip=[N.phip];
    idx_remove_phip=find(phip<phip_l | phip>phip_u);
    
    rsq=[N.RSQ];
    idx_remove_rsq=find(rsq<rsq_l | rsq>rsq_u);
    
    z=[N.znode];
    idx_remove_z=find(z<z_l | z>z_u);

% combine indices and remove them from struct
idx_remove=unique([idx_remove_fo,idx_remove_kp,idx_remove_phip,idx_remove_rsq,idx_remove_z]);
N(idx_remove)=[];
end