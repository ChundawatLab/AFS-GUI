function M=prep_beads_FC_GUI(M, i1,i2,n)
% Synthax M=prep_beads_FC_GUI(M,i1,i2,n). Where M is the data struct
% containing the tracking data. i1 and i2 are the indices for the time
% range selected for force calibration. n is the number % of frames for z
% to be smoothened by smoothdata(movemedian). Appends M for data needed for
% force calibration. Important: the time range should only span one
% constant power value for force calbration

%% check if only one distinct power signal is in range 
unique_power=unique(M.Power(i1:i2));
if length(unique_power)>2 %greater 2 because there may be data points 
    % present where Power=0 and unique_power is at of length 2 in that case
    disp('select time range where only one power value is applied');
    return
end


%% Find time span where power is applied
% based on the range definded by i1 and i2, find the time span where the
% power is not 0

%find first time point index, where power is applied
    temp_power=M.Power(i1:i2);
    P_on_idx=find(temp_power>0,1)+i1-1;
  
%find last time point index, where the same power is applied %this only
%works if there is only one power value applied
    temp_power=M.Power(i1:i2);
    P_off_idx=find(temp_power==unique_power(2),1,'last'); %this is a relative 
    % time index based on the range defined by i1 and i2
    P_off_idx=i1+P_off_idx-1; %to get the index based on the whole time range

% write useful FC related data to struct:
    M.FC.Time_FC=M.Time(P_on_idx:P_off_idx);  
    M.FC.Power_FC=max(unique_power); %assuming unique_power contains only 0 
    % and the actual power value applied (check for 2x1 size is done
    % above), the max would be the actual power value. 
    M.FC.P_on_idx=P_on_idx;
    M.FC.P_off_idx=P_off_idx;

%% add relative time and shifted z (z(t=0)=0) to struct
% z is also smoothed by n points before it is shifted

M.FC.Time_FC=M.FC.Time_FC-M.FC.Time_FC(1);

for i=1:length(M.ROI)
    z_smooth=smoothdata(M.ROI(i).z(P_on_idx:P_off_idx),'movmedian',n); % only 
    % takes the z-trace where power is applied and smoothes it
    M1.ROI(i).z_rel=z_smooth-z_smooth(1); %shifts z so that z(1)=0 (condition 
    % needed for force calibration). M1 is a temporary struct
end

%% check if smoothened data contains z values <0 
% Negative z values cause an error in the force fitting due to the
% numerical integration. Therefore, negative z-values are replaced by the 
% average of the nearest positive data points. This is only an issue if
% large time spans (multiple seconds) contain negative values. 

% ######## NOTES/TO DO #############
% make a stop in case tracking errors occur along the trace 
% ##################################

for j=1:length(M.ROI)
    z_temp=M1.ROI(j).z_rel;
    A=find(z_temp<=0);
    last_entry=max(A);
        
    size_z=length(z_temp);
    if last_entry>=size_z
        % do nothing (will be removed during force calibration since force
        % fit is off)        
        M.ROI(j).z_FC=z_temp;
    else
        for i=last_entry:-1:2 %loop starting from the last index which was <=0
            % the next entry after "last_entry" is >0, but the algorythm needs
            % to find another index lower than the current i to interpolate.
            % This time, any value >=0 will do, as a potential 0 value will
            % also result in a positive value when averaged with a positive
            % number

            if z_temp(i)<=0
                z_up=z_temp(i+1); %this value should be always positive, since
                % we are counting backwards
                z_temp1=z_temp(1:i); %get the z-values for the time range, where
                % negative z values are still present
                z_lo_idx=find(z_temp1>=0,1,'last'); %when counting backwards,
                % find the first index where z>=0
                z_lo=z_temp1(z_lo_idx); %get the correcsponding z-value
                z_av=mean([z_up z_lo]); %calculate the averge for the z-values
                if z_av<10^-12
                    z_av=10^-12; % override z_av if it's less than a picometer
                    % this is a "fix" and may cause issues if a longer time
                    % range contains negative z values
                end
                z_temp(i)=z_av; %replace negative value with average
            end
        end
    end
    % Write to struct
    M.ROI(j).z_FC=z_temp;
end

end