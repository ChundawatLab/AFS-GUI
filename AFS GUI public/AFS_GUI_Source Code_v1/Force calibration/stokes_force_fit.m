function M = stokes_force_fit(M, lb, ub, x0,Rmin,dbead)
% function M = stokes_force_fit(M, lb, ub, x0,Rmin,dbead). M is the Main
% data struct, lb and ub are the lower and upper bounds, xo are the
% starting parameters, Rmin is the minimum R-square value to achieve and
% dbead is the bead diameter in micrometer.
%
% The time is unchanged for each bead so the part of M that has the
% time is called outside of the for loop and set as a temporary variable.
% 
% The options may change for each loop and are reset at the beginning for
% each trace for each bead.
% 
% The built-in function lsqcurvefit is called to determine the best fit
% parameters to the measured z position. Within the lsqcurvefit, the
% force_stokes function is called to find the numerically calculated z
% position of the bead.
% 
% The new fitted z position vector is calculated by calling force_stokes
% with the optimal fit parameters.
%
% To measure goodness-of-fit of the curve, the R^2 value is calculated
%
% Finally, the new fit parameters, R^2 value, and fitted z position for
% each bead are appended onto the struct M as separate fields
%
% To look out for:
%       The inputted measured z vector is in SI units and should be in um
%       (the function converts to micrometer)
%       The final fitted z vector is in um and should be in SI units within
%       the struct (the function converts to micrometer)


% Get the time data
xdata = M.FC.Time_FC;


for i = 1:length(M.ROI) % main loop for each bead
    new_x0 = x0;
    options = optimoptions('lsqcurvefit','Algorithm','levenberg-marquardt','OptimalityTolerance', 1e-6, 'FunctionTolerance', 1e-6, 'StepTolerance', 1E-6);
    options = optimoptions(options, 'MaxFunctionEvaluations',400,'MaxIterations',400);
    options = optimoptions(options,'Display','off');

    loop_run = 0;

    % conversion to micrometer
    z_meas = M.ROI(i).z_FC.*(10^6); 

    % check initial conditions to see if  there are complex values. If so,
    % skip the curvefit in line 53
    initial_z=force_stokes(x0,xdata,z_meas,dbead); 

    while loop_run < 2 % sub-loop running for each bead until R^2 criteria is met
        if isreal(initial_z) && sum(isnan(initial_z))==0 % only enter curve fitting if there are no imaginary values or NaN

            % run the curvevit and store parameters in pull_fit_parameters
            [pull_fit_parameters,~,~,~,~] = lsqcurvefit(@(x, xdata)force_stokes(x, xdata, z_meas,dbead), new_x0, xdata, z_meas, lb, ub, options);

            % obtain the fitted z data
            z_fit = force_stokes(pull_fit_parameters, xdata, z_meas,dbead);

            % calculate R^2 (RSQ)
            SSE = sum((z_meas - z_fit).^2);
            SST = sum((z_meas - mean(z_meas)).^2);
            RSQ = 1 - (SSE/SST);

            % write fit parameters to struct
            M.ROI(i).fitp = pull_fit_parameters;
            M.ROI(i).RSQ = RSQ;
            M.ROI(i).z_fit = z_fit.*(10^-6);


            if (RSQ < Rmin && RSQ>0) % increase iterations and decrease
                % tolerances if the fit is somehow okay, but not yet greater than Rmin
                loop_run = loop_run + 1;
                new_x0 = pull_fit_parameters;
                options.MaxIterations = options.MaxIterations*10;
                options.MaxFunctionEvaluations=options.MaxFunctionEvaluations*10;
                options.StepTolerance = options.StepTolerance*0.1;
                options.OptimalityTolerance = options.OptimalityTolerance*0.1;
                options.FunctionTolerance=options.FunctionTolerance*0.1;
                options.StepTolerance=options.StepTolerance*0.1;
            else % if R^2 criteria is satisfied
                M.ROI(i).fitp = pull_fit_parameters;
                M.ROI(i).RSQ = RSQ;
                M.ROI(i).z_fit = z_fit.*(10^-6);
                loop_run = 10; % exit while loop
            end
        else % write all zeros for fitting data to that bead
            M.ROI(i).fitp=[0 0 0];
            M.ROI(i).RSQ=0;
            M.ROI(i).z_fit=zeros(length(z_meas),1);
            loop_run=10; % exit wile loop
        end
    end
end
end

