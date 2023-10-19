function [LR_fit, RF_fit]=plot_histogram_fits(M,RF_plot,LR_plot,RF_fit_choice,LR_fit_choice)
% plots rupture force and loading rate fits LR_fit and RF_fit are the fit
% objects for loading rate and rupture force. RF_plot and LR_plot are the
% plot objects and RF_fit_choice and LR_fit_choice are the choice of fit
% (normal vs lognormal) for the rupture force.

%% fit data and plot distribution

    % clear plots

    cla(LR_plot)
    cla(RF_plot)

    RF=[M.ROI.RuptureForce];
    RF(RF==0)=[]; %remove zero rupture power values
    size_H=length(RF);
    
    RF_fit=fitdist(RF',RF_fit_choice); 
    histfit(RF_plot,RF,[],RF_fit_choice); 

    LR = [M.ROI.LoadingRate];
    LR(LR==0)=[];
    LR_fit=fitdist(LR',LR_fit_choice); 
    histfit(LR_plot,LR,[],LR_fit_choice);

%% override mean and sigma in fit object

% the statement converts lognormal values to normal values. This
% overrides the fit object, thus no confidence intervals will be
% displayed in the text below. The else statement is used so that the
% output (as text) is the same structure for both cases
    if isequal(RF_fit_choice,'lognormal') 
        RF_fit.mu=exp(RF_fit.mu);
        RF_fit.sigma=exp(RF_fit.sigma);
    else
        RF_fit.mu=RF_fit.mu;
        RF_fit.sigma=RF_fit.sigma;
    end

    if isequal(LR_fit_choice,'lognormal') 
        LR_fit.mu=exp(LR_fit.mu);
        LR_fit.sigma=exp(LR_fit.sigma);
    else
        LR_fit.mu=LR_fit.mu;
        LR_fit.sigma=LR_fit.sigma;
    end


%% create text output of mu and sigma
    
    % create string
    LR_fit=evalc('LR_fit');
    RF_fit=evalc('RF_fit');

    % clean up string output by removing hyperlink at the beginning of
    % string
    LR_fit = eraseBetween(LR_fit,"LR_fit","</a>",'Boundaries','inclusive');
    RF_fit = eraseBetween(RF_fit,"RF_fit","</a>",'Boundaries','inclusive');
    
    %removes first 3 'empty spaces'
    LR_fit=eraseBetween(LR_fit,1,3); 
    RF_fit=eraseBetween(RF_fit,1,3);
end
