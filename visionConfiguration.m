addpath('media')

% Line detection parameters
clusterProximityThreshold = 0.2;
netAngleThreshold = pi/10;
scalerho = 1/500;
lineTrackingThreshold = 100; % Cannot jump 100 per time step

addpath('vectormath')