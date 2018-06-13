% Camera size is 540 x 960. Draw square
close all;

cx = 960 / 2;
cy = 540 / 2;
width = 100;
lines = [
    cx + 480, cy + 270, cx + 480, cy - 270;
    cx + 480, cy - 270, cx - 480, cy - 270;
    cx - 480, cy - 270, cx - 480, cy + 270;
    cx - 480, cy + 270, cx + 480, cy + 270;
    
    cx + width, cy + width, cx + width, cy - width;
    cx + width, cy - width, cx - width, cy - width;
    cx - width, cy - width, cx - width, cy + width;
    cx - width, cy + width, cx + width, cy + width;
    cx, cy - width, cx, cy + width;
    cx - width, cy, cx + width, cy;
    cx + width/2, cy + width, cx + width/2, cy - width;
    cx - width/2, cy + width, cx - width/2, cy - width;
    cx - width, cy - width/2, cx + width, cy - width/2;
    cx - width, cy + width/2, cx + width, cy + width/2;
    ];

% lines = [675,1,675,540;176,1,199,540;1,1,1,2;1,1,1,2;1,1,1,2;1,1,1,2;1,1,1,2;1,1,1,2;1,331,960,320]
% drawfield(lines)

img = zeros(540, 960);
robotHeight = 500;
d = 0;
robotAngle = 0;
cameraAngle = pi/6; % Looking 30 degrees down
focalLength = 200; % Needs to be calibrated

lines3D = lines2Dto3D(lines, img, robotHeight, d, robotAngle, cameraAngle, focalLength);

lines3Dplane = lines3D(:, [1,2,4,5]);
drawfield(lines3Dplane)
