classdef findFieldAndPostIntersections < matlab.System
    % Find Field and Post Intersection
    % Numbering order of the lines
    % 1. Enemy Left post
    % 2. Enemy Right post
    % 3. Friendly Left Post
    % 4. Fieldly Right Post
    % 5. Enemy Back Line
    % 6. Left Field line
    % 7. Right Field line
    % 8. Frieldly Back line
    % 9. Center Line

    % Numbering order of the points (centers last)
    %  *----*----*----*
    %  |    |____|    |
    %  |              |
    %  *--------------*
    %  |     ____     |
    %  |    |    |    |
    %  *----*----*----*
    
    % Public, tunable properties
    properties

    end

    properties(DiscreteState)
        
    end

    % Pre-computed constants
    properties(Access = private)
        lines = cell(9,1);
        intersect = cell(10,1);
    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            obj.lines{1} = Line2f(0,0);
            obj.lines{2} = Line2f(0,0);
            obj.lines{3} = Line2f(0,0);
            obj.lines{4} = Line2f(0,0);
            obj.lines{5} = Line2f(0,0);
            obj.lines{6} = Line2f(0,0);
            obj.lines{7} = Line2f(0,0);
            obj.lines{8} = Line2f(0,0);
            obj.lines{9} = Line2f(0,0);
            obj.intersect{1} = Point2f(0,0);
            obj.intersect{2} = Point2f(0,0);
            obj.intersect{3} = Point2f(0,0);
            obj.intersect{4} = Point2f(0,0);
            obj.intersect{5} = Point2f(0,0);
            obj.intersect{6} = Point2f(0,0);
            obj.intersect{7} = Point2f(0,0);
            obj.intersect{8} = Point2f(0,0);
            obj.intersect{9} = Point2f(0,0);
            obj.intersect{10} = Point2f(0,0);
        end

        function pointArray = stepImpl(obj,lineArray)
            
            pointArray = zeros(10, 2);
            if nargin ~= 2
               return; 
            end
            
            [l, w] = size(lineArray);
            if l ~= 9 || w ~= 2
                return;
            end
            
            for i = 1:9
                obj.lines{i}.rho = double(lineArray(i,2));
                obj.lines{i}.theta = double(lineArray(i,1));
            end
            
            for i = 1:10
                obj.intersect{i}.x = 0;
                obj.intersect{i}.y = 0;
            end
            
            z = 1;
            % Field and Line intersection
            for i = 1:4
                for j = 5:9
                    if (obj.lines{i}.isValid && obj.lines{j}.isValid && z <= 10)
                        obj.intersect{z} = Line2f.screenIntersection(obj.lines{i}, obj.lines{j});
                        z = z + 1;
                    end
                end
            end
            
            % Field and Field intersection
            for i = 5:9
                for j = 5:9
                    if (i <= j)
                        continue
                    end
                    if (obj.lines{i}.isValid && obj.lines{j}.isValid && z <= 10)
                        obj.intersect{z} = Line2f.screenIntersection(obj.lines{i}, obj.lines{j});
                        z = z + 1;
                    end
                end
            end
            
            
            for i = 1:10
               pointArray(i,1) = obj.intersect{i}.x;
               pointArray(i,2) = obj.intersect{i}.y;
            end
        end

        function resetImpl(~)
            % Initialize / reset discrete-state properties
        end
    end
end
