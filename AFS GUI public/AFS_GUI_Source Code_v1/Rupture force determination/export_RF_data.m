function export_RF_data(M,filename, filepath)
% export_RF_data(M, filename, filepath), saves the rupture force data (Bead
% ID,Anchor point, RMS, StDz, Rupture time, power and force, bond life
% time, loading rate) as a csv file at the specifiec file path. Anchorpoint
% 1 is anchor point data in x and Anchorpoint 2 is anchor point data in y.
% Units: Anchorpoint, RMS, StDz (m); Power (%); Rupture time (s); Rupture
% Force (pN); Bond life time (s); Loading rate (pN/s)

filepath=char(filepath); % convert to character array for export

B=struct2table(M.ROI); % write ROI data to table
B=removevars(B,{'x','y','z'}); % remove tracking data

str = append(filepath,'\',filename,'.csv');

% check if file exists and offer alternatives in that case. Stop if user
% presses cancel
if isfile(str)
    prompt = {'File already exists. Please enter another file name:'};
    dlgtitle = 'Input';
    definput = {'enter alternative file name here'};
    dims = [1 35];
    answer = inputdlg(prompt,dlgtitle,dims,definput);
    if isempty(answer) % skip function if user presses cancel
        return
    end
    str=append(filepath,'\',answer{1},'.csv'); % create new string for file
    writetable(B,str);
else
    writetable(B,str);

end


end