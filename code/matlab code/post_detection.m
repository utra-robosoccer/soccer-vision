% RGB = imread('soccerfield.png');
% I  = rgb2gray(RGB);
% BW = edge(I,'canny');
% [H,T,R] = hough(BW,'RhoResolution',0.5,'Theta',-90:0.5:89);

%   Read image into workspace.
input_image  = imread('soccerfield3.png');

% convert rgb to grascale
rotated_image = rgb2gray(input_image);

%Create a binary image.
binary_image = edge(rotated_image,'canny');

%Create the Hough transform using the binary image.
start_angle = -90;
end_angle = 89;
theta_resolution = 0.5;

[H,T,R] = hough(binary_image, 'Theta', start_angle:theta_resolution:end_angle);

%Find peaks in the Hough transform of the image.
P  = houghpeaks(H,10,'threshold',ceil(0.5*max(H(:))));

%Find lines
hough_lines = houghlines(binary_image,T,R,P,'FillGap',15,'MinLength',50);    

% Plot the detected lines
figure, imshow(rotated_image), hold on
max_len = 0;

for k = 1:length(hough_lines)
   xy = [hough_lines(k).point1; hough_lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
   
   %[m1,b1] = slope(hough_lines(k).point1[0],hough_lines(k).point2[0], hough_lines(k).point1[1], hough_lines(k).point2[1])
   %[m2, b2] = slope(hough_lines(k+1).point1[0], hough_lines(k+1).point2[0], hough_lines(k+1).point1[1], hough_lines(k+1).point2[1])

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
   
   tolerance = 10;
   %Generalize this code:
       for j =1:length(hough_lines)
            new_xy = [hough_lines(j).point1; hough_lines(j).point2];
            comp1x = abs(xy(1,1) - new_xy(1,1)) < tolerance;
            comp1y = abs (xy(1,2) - new_xy(1,2)) < tolerance;
            comp2x = abs (xy(1,1) - new_xy(2,1)) < tolerance;
            comp2y = abs (xy(1,2) - new_xy(2,2)) < tolerance;
            
            cmp1x = abs (xy(2,1) - new_xy(1,1)) < tolerance;
            cmp1y = abs (xy(2,2) - new_xy(1,2)) < tolerance;
            cmp2x = abs (xy(2,1) - new_xy(2,1)) < tolerance;
            cmp2y = abs (xy(2,2) - new_xy(2,2)) < tolerance;
            
            if k ~= j && ((comp1x&&comp1y)|| (comp2x && comp2y))
                plot(xy(1,1),xy(1,2),'o','LineWidth',6,'Color','blue');
                
            elseif k ~=j && ((cmp1x && cmp1y)|| (cmp2x && cmp2y))
                plot(xy(2,1),xy(2,2),'o','LineWidth',6,'Color','blue');
            end

       end
   
end  