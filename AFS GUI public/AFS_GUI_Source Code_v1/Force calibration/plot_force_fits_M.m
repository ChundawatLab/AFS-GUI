function plot_force_fits_M(M,f0_plot,kp_plot,phip_plot,r_sq_plot,z_node_plot)
% plot_force_fits_M(M,f0_plot,kp_plot,phip_plot,r_sq_plot,z_node_plot).
% plots histograms of fit parameters and z-node for M struct.

%% collect parameters by getting it out from each bead one by one

fo=[]; %in (pN um)
kp=[]; %in (1/um)
phip=[]; %in (-)
r_sq=[];% in (-)
z_node=[]; % in (um)

for i= 1:length(M.ROI)
    parameters=M.ROI(i).fitp;
    fo_temp=parameters(1); %in (pN um)
    kp_temp=parameters(2); %in (1/um)
    phip_temp=parameters(3); %in (-)

    fo=[fo fo_temp];
    kp=[kp kp_temp];
    phip=[phip phip_temp];
end
r_sq=[M.ROI.RSQ];
z_node=[M.ROI.znode];


%% plot histograms

histogram(f0_plot,fo)
histogram(kp_plot,kp)
histogram(phip_plot,phip)
histogram(r_sq_plot,r_sq)   
histogram(z_node_plot,z_node)  

end