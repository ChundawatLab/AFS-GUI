function F=force_at_z(M,ID,z)
% returns the array of forces at given z-positions for bead specified in
% ID. F is the same size as z. The unit of z is micrometer. The output
% vector F is in pN.

% define parameters 
    parameters=M.ROI(ID).fitp;
    fo=parameters(1); %in (pN um)
    kp=parameters(2); %in (1/um)
    phip=parameters(3); %in (-)

% compute force
F=fo.*kp.*sin(2*(kp.*z+phip));

end
