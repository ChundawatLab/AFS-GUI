function sample_heatmap(Heatmap_data,xmax,ymax)
% sample_heatmap(Heatmap_data,xmax,ymax). Heatmap_data is the data struct
% for the heatmap, xmax and ymax are the limits for the FoV depending on
% the magnification. Randomly selects 9 traces and plots the
% force-power-fit along with the location in the FoV as a pop-up window.

% sample 9 IDs
    ID=rand(9,1);
    ID=ID.*length(Heatmap_data);
    ID=round(ID);
    
figure
hold on
t=tiledlayout(3,6,'TileIndexing','columnmajor'); % create tiles, which 
% are easier to manipulate than subplots

    for i=1:length(ID)
        nexttile
        plot_power_fit(Heatmap_data,ID(i),i)
        text()
    end

    nexttile([3 3])
    AP = vertcat(Heatmap_data(:).AP) * 10^6; % conversion to micrometer
    AP=AP(ID,:); % just keep the beads identified in ID
    x_pos = AP(:,1);
    y_pos = AP(:,2);
   
    % plot numbers instead of the anchorpoint at the position of the
    % anchorpoint
    for n=1:length(AP)
        text(x_pos(n),y_pos(n),num2str(n));
    end

    % set scale of plot
    xlabel('x (\mum)')
    ylabel('y (\mum)')
    set(gca,'YDir','reverse')
    xlim(gca,[0 xmax]) 
    ylim(gca,[0 ymax])  

    % resize figure
    x0=100;
    y0=100;
    width=1200;
    height=600;
    set(gcf,'position',[x0,y0,width,height])
end