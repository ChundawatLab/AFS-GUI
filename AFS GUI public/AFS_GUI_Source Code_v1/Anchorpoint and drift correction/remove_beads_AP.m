function [M,idx_remove]=remove_beads_AP(M, xmax, ymax)
% [M,idx_remove]=remove_beads_AP(M,xmax,ymax). M is the data struct.
% Function removes beads which are outside the bounds defined by xmax and
% ymax and any negative anchorpoint coordinates as well as returns their
% indices to update the main list box.

idx_remove=[];

for i=1:length(M.ROI)
    AP=M.ROI(i).Anchorpoint*10^6; %conversion to micrometer

    % check if anchorpoint is outside bounds
    if AP(1)<0 || AP(2)<0 || AP(1)>xmax || AP(2)>ymax
        idx_remove=[idx_remove, i];
    end
end

M.ROI(idx_remove) = []; %removes the traces from struct

end