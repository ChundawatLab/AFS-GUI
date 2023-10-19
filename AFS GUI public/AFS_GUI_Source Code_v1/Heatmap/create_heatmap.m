function heatmap = create_heatmap(axis,Heatmap_data,xmax,ymax,showbeads)
% heatmap = create_heatmap(axis,Heatmap_data,xmax,ymax,showbeads).
% creates a heatmap from the Heatmap_data given the limits of the FoV set
% by xmax and ymax. Showbeads is a T/F indicator to display anchor point
% positions in the heatmap.

cla(axis)

% get mesh for heatmap data
[xi, yi, vi] = get_query(Heatmap_data); 

% convert to micrometer for plot
xi=xi*10^6;
yi=yi*10^6;

% plot heatmap
heatmap = surf(axis,xi, yi, vi, 'edgecolor', 'none');

c =colorbar(axis);  
c.Label.String = 'Force factor (pN/%)';
view(axis,2);

% add data points to plot
hold (axis,"on")

% obtain anchor point data and force calibration factor (S)
AP = vertcat(Heatmap_data(:).AP);
slope = vertcat(Heatmap_data(:).S);

% split anchor points into x and y coordinates
x_pos = AP(:,1);
y_pos = AP(:,2);

% convert to micrometer for plot
x_pos=x_pos*10^6;
y_pos=y_pos*10^6;

if showbeads==1
    plot3(axis,x_pos, y_pos, slope + 2, 'or'); % slope + 2 so that beads appear "on top" of surface
end

set (axis,'YDir','reverse') % reverse y axis to align with FoV in AFS

xlim(axis,[0 xmax])
ylim(axis, [0 ymax])


end