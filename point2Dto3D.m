function point3f = point2Dto3D(point2f, img, robotHeight, d, robotAngle, cameraAngle, focalLength)
    [h, w] = size(img);
    x = (point2f.x - w / 2);
    y = double(h / 2 - point2f.y);
    
    angle1 = atan2(y, focalLength);
    angle2 = (pi / 2 - cameraAngle) + angle1;
    dprime = tan(angle2) * robotHeight;
    xdelta = dprime - d;
    
    z1 = sqrt(((d + xdelta) ^ 2) + robotHeight ^ 2);
    
    ydelta = x / focalLength * z1;
    
    x1 = d + xdelta;
    y1 = ydelta;
    
    px = x1 * cos(robotAngle) - y1 * sin(robotAngle);
    py = x1 * sin(robotAngle) + y1 * cos(robotAngle);
    pz = 0;
    
    px = px / 50;
    py = py / 50;
    pz = pz / 50;
    point3f = Point3f(px, py, pz);
end