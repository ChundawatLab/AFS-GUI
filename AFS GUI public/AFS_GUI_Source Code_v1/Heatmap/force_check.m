function [Heatmap_data] = force_check(Heatmap_data)
% [Heatmap_data] = force_check(Heatmap_data) removes all entries where a
% lower power value resulted in a higher force compared to the higher power
% value in the same data set.


% sort power values in ascending order (and shift the corresponding force
% value as well)
for i = 1: length(Heatmap_data)
    [sorted_power, idx] = sort(Heatmap_data(i).P);
    Heatmap_data(i).P = sorted_power;

    F = Heatmap_data(i).F;
    F = F(idx);

    Heatmap_data(i).F = F;
end

idx_remove = [];

% check if array is sorted. if not, add it to idx_remove for deletion
for m = 1:length(Heatmap_data)
    F = horzcat(Heatmap_data(m).F);
    s=issorted(F,'ascend');
    if s==0
        idx_remove = [idx_remove; m];
    end
end

Heatmap_data(idx_remove) = []; %delete entries

end
