classdef Line2f < handle
    %LINE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        rho
        theta
    end
    
    methods
        function obj = line(rho,theta)
            %LINE Construct an instance of this class
            %   Detailed explanation goes here
            obj.rho = rho;
            obj.theta = theta;
            
            normalize(obj);
        end
        function normalize(obj)
           if(obj.rho < 0)
              obj.rho = -obj.rho;
              obj.theta = obj.theta + pi;
           end
        end
    end
    
    methods(Static)
        function intersect = intersection(obj1, obj2)
            %METHOD1 Finds the screen intersection between 2 points
            rho1 = obj1.rho;
            theta1 = obj1.theta;
            rho2 = obj2.rho;
            theta2 = obj2.theta;
            
            x = (rho1 / cos(pi/2 - theta1) - rho2 / cos(pi/2 - theta2)) / (tan(theta2 - pi/2) - tan(theta2 - pi/2));
            y = rho1 / cos(pi/2 - theta1) + tan(theta1 - PI / 2) * x;
            
            % Create the intersection
            intersect = Point2f(x, y);
        end
    end
end

