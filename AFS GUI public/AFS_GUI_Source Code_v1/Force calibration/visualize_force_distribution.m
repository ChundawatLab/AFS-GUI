function M=visualize_force_distribution(M,xmax,ymax,Fmin,Fmax,zmin,zmax,showbeads)
% M=visualize_force_distribution(M, xmax, ymax, Fmin, Fmax, zmin, zmax,
% showbeads). After force calibration, this function calculates the force
% at 1 micrometer for the fitted beads in FoV, adds it to the M-struct and
% displays a 'heatmap' of the forces and the z-node in the range defined by
% Fmin/max and zmin/max along with the histograms for both. Showbeads is a
% T/F indicator displaying or omitting the display of individual beads in
% the plot


%% Add force at 1 micrometer to the struct
z=1; % (micrometer)

APx=[]; % temp arrays for anchor point positions
APy=[];

for i=1:length(M.ROI)
    % define parameters
    parameters=M.ROI(i).fitp;
    fo=parameters(1); %in (pN um)
    kp=parameters(2); %in (1/um)
    phip=parameters(3); %in (-)

    % compute force at 1 micrometer
    M.ROI(i).F=fo.*kp.*sin(2*(kp.*z+phip));

    % write anchor points in temp array
    APx=[APx, M.ROI(i).Anchorpoint(1)];
    APy=[APy, M.ROI(i).Anchorpoint(2)];
end

%% display a force heatmap


min_x = min(APx);
max_x = max(APx);
min_y = min(APy);
max_y = max(APy);


% griddata
[xi, yi] = meshgrid(linspace(min_x,max_x), linspace(min_y,max_y));
vi = griddata(APx, APy, [M.ROI.F], xi, yi,'v4');

% convert to micrometer for plot
xi=xi*10^6;
yi=yi*10^6;

% create figure
figure('Name',M.Metadata.filename, 'IntegerHandle','off');
subplot(2,2,1)
surf(xi, yi, vi, 'edgecolor', 'none');
clim([Fmin Fmax]); % set scale for colorbar
c = colorbar;
c.Label.String = 'Force at 1 micrometer (pN)';

xlabel('x (\mum)');
ylabel('y (\mum)');
view(2);

% add data points to plot
hold on
% convert to micrometer for plot
APx=APx*10^6;
APy=APy*10^6;

if showbeads==1
    plot3(APx, APy, [M.ROI.F]+100, 'or');
end

%reverse y axis to align with FoV in AFS and set limits
set (gca,'YDir','reverse')
xlim([0 xmax])
ylim([0 ymax])

%% plot force histogram
subplot(2,2,2)
histogram([M.ROI.F])
xlabel('Force at 1 micrometer (pN)')
ylabel('Count (-)')
legend(['N= ',num2str(length([M.ROI.F]))])

%% plot heatmap for z-node

vi = griddata(APx, APy, [M.ROI.znode], xi, yi,'v4');

subplot(2,2,3)
surf(xi, yi, vi, 'edgecolor', 'none');
clim([zmin zmax]); % set scale for colorbar

xlabel('x (\mum)');
ylabel('y (\mum)');
c = colorbar;
c.Label.String = 'z-node (\mum)';
view(2);
hold on

if showbeads==1
    plot3(APx, APy, [M.ROI.znode]+100, 'or');
end

%reverse y axis to align with FoV in AFS and set limits
set (gca,'YDir','reverse')
xlim([0 xmax])
ylim([0 ymax])

%% plot z-node histogram
subplot(2,2,4)
histogram([M.ROI.znode])
xlabel('z-node (\mum)')
ylabel('Count (-)')
legend(['N= ',num2str(length([M.ROI.znode]))])
end