function plot_power_fit(H,ID,n)
% plot_power_fit(H, ID,n). Plots the power fit for manual inspection.

% obtain power and force values
power = (H(ID).P)';
force = (H(ID).F)';
Slope= H(ID).S ;
power = vertcat(0, power); % add origin as a point 
force = vertcat(0,force);

% create line
forcefit = power(:)*Slope;

% plot data
plot(power, force,'or');
hold ("on");
plot(power, forcefit,'-b');
grid('on'  );
axis([0 max(power) 0 max(force)]);
xlabel('Power (%)')
ylabel('Force (pN)')

txt = {num2str(Slope), ' (pN/%)'};

text(max(power)*0.1,max(force)*0.8,txt)

text(max(power)*0.8,max(force)*0.1,num2str(n))
hold ("off");
end


