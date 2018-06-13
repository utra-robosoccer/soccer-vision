classdef Line2f < handle
    %LINE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        rho
        theta
    end
    
    methods
        function obj = Line2f(rho,theta)
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
        function valid = isValid(obj)
            valid = ~(obj.rho == 0 && obj.theta == 0);
        end
    end
    
    methods(Static)
        function intersect = screenIntersection(obj1, obj2)
            %METHOD1 Finds the screen intersection between 2 points
            rho1 = obj1.rho;
            theta1 = obj1.theta;
            rho2 = obj2.rho;
            theta2 = obj2.theta;
            
            A = [cos(theta1), sin(theta1);
                cos(theta2), sin(theta2)];
            
            b = [rho1; rho2];
            
            r = A \ b;
            
            % Create the intersection
            intersect = Point2f(r(1), r(2));
        end
    end
end

