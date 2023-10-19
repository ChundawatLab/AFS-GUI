function plot_force_histogram(axis,axis2,M)
% plot_force_histogram(axis,axis2,M). Plots force histograms. Removes 0
% power values from histogram, but not M struct

    H=[M.ROI.RuptureForce];
    H(H==0)=[]; %remove zero rupture power values
    min(H);
    max(H);
    size_H=length(H);

    histogram(axis,H);
    legend(axis,['N= ',num2str(size_H)]);

    LR = [M.ROI.LoadingRate];
    LR(LR==0)=[];
    histogram(axis2,LR);

end
