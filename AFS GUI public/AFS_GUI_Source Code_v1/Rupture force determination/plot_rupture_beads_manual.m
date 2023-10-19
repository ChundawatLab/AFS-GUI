function [t_rupture] = plot_rupture_beads_manual(axis,M,idx1,idx2,w,co,ID)
% Synthax: plot_rupture_beads_manual(axis,M,idx1,idx2,w,co,ID). Plots beads
% which need to be inspected manually. The function suggests a rupture time
% with a red dot. 


% get time range for ramp
t_temp=M.Time(idx1:idx2);
ramp=M.Power;
ramp=ramp(idx1:idx2);


   for j=1:length(M.ROI)
       for i = 1:length(ID)

            if M.ROI(j).bead == ID(i)
            % find the rupture time for the bead:
                z_temp=M.ROI(j).z*10^9; %conversion to nanometer;
                z_temp=z_temp(idx1:idx2); %only take z between idx1-idx2
                z_temp_smooth=smoothdata(z_temp,"movmedian",w); %smooth data
                B=find(z_temp_smooth>co | z_temp_smooth<co*(-1));
                
                if isempty(B)==true % If no z value above cut-off is found then B is returned empty. 
                    t_rupture = 0;
                else
                    b=B(1)-1; %the first entry of B is the first index at which z>cut-off. -1 because of indexing
                    t=M.Time(idx1+b);  %to get the correct time point
                    z_temp_full=M.ROI(j).z*10^9;
                    z_rupture=z_temp_full(idx1+b); %to ge the z position that ruptured (for display in graph)
                    d=diff(B);
                
                    % plot trace
                    hold (axis,"on")
                    plot(axis,t_temp,z_temp,'.k',t_temp,z_temp_smooth,'.g') %plots z, smoothed z
                    plot(axis,t,z_rupture,'.r','MarkerSize',20) % highlights the rupture point in red
                    ylabel(axis,'z (nm)')
                    ylim(axis,[-1000 inf]);
                    yyaxis(axis,"right") 
                    plot(axis,t_temp,ramp) %plots ramp
                    ylabel(axis,'Power (%)')
                    yyaxis (axis,"left") %swith back so that zoom affects the z axis and not the power axis
                    xlabel(axis,'time (s)');
                    title(axis,['Bead ' num2str(M.ROI(j).bead)]);  

                    t_rupture = t;
                end
            end
       end
    end
    
 
    
end
