function lines3D = lines2Dto3D(lines, img, robotHeight, d, robotAngle, cameraAngle, focalLength)
    [r, ~] = size(lines);
    
    lines3D = zeros(r,6);
    
    for i = 1:length(r)
        p1 = Point2f(lines(i,1), lines(i,2));
        p2 = Point2f(lines(i,3), lines(i,4));
        
        p1_3d = point2Dto3D(p1, img, robotHeight, d, robotAngle, cameraAngle, focalLength); 
        p2_3d = point2Dto3D(p2, img, robotHeight, d, robotAngle, cameraAngle, focalLength);
        
        % Wrap into a big ass matrix
        l = Segment3f(p1_3d, p2_3d);
        lines3D(i,1) = l.p1.x;
        lines3D(i,2) = l.p1.y;
        lines3D(i,3) = l.p1.z;
        lines3D(i,4) = l.p2.x;
        lines3D(i,5) = l.p2.y;
        lines3D(i,6) = l.p2.z;
    end
end