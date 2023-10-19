function [FC_beads]=find_beads_FC_GUI_Auto(M,i1,i2,z_co)
% [FC_beads]=findbeads_FC_GUI_Auto(M,i1,i2,z_co). M is the data struct and
% FC_beads an array of bead indices, which are suitable for force
% calibration. i1 and i2 are indices for the time frame where beads should
% be identified. z_co is the cut-off value in z (um).


%% check if there is only one power value applied

temp_power=M.Power(i1:i2);

unique_power=unique(temp_power);
if length(unique_power)>2 %greater 2 because there may be data points present where Power=0 and unique_power is at of length 2 in that case
    disp('select time range where only one power value is applied');
    FC_beads=[]; % return empty array
    return
end

%% Find time span where power is applied
% based on the range definded by i1 and i2, find the time span where the
% power is >0

% find first time point index, where power is applied
P_on_idx=find(temp_power>0,1)+i1-1;
if isempty(P_on_idx) == 0

    %find last time point index, where the same power is applied.
    % Important: this only works if there is only one power value applied in
    % the defined time range

    P_off_idx=find(temp_power==unique_power(2),1,'last'); %this is a relative
    % time index based on the range defined by i1 and i2
    P_off_idx=i1+P_off_idx-1; %to get the index based on the whole time range

    %% Find beads which did not lift off the surface far enough based on z_co
    
    FC_beads=[];
    
    for i=1:length(M.ROI)
        z_temp=M.ROI(i).z(P_on_idx:P_off_idx); %get the z trace only form where power=1
        min_z=min(z_temp);
        max_z=max(z_temp);
        delta_z=10^9*(max_z-min_z); %conversion to nanometer
        
        %check if delta_z is above the cutoff for z. If so, then note down bead ID (index).
        if delta_z > z_co
            FC_beads=[FC_beads i]; % add indices in array. In regular find beads function, i is replaced with M.ROI(i).bead
        end
    end
else
       FC_beads = 'empty';
end
    
end