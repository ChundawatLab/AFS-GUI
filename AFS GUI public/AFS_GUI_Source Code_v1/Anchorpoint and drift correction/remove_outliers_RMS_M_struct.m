function M=remove_outliers_RMS_M_struct(M,rms_l,rms_u,stdz_cut)
% M=remove_outliers_RMS_M_struct(M,rms_l,rms_u,stdz_cut), where M is the M
% struct and the following variables are the cut-off limits for the trace
% values. Removes all entries which are outside the bounds defined by the
% cut-off variables and returns the updated M struct.

% create RMS and Stddev z array and convert to nanometer
rms=[M.ROI.RMS].* 10^9;
stdz=[M.ROI.StDz].* 10^9;

% find indices of beads which need to be removed
idx_remove_rms=find(rms<rms_l | rms>rms_u);
idx_remove_stdz=find(stdz>stdz_cut);

% combine indices and remove them from struct
idx_remove=unique([idx_remove_rms,idx_remove_stdz]);
M.ROI(idx_remove)=[];
end