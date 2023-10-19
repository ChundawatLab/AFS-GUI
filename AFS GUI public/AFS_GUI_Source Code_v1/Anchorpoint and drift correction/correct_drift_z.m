function M=correct_drift_z(M,ID,w)
% M=correct_drift(M,ID,w). Where M is the main data struct and ID an array
% of bead numbers which are used for drift correction. The numbering in the
% ID struct indicates the bead defined in M.ROI.bead, not the actual index.
% w is the averaging window for the trace. Corrects all traces for drift
% and overwrites the x,y and z data in M with the drift corrected data. The
% traces will only be corrected for drift once.


%% calculate average drift 
% by averaging z traces and then smoothing the average

beadID_list=[M.ROI.bead]; %get list of all beads

z_stuck=[];
for i=1:length(ID)
    j=find(ID(i)==beadID_list); % find the correct index of the beads which are used for drift correction
    z_stuck=[z_stuck M.ROI(j).z]; % append z_stuck so that each column is one bead bead for drift correction
end

if length(ID)>1 
    z_stuck_mean=mean(z_stuck')'; %transpose z_stuck so that each row in the 
    % original trace is averaged and then transpose once more to flip it back
    % to a Nx1 array
    z_stuck_mean=smoothdata(z_stuck_mean,w); %now we have one averaged and 
    % smoothened z-trace which can be subtracted from all other traces
else % if only one trace for drift correction is selected, then there is no need to average between selected traces
    z_stuck_mean=smoothdata(z_stuck,w);
end

%% correct for drift
% subtract the averaged, smoothened z-trace from all others

if M.Metadata.Driftcorrection==0 % check if traces have not yet been corrected for drift
    for i=1:length(M.ROI)
        M.ROI(i).z=M.ROI(i).z-z_stuck_mean;
    end
else % if traces have already been corrected, stop here
    disp('Traces are already corrected for drift')
    return
end

M.Metadata.Driftcorrection=true;

%% note down beads which have been used for drift correction
% get the 'real' bead ID by looking up what stuck beads corresponds to the
% ID index array

temp_ID=[]; % temporary placeholder
for i=1:length(ID)
    temp_ID=[temp_ID M.ROI(ID(i)).bead];
end

M.Metadata.Driftbeads=temp_ID;
end