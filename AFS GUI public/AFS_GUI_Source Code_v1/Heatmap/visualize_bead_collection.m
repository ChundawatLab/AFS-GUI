function visualize_bead_collection(plot_bead_distribution,N,P,xmax,ymax)
% visualize_bead_collection(heat_map_axis,N,P,xmax,ymax). Plot function
% which shows the bead position in the field of FoV to help the user verify
% that sufficient beads at one power value have been collected. N is the
% collection struct after force calibration and P the power value of data
% to be plotted


% find indices of the correct power value
    temp_power=[N.Power]';
    idx=find(temp_power==P);

% pull out the subset of x and y data
    temp_x=[N.APx]';
    temp_y=[N.APy]';
    
    temp_x=temp_x(idx).*10^6; %convert to micrometer
    temp_y=temp_y(idx).*10^6; 

% Plot the anchor points
    plot(plot_bead_distribution,temp_x,ymax-temp_y,'ok'); % y is subtracted, since FoV image is flipped along the x axis; However bead coordinates remain as they are
    xlim(plot_bead_distribution,[0 xmax]) 
    ylim(plot_bead_distribution,[0 ymax])  
    set(plot_bead_distribution,'YDir','reverse')

end