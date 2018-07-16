addpath('media')

% Line detection parameters
clusterProximityThreshold = 0.05;
netAngleThreshold = pi/10;
scalerho = 1/500;
lineTrackingThreshold = 0.2; % Cannot jump 1 per time step

addpath('vectormath')

% Test files
videotestfile = strcat(pwd,'/media/videos/2.mp4');