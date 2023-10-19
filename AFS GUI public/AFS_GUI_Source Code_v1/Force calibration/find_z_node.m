function M=find_z_node(M)
% M=find_z_node(M), where M is the data struct. Appends M with the position
% in micrometer where F=0.

for i=1:length(M.ROI)
    % define parameters 
        parameters=M.ROI(i).fitp;
        fo=parameters(1); %in (pN um)
        kp=parameters(2); %in (1/um)
        phip=parameters(3); %in (-)
    
    % solve for z(F=0); since we have a sin(z), there exist mutliple roots.
    % Run multiple rounds with different initial guesses and check which one is
    % the smallest positive value 
    
    x0=0; %initial starting point 
    z=[];
    options = optimoptions('fsolve','Display','off');
    for j=1:5
        z_temp=fsolve(@(z) fo.*kp.*sin(2*(kp.*z+phip)),x0,options);
        z= [z z_temp];
        x0=x0+10;
    end
       
    % find the smallest positive value for z, which is the z-node we are
    % looking for
       z=unique(z);
       pos=z>0;
       z=z(pos);
       if isempty(z)
           z=0; % some fits produce no positive z values, hence 0 is 
           % assigned so that subsequent functions don't produce errors due
           % to empty fields
       end
       M.ROI(i).znode=min(z);
    
end
end