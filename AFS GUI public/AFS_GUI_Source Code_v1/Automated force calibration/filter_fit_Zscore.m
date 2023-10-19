function N=filter_fit_Zscore(N)
% N=filter_fit_Zscore(N). Removes any entries that are 3 standard
% deviations away from the mean. Applies to fo, kp, phip and z-node

% compile arrays for parameters
fo=[N.fo];
kp=[N.kp];
phip=[N.phip];
znode=[N.znode];

% find indices, where phip =0 or essentially 0 (10^-2)
idx_remove=find(phip<10^-2);

% get Z-score and take the absolute value so that filtering for Z>3 is
% easier.
fo=abs(zscore(fo));
kp=abs(zscore(kp));
phip=abs(zscore(phip));
znode=abs(zscore(znode));

% find where Z score is above 3 (or -3)
idx_fo=find(fo>3);
idx_kp=find(kp>3);
idx_phip=find(phip>3);
idx_znode=find(znode>3);

% get unique entries
idx_remove=unique([idx_remove, idx_fo, idx_kp, idx_phip, idx_znode]);

% remove entries
N(idx_remove)=[];

end