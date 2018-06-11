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
            obj.lines{1} = Segment2f(Point2f(0, 0), Point2f(0, 0));
            obj.lines{2} = Segment2f(Point2f(0, 0), Point2f(0, 0));
            obj.lines{3} = Segment2f(Point2f(0, 0), Point2f(0, 0));
            obj.lines{4} = Segment2f(Point2f(0, 0), Point2f(0, 0));
            obj.lines{5} = Segment2f(Point2f(0, 0), Point2f(0, 0));
            obj.lines{6} = Segment2f(Point2f(0, 0), Point2f(0, 0));
            obj.lines{7} = Segment2f(Point2f(0, 0), Point2f(0, 0));
            obj.lines{8} = Segment2f(Point2f(0, 0), Point2f(0, 0));
            obj.lines{9} = Segment2f(Point2f(0, 0), Point2f(0, 0));
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
            
            if nargin ~= 2
               return; 
            end
            
            [l, w] = size(lineArray);
            if l ~= 9 || w ~= 6
                return;
            end
            
            for i = 1:9
                obj.lines{i}.p1.x = lineArray(i,1);
                obj.lines{i}.p1.y = lineArray(i,2);
                obj.lines{i}.p2.x = lineArray(i,3);
                obj.lines{i}.p2.y = lineArray(i,4);
            end
            
            
            % Field lines
            enemyLeftPost = obj.lines{1};
            enemyRightPost = obj.lines{2};
            friendlyLeftPost = obj.lines{3};
            friendlyRightPost = obj.lines{4};
            enemyBackLine = obj.lines{5};
            leftFieldLine = obj.lines{6};
            rightFieldLine = obj.lines{7};
            friendlyBackLine = obj.lines{8};
            centerLine = obj.lines{9};
            
            % Find the intersection
            if leftFieldLine.isValid && enemyBackLine.isValid
                obj.intersect{1} = Segment2f.intersection(leftFieldLine, enemyBackLine);
            end
            if enemyLeftPost.isValid && enemyBackLine.isValid
                obj.intersect{2} = Segment2f.intersection(enemyLeftPost, enemyBackLine);
            end
            if enemyRightPost.isValid && enemyBackLine.isValid
                obj.intersect{3} = Segment2f.intersection(enemyRightPost, enemyBackLine);
            end
            if rightFieldLine.isValid && enemyBackLine.isValid
                obj.intersect{4} = Segment2f.intersection(rightFieldLine, enemyBackLine);
            end
            if leftFieldLine.isValid && centerLine.isValid
                obj.intersect{5} = Segment2f.intersection(leftFieldLine, centerLine);
            end
            if rightFieldLine.isValid && centerLine.isValid
                obj.intersect{6} = Segment2f.intersection(rightFieldLine, centerLine);
            end
            if leftFieldLine.isValid && friendlyBackLine.isValid
                obj.intersect{7} = Segment2f.intersection(leftFieldLine, friendlyBackLine);
            end
            if friendlyLeftPost.isValid && friendlyBackLine.isValid
                obj.intersect{8} = Segment2f.intersection(friendlyLeftPost, friendlyBackLine);
            end
            if friendlyRightPost.isValid && friendlyBackLine.isValid
                obj.intersect{9} = Segment2f.intersection(friendlyRightPost, friendlyBackLine);
            end
            if rightFieldLine.isValid && friendlyBackLine.isValid
                obj.intersect{10} = Segment2f.intersection(rightFieldLine, friendlyBackLine);
            end
            
            pointArray = zeros(10, 2);
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
