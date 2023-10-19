function [FC] = get_query_RF(Heatmap_data,Pos)
% [FC] = get_query_RF(Heatmap_data,Pos)  returns the interpolated force
% calibration factor FC at the anchor point position Pos for a given
% heatmap created by Merged_beads

% get position data of bead
x_pos=Pos(1);
y_pos=Pos(2);

% get heatmap data positions
AP = vertcat(Heatmap_data(:).AP);
conv_fact = vertcat(Heatmap_data(:).S);
x = AP(:,1)';
y = AP(:,2)';

% get min and max values
min_x = min(x);
max_x = max(x);
min_y = min(y);
max_y = max(y);

    FC = griddata(x, y, conv_fact, x_pos, y_pos,'natural');
    if isnan(FC) % if bead is outside bounds, then FC is returned as NaN
        FC = 0;
    end
end



