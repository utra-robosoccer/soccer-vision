classdef map2Dto3D < matlab.System
    % Converts a 2d to 3d point on the field
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties
        
    end

    properties(DiscreteState)

    end

    % Pre-computed constants
    properties(Access = private)

    end

    methods(Access = protected)
        function setupImpl(~)
            % Perform one-time calculations, such as computing constants
        end

        function [lines3D, points3D] = stepImpl(~, lines, points, img, robotHeight, d, robotAngle, cameraAngle, focalLength)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            [n, ~] = size(points);
            points3D = zeros(n,3);
            for i = 1:n
                p = Point2f(double(points(i,1)), double(points(i,2)));
                p3d = point2Dto3D(p, img, robotHeight, d, robotAngle, cameraAngle, focalLength);
                points3D(i, 1) = p3d.x;
                points3D(i, 2) = p3d.y;
                points3D(i, 3) = p3d.z;
            end
            lines3D = lines2Dto3D(double(lines), img, robotHeight, d, robotAngle, cameraAngle, focalLength);
        end

        function resetImpl(~)
            % Initialize / reset discrete-state properties
        end
    end
end
