function plot_force_fits_N(N,f0_plot,kp_plot,phip_plot,r_sq_plot,z_node_plot)
% plot_force_fits_N(N,f0_plot,kp_plot,phip_plot,r_sq_plot,z_node_plot)
% plots histograms of fit parameters and z-node for N struct.




%% collect parameters from struct

fo=[N.fo]; %in (pN um)
kp=[N.kp]; %in (1/um)
phip=[N.phip]; %in (-)
r_sq=[N.RSQ];% in (-)
z_node=[N.znode]; % in (um)

%% plot histograms

histogram(f0_plot,fo)
histogram(kp_plot,kp)
histogram(phip_plot,phip)
histogram(r_sq_plot,r_sq)   
histogram(z_node_plot,z_node)  

end