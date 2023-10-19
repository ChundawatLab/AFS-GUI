function [N, t]=collect_beads(M,N)
% [N t]=collectbeads(M, N). M is the main data struct until after the
% stokes force calibration. N collects the required data (anchorpoint,
% power value at force calibratin, fit parameters, goodness of fit) from
% the struct M. When multiple experiments are run, N will be appended until
% the desired number of beads for all power values are obtained. t is an
% informative array which lists down the number of beads obtained per power
% value

%% create N struct

if isempty(N)  % check if N is empty and if so, start from index 1, else
    % keep appending the data
    j=0;
    % if N is empty, then the indices of N and M are the same
else
    j=length([N.Power]);
    % if N is already filled, then the index of N needs to be shifted
    % depending on how many data points are already contained in N
end
temp_p=M.FC.Power_FC;
for i=1:length(M.ROI)
    % transfer all the data from M to N
    N(j+i).Power=temp_p;

    temp_AP=M.ROI(i).Anchorpoint;
    N(j+i).APx=temp_AP(1);
    N(j+i).APy=temp_AP(2);

    temp_FC=M.ROI(i).fitp; % [fo, kp, phip]
    N(j+i).fo=temp_FC(1);
    N(j+i).kp=temp_FC(2);
    N(j+i).phip=temp_FC(3);
    N(j+i).RSQ=M.ROI(i).RSQ;
    N(j+i).znode=M.ROI(i).znode;
end

%% Summarize how many beads per power value are already obtained

temp_power=[N.Power]'; % write all power values to temporary array

% taken straight from MATLAB help to summarize data
[C,ia,ic] = unique(temp_power);
a_counts = accumarray(ic,1);
t = [C, a_counts];

end