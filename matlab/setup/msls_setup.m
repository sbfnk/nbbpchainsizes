clear

% data(ii) = number of measles transmission chains of size ii for Canada 
can_measles_csd = [35     5     3     1     0     1     0     1];
can_measles_csd(17) = 1;
can_measles_csd(30) = 1;
can_measles_csd(155) = 1;

% data(ii) = number of measles transmission chains of size ii for USA 
usa_measles_chains = [122    13    10     6     5     1     0     2     1     0     1     0     1 0 1];
usa_measles_chains(33) = 1;

% Coding for the one cluster of measles in the US of size six that had two
% primary cases
usa_measles_clusters = [1     2     6];

save ('setup\MSLS_DATA')