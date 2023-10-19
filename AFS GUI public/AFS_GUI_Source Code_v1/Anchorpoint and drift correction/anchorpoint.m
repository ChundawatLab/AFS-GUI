function [M,idxremove]=anchorpoint(M,i1,i2,xmax,ymax)
% [M, idxremove]=anchorpoint(M,i1,i2,xmax,ymax). M is the main data
% struct, i1 and i2 is the timerange (indices) for the anchorpoint
% determination and xmax and ymax (in micrometer) are the limits of FoV.
% Function will determine the anchorpoint between i1 and i2 and remove all
% beads where the anchorpoint is outside the limits set by xmax and ymax.
% Returns appended struct with coordinates of anchor point [x_mean y_mean]
% (in meter). The absolute x/y/z data will be overwritten with the relative
% x/y/z data. The anchor point will only be determined once for a data set.

%% Determine anchorpoint and standard deviation in z

if M.Metadata.Anchorpoint==0 % check if anchor point has not yet been determined
    for i=1:length(M.ROI)
        % pull out trace range for anchro point from x/y/z
        A=M.ROI(i).x(i1:i2);
        B=M.ROI(i).y(i1:i2);
        C=M.ROI(i).z(i1:i2);
    
        x_mean=mean(A);
        y_mean=mean(B);
        AP=[x_mean y_mean]; %coordinates of anchor point in FoV
    
        
        x_rel=M.ROI(i).x-x_mean;
        y_rel=M.ROI(i).y-y_mean;
        M.ROI(i).x=x_rel; % write reltative x and y values to struct
        M.ROI(i).y=y_rel;
        
        S_z=std(C);
        C=smoothdata(C); %smoothens the data using Matlabs' function - ignores NaN values.
        M.ROI(i).z=M.ROI(i).z-min(C); %calculates the relative z values
        
        M.ROI(i).Anchorpoint=AP;
    
        %calculate the R.M.S. value according to Sitters et al, 2014 (Acoustic
        %Force Spectroscopy)
        x_diff=x_rel(i1:i2)-mean(x_rel(i1:i2));
        y_diff=y_rel(i1:i2)-mean(y_rel(i1:i2));
        x_diff_sq=x_diff.^2;
        y_diff_sq=y_diff.^2;
        sum_rms=x_diff_sq+y_diff_sq;
        mean_rms=mean(sum_rms);
        RMS=sqrt(mean_rms);
        M.ROI(i).RMS=RMS; %RMS in mm  
        M.ROI(i).StDz=S_z; %Std in nm
    
        A=[];
        B=[];
        C=[];
        AP=[];
        RMS=[];
        S_z=[];
    end
else
   % if anchor point was already determined, then function will be stopped
   % here
    disp('Anchor point was already determined');
   idxremove=[];
   return
end

% set anchor point metadata to 1
M.Metadata.Anchorpoint=true;

%% remove all anchorpoints which are outside the FoV 

[M,idxremove]=remove_beads_AP(M,xmax,ymax);



end