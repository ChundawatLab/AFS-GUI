function [z_num] = force_stokes(x, xdata, z_meas,dbead)
% function [z_num] = force_stokes(x, xdata, z_meas,dbead). Returns the
% numerical appriximation for z based on the fit parameters and time data.
% x : fit parameters [fo, kp, phip] in units [(pN um), (1/um), (-)], xdata
% : time vector (seconds), z_meas : shifted z position data (micrometer),
% dbead: bead diameter (micrometer)
%
% A for loop is used to create a new vector tstep since the time vector
% points are not equally spaced out.
% 
% The lambda value (for viscosity correction)  depends on z position so a
% for loop is used to create the array.
%
% The constants R, kp, f0, phip, are substituted into the velocity
% function. The velocity function is dependent on the z-position of the
% bead. Another for loop numerically integrates velocity using trapezoidal
% integration

% To look out for:
%       A z position (z_meas) of 0 will produce NaN because the
%       denominator of the velocity goes to 0 (lambda goes to 0 because L
%       = R)
%       The final numerically calculated z vector is in micrometer. The
%       inputted z_meas should already be converted from m to um. 
%       The density of media and bead and media viscosity are hardcoded and
%       need to be changed accordingly at line 52 and 53

% separate fit parameters
f0 = x(1);
kp = x(2);
phip = x(3);

% calculate bead radius and L
R = dbead/2;
L = z_meas + R;

% initialize timestep and create delta t array
tstep = 0;
for i = 2:length(xdata)
    tstep = [tstep; xdata(i)-xdata(i-1)];
end

% Brenner (analytic) as per equation 7 of Nguyen et al (2021)
a = acosh(L/R);
s = 0;
for i = 1:1:100
    s = s + ( i.*(i+1)./((2.*i-1).*(2.*i+3)) ) .* ( (( 2.*sinh((2.*i+1).*a)+(2.*i+1).*sinh(2.*a) )./( 4.*((sinh((i+1/2).*a)).^2)-((2.*i+1).^2).*(sinh(a)).^2 )) - 1);
end
lambda = 4/3 .* sinh(a) .* s;

% calculate the gravitational force in pN 
rho_m=998; % media density (kg/m^3)
rho_p=1050; % particle density (kg/m^3)
Fg=(4/3*pi*(R*10^-6)^3*(rho_p-rho_m)*9.81)*10^12; % in piconewton

% calculate drag force portion 
eta=1; % media dyamic viscosity (mPa*s)
Fd=(pi.*(R).*(eta).*lambda)*10^-3; % in pN*(um/s)

% calculate acoustic force (pN)
Fac=f0.*kp.*sin(2.*(kp .* z_meas + phip));

% calculate the velocity (um/s)
dzdt = (Fac-Fg)./Fd;

% the first entry of the velocity is NaN due cosh-1(L/R) at z=0) and
% manually changed to 0
dzdt(1) = 0;

% numerically integrate velocity to obtain z (micrometer)
z_num = 0;
for i = 2:length(tstep)
    z_num = [z_num; z_num(i-1) + tstep(i-1)*((dzdt(i-1)+dzdt(i))/2)];
end
end