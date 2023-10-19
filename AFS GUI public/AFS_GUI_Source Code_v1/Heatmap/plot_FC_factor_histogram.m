function [fitpar]=plot_FC_factor_histogram(heatmap_data,UIaxes)
% [fitpar]=plot_FC_factor_histogram(heatmapdata,UIaxes), plots force
% calibration factor histogram

%% plot histogram and get fitparameters
histfit(UIaxes,[heatmap_data.S],[],'normal');
fitpar=fitdist([heatmap_data.S]','normal');

%% create text output of mu and sigma

% create string
fitpar=evalc('fitpar');


% clean up string output by removing hyperlink at the beginning of
% string
fitpar = eraseBetween(fitpar,"fitpar","</a>",'Boundaries','inclusive');

%removes first 3 'empty spaces'
fitpar=eraseBetween(fitpar,1,3);
end