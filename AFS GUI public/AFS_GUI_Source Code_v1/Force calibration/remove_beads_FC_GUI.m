function M=remove_beads_FC_GUI(M,FC_beads)
% Synthax M=remove_beads_FC_GUI(M,FC_beads). Where M is the main data
% struct and FC_beads the index of beads which will be kept for force
% calibration. Returns M with only the ROIs which will be used for force
% calibration
% 

%% Remove all beads which are not used for force calibration from the struct

% this code only works as long as the indices FC_beads coincide with the
% indices of M.ROI. No bead should be removed between finding FC beads
% (findbeads_FC_GUI) and executing this function

bead_list = [];
for i = 1:length(M.ROI)
    bead_list = [bead_list, M.ROI(i).bead];
end
% indices_array=1:length(M.ROI); %creates an array for the indices 

idx_remove=find(ismember(bead_list,FC_beads)==0); %ismember compares the 
% bead_list with FC_beads and returns a logical array with True, where
% FC_bead indices coincide with the value in bead_list. Find returns an
% array for the indices of the logical array with False entries. This array
% are the rows in M.ROI which need to be removed


M.ROI(idx_remove) = []; %removes the traces from struct

end