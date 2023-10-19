function M=assign_rupture_time(M,ID,t)
% Synthax: M=assign_rupture_time(M,ID,t). M is the data struct, ID is the
% bead number it to which the rutpure time t will be assigned to. The
% corresponding rupture power value will be filled in the struct.

% convert string to number
ID =str2double(ID{1});

% find corresponding index for bead ID
ID=find([M.ROI.bead]==ID);

if isempty(t)==true || t==0 % if user defines no input or zero, then rupture force and time will be zero.
    M.ROI(ID).RuptureTime=0;
    M.ROI(ID).RupturePower=0;
end

% Write the correct rupture time and power in struct
    a=M.Time;
    [~,idxtime]=min(abs(M.Time-t)); % finds the closest value to the user input
    M.ROI(ID).RuptureTime=a(idxtime);
    M.ROI(ID).RupturePower=M.Power(idxtime); 

end

