function M=assign_rupture_force(M,Heatmap_data)
% M=assign_rupture_force(M,Heatmap_data) uses the currently loaded heatmap
% to assign the rupture force to the rupture power value

% get ramp start time
ramp_start = M.Metadata.ramp_start;

for i=1:length(M.ROI)
    AP=M.ROI(i).Anchorpoint;

    % get the force calibration factor and write values to struct
    FC = get_query_RF(Heatmap_data,AP);
    M.ROI(i).RuptureForce=FC*M.ROI(i).RupturePower;
    M.ROI(i).BondLifeTime=M.ROI(i).RuptureTime-ramp_start;
    M.ROI(i).LoadingRate=M.ROI(i).RuptureForce/M.ROI(i).BondLifeTime;
end
end