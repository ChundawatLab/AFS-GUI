function FC= prep_struct_for_merging(N,z,axis)
% FC=prep_struct_for_merging(N, z, axis) restructures N such that the format can
% be used for the merging function. Force at z will also be calculated.
% Data will be summarized by power values, where each row corresponds to
% one power value

cla(axis)

%% Calculate the force at z:

for i=1:length(N)
    fo=N(i).fo;
    kp=N(i).kp;
    phip=N(i).phip;

    F=fo*kp*sin(2*(kp*z+phip));

    N(i).F=F;
end

%% Reorganize struct

% check how many different power values are contained in the struct
unique_P=unique([N.Power]);
count_P=length(unique_P); 

% write Anchorpoint and force to temporary arrays
temp_APmatrix=[N.APx; N.APy]';
temp_F=[N.F]';

for i=1:count_P
    % find indices for the power value
        idx_P=find([N.Power]==unique_P(i));

    % only keep indices associated with the power value that is processed
        temp_APmatrix_P=temp_APmatrix(idx_P,:);
        temp_F_P=temp_F(idx_P);

    % write into new struct
        FC(i).Power=unique_P(i);
        FC(i).Anchorpoint=temp_APmatrix_P;
        FC(i).Force=temp_F_P;

end

end