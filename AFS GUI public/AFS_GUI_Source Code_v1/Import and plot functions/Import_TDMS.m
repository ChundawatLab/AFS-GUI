function [M]=Import_TDMS(file_path_and_name,filename)
% M=Import_TDMS(file_path_and_name,filename). Where file_path_and_name is
% the TDMS file path which needs to be read in and filename a character
% array containing the file name (for displaying purposes only). Returns
% data struct M with the tracking data and (units): Time (seconds),
% Frequency (MHz), Power (%), Temperature (degC), ROI's x, y and z data
% (meter).

%% Read in tracking data into a table

data = tdmsread(file_path_and_name); % read in TMDS file

% check which tab (data{1} or data{2}) contains tracking data by comparing
% the size. The larger size is the correct tab. Sometimes, readtdms only
% reads in tracking data, that's why there is a check for length(data).
if length(data)>1
    size1=size(data{1});
    size2=size(data{2});
    if size1(1)>size2(1)
        data=data{1};
    else
        data=data{2};
    end
else
    data=data{1};
end

%% Move data into a struct

% Important: check the structure of the TMDS tracking data since the
% column jumps are hardcoded (5 columns per ROI starting at column 5).
% Column 1: Time (s), Column 2: Frequency (MHz), Column 3: Power (%),
% Column 4: Temperature (deg C) Column 5: first ROI, position X (m) etc..., 
% Last Column: last ROI Mean SSIM (%).
% 
% Also important: No beads should be added during the recording as this
% will mess up with the time trace, since 0 is the first entry of the trace
% and all traces have the same size

% create Metadata info
M.Metadata.filepath=file_path_and_name;
M.Metadata.filename=filename;
M.Metadata.Anchorpoint=false;
M.Metadata.Driftcorrection=false;
M.Metadata.Driftbeads=[];

% write the first 4 columns into struct
M.Time=table2array(data(:,1));
M.Frequency=table2array(data(:,2));
M.Power=table2array(data(:,3));
M.Temperature=table2array(data(:,4));

[r,c]=size(data); % get dimension of data table
N_ROI=(c-4)/5; % Get number of ROIs

% The two loops below write tracking data for each ROI into the data
% struct. The step size of 5 for the second loop because 5 columns are read
% in per ROI. SDD and SSIM can be read in if desired.
i=1;
while i<=N_ROI 
    for j=5:5:c
        M.ROI(i).bead=i;
        M.ROI(i).x=table2array(data(:,j));
        M.ROI(i).y=table2array(data(:,j+1));
        M.ROI(i).z=table2array(data(:,j+2));
%         M.ROI(i).SSD=table2array(data(:,j+3));
%         M.ROI(i).SSIM=table2array(data(:,j+4));
        i=i+1;
    end
end

% convert to relative time using the first time entry as starting value:
M.Time=M.Time-M.Time(1);


end