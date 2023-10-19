function Merged_beads = power_fit(Merged_beads)
% Merged_beads = power_fit(Merged_beads) fits a linear line going through
% the origin (0/0) for Power and Force: Force=S*Power where S is the slope.

for s = 1:length(Merged_beads)
    power = (Merged_beads(s).P)';
    force = (Merged_beads(s).F)';
    power = vertcat(0, power); % add origin as a point 
    force = vertcat(0,force);

    B = power(:)\force(:);
    Merged_beads(s).S = B;
end


end
