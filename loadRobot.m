% Load Paths
addpath('../soccer-control')
addpath('../soccer-vision')
addpath('../soccer-utility')
addpath('media')
addpath('vectormath')

% VSS_MODE = 2 for Video file, 1 for Gazebo
VSS_MODE = 1;

% Connect Robot
if VSS_MODE == 1
    connectRobot;
end

% Camera Parameters
focalLength = 700; % Ratio for focal length vs pixel

% Line detection parameters
clusterProximityThreshold = 0.05;
netAngleThreshold = pi/10;
scalerho = 1/500;
lineTrackingThreshold = 0.2; % Cannot jump 1 per time step

% Test files
videotestfile = strcat(pwd,'/soccer-vision/media/videos/2.mp4');