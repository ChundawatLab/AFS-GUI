function [xi, yi, vi] = get_query(Merged_beads)
% [xi, yi, vi] = get_query(Merged_beads). Gets the mesh data for heatmap 

% get anchor point data and split up to x and y coordinates for mesh grid
AP = vertcat(Merged_beads(:).AP);
conv_fact = vertcat(Merged_beads(:).S);
x_pos = AP(:,1)';
y_pos = AP(:,2)';

% get min and max values for x and y
min_x = min(x_pos);
max_x = max(x_pos);
min_y = min(y_pos);
max_y = max(y_pos);

% create mesh and mesh grid data (vi)
[xi, yi] = meshgrid(linspace(min_x,max_x), linspace(min_y,max_y));
vi = griddata(x_pos, y_pos, conv_fact, xi, yi,'v4');
end