function [M ,mbeads, RFTime]=determine_rupture_force_GUI(M,idx1,idx2,w,co)
% [M ,mbeads, RFTime]=determine_rupture_force_GUI(M,idx1,idx2,w,co). M is the data
% struct and idx1 and idx2 are the indices of the time points between which
% the rupture force will be determined. w is the number of z- values which
% are smoothened using 'movmedian'. co is the z position cut-off value in
% nanometer. Adds rutpure time and rupture power to the data struct. If the
% rupture time cannot be determined, the bead index is stored in mbeads and
% a rupture time of 0 and rupture power of 0 is placed instead.


% degine array of bead indices which need manual inspection afterwards
mbeads=[];

%find the ramp start time
t_temp=M.Time(idx1:idx2);
ramp=M.Power;
ramp=ramp(idx1:idx2);
ramp_start=find(ramp>0);
ramp_start=ramp_start(1); %is a 'relative' index, for the absolute index, 
% idx1 needs to be added
t_ramp=t_temp(ramp_start); 

M.Metadata.ramp_start=t_ramp;

for i=1:length(M.ROI)
    z_temp=M.ROI(i).z*10^9; %conversion to nanometer;
    z_temp=z_temp(idx1:idx2); %only take z between idx1-idx2
    z_temp_smooth=smoothdata(z_temp,"movmedian",w); %smooth data

%finds the indices where z is larger than the cut-off or smaller than
%negative cut-off for the defined time range, B returns an array of
%'relative' indices. To get the right index, idx1 needs to be added
    B=find(z_temp_smooth>co | z_temp_smooth<co*(-1));

    if isempty(B)==true % If no z value above cut-off is found then B is returned empty. 
        M.ROI(i).RuptureTime=0;
        M.ROI(i).RupturePower=0;
    else
        b=B(1)-1; %the first entry of B is the first index at which z>cut-off. 
        % -1 because of indexing
        t=M.Time(idx1+b);  %to get the correct time point
        z_temp_full=M.ROI(i).z*10^9;
        z_rupture=z_temp_full(idx1+b); %to ge the z position that ruptured (for display in graph)
        d=diff(B);

        % check if all subsequent z values are above threshold by looking
        % at the difference in indices in B (d=diff(B)). If the mean is not
        % 1, then note down that bead for closer inspection and output in
        % mbeads

        if mean(d)==1 
            M.ROI(i).RuptureTime=t;
            M.ROI(i).RupturePower=M.Power(idx1+b);
        else 
            mbeads=[mbeads M.ROI(i).bead];
            % assign 0 for time and power to beads which have no clear
            % rupture force
            M.ROI(i).RuptureTime=0;
            M.ROI(i).RupturePower=0;  
        end
   end
end
RFTime = [M.ROI.RuptureTime];
end
