function Merged_beads=mergepoints_fixed_mesh_GUI(FC,r_merge,xmax,ymax)
% Synthax: Merged_beads=mergepoints_fixed_mesh_GUI(FC,r_merge,xmax,ymax).
% FC is the struct holding the force data for each power value. r_merge
% (micrometer) size of the grid for merging and xmax and ymax (micrometer)
% is the size of the FoV. All anchorpoint in FC will be mapped to a
% fixed reference mesh defined by the size of the FoV and r_merge.
% Merged_beads is a summary of which beads have been merged along with the
% averaged anchorpoint and force. Some mesh points only contain one power
% value, but this power value is the result of merging 2 or more anchor
% points for a particular mesh point.


%% convert to meter

r_merge=r_merge*10^-6;
xmax=xmax*10^-6;
ymax=ymax*10^-6;

%% Based on size of FoV, create the x and y arrays for the grid

x_ref=0:r_merge:xmax;
y_ref=0:r_merge:ymax;

% make sure the last entry in x_ref and y_ref are xmax and ymax

if max(x_ref)<xmax
    x_ref=[x_ref xmax];
end
if max(y_ref)<ymax
    y_ref=[y_ref ymax];
end


%% Loop through x_ref (i) and y_ref (j) 
% map anchorpoints of all power (m) values to it and store in separate
% struct "Merged_beads" with # of rows (k)

Merged_beads=[];
k=1;


for i=1:length(x_ref)-1
    x_lo=x_ref(i);
    x_hi=x_ref(i+1);
    for j=1:length(y_ref)-1
        y_lo=y_ref(j);
        y_hi=y_ref(j+1);
        temp_AP=[];
        temp_AP_all=[];
        temp_P_all=[];
        temp_F_all=[];
        for m=1:length(FC)
            comp_beads=FC(m).Anchorpoint;
            x_comp=comp_beads(:,1);
            y_comp=comp_beads(:,2);
            idx_merge=find(x_comp>=x_lo & x_comp<x_hi & y_comp>=y_lo & y_comp<y_hi);
            
            if not(isempty(idx_merge)) % if idx_merge is empty, that means that 
                % no Anchorpoints fall in the current mesh point.            
                temp_AP=comp_beads(idx_merge,:);
                temp_AP_all=[temp_AP_all; temp_AP];
                temp_P_all=[temp_P_all; FC(m).Power;];
                temp_F_all=[temp_F_all; mean(FC(m).Force(idx_merge))];
            end
        end 
        [r, c]=size(temp_AP_all);

        if r>1 % only add to struct, if more than 1 anchorpoint 
            % (number of rows >1) fall in the same mesh point
            Merged_beads(k).AP_list=temp_AP_all;
            Merged_beads(k).AP=mean(temp_AP_all,1); % calclate the average x 
            % and y for the mesh point
            Merged_beads(k).F=temp_F_all';
            Merged_beads(k).P=temp_P_all';
            k=k+1;
        end 
        
    end
end



end