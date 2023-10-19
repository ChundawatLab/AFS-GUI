function [FC_beads,Out_beads]=find_beads_FC_GUI(M,i1,i2,z_co)
% [FC_beads,Out_beads]=findbeads_FC_GUI(M, i1,i2,z_co). M is the data
% struct, i1 and i2 are the indices between which the z position is looked
% at and z_co is the z position cut-off (in micrometer). FC_beads an array
% of bead IDs, which are suitable for force calibration. Out_beads are
% beads which are not suitable for force calibration.

%% check if there is only one power value applied

temp_power=M.Power(i1:i2);

unique_power=unique(temp_power);
if length(unique_power)>2 %greater 2 because there may be data points present where Power=0 and unique_power is at of length 2 in that case
    disp('select time range where only one power value is applied');
    FC_beads=[];
    Out_beads=[];
    return
end

%% Find time span where power is applied
% based on the range definded by i1 and i2, find the time span where the
% power is >0

%find first time point index, where power is applied
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
    Out_beads=[];
    
    for i=1:length(M.ROI)
        z_temp=M.ROI(i).z(P_on_idx:P_off_idx); %get the z trace only form where power=1
        min_z=min(z_temp);
        max_z=max(z_temp);
        delta_z=10^6*(max_z-min_z); %conversion to micrometer
        
        %check if delta_z is above the cutoff for z. If so, then note down bead
        %ID (in field ROI.bead)
        if delta_z >= z_co
            FC_beads=[FC_beads M.ROI(i).bead]; % append beads to keep
        else
            Out_beads=[Out_beads M.ROI(i).bead]; % append beads to remove
        end
    end

   end

end


