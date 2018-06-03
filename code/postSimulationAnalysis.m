function metrics = postSimulationAnalysis(varargin)
% function metrics = postSimulationAnalysis(bestdata, data, flag)
% This code extracts useful comparative information ("metrics" struct) from the area,
% centroid, and bounding box data that comes from the target_transmit buoy
% detection model
%
% It can also be used to view plots of the statistics, view a video
% comparison of the two algorithms or record the resulting comparison
% video. These can be specified using the 'plots','video', and 'record'
% flags, respectively. 
%
% To call this function use either of the following syntax;
% metrics = postSimulationAnalysis(bestdata,data) % compares the data input (second input) data to the best data (first input)
% metrics = postSimulationAnalysis(bestdata,data,flag1, flag2, ...)
% flag can be one or a combination of the following strings 'plots','video','record'
% i.e metrics = postSimulationAnalysis(bestdata,data,'video')  to show video
% 
% Flag Description;
% The flag ‘plots’ displays the “# Green/Red Algorithm Blobs per Closest Best Buoy” and whether the “Closest Best Buoy” has been missed by the Algorithm.
% The flag ‘video’ displays the raw video with bounding boxes overlaid onto it.
% The flag ‘record’ records the bounding boxes video to .avi format. Requires that 'video' flag be defined. 

% Copyright 2013, The MathWorks, Inc.

    clc
    close all

    % debug controls
    debugGreen = false; % l. 273
    debugRed = false; % l. 276
    res = [640 480]; 
%     res = [320 240];
%     badIdx.red = []; 
%     badIdx.green = []; 
    badIdx.red = [785:829 848:879 1276:1285]; % ignore red buoy detection from best algorithm during these indices 
    badIdx.green = [812:823 855:875]; % ignore green buoy detection from best algorithm during these indices

    %% process inputs
    % simulationTime = toc
    displayPlotsFlag = false; % display plots if true
    displayVideoFlag = false; % display video if true
    recordVideoFlag = false; % record video if true
    
    if nargin==2 % nargin gives number of input arguments
        bestdata = varargin{1};
        algdata = varargin{2};
    elseif nargin>2
        bestdata = varargin{1};
        algdata = varargin{2};
        for idx = 3:nargin
            if strcmp(varargin{idx},'plots')
                displayPlotsFlag = true;
            elseif strcmp(varargin{idx},'video')
                displayVideoFlag = true;
                debugGreen = true;
                debugRed = true;
                % dbstop - change these line numbers if the file has changed
                dbstop in postSimulationAnalysis at 274; 
                dbstop in postSimulationAnalysis at 277;
            elseif strcmp(varargin{idx},'record')
                recordVideoFlag = true;
            end
        end
    else
       error('Invalid arguments: provide 2 to 5 inputs. For both scenarios, the first data set is the "best data", the second data set is the "algorithm data" and the third is a flag. The valid flags are ''plots'',''video'',''record''') 
    end
   
    %% extract all data
    t = bestdata.green_bbox.Time;
    ns = length(t);

    best_red_area = bestdata.red_area.Data; % ns x 4
    best_red_centroid = bestdata.red_centroid.Data; % 4x2 x ns
    best_red_bbox = bestdata.red_bbox.Data; % 4x4 x ns

    best_green_area = bestdata.green_area.Data;
    best_green_centroid = bestdata.green_centroid.Data;
    best_green_bbox = bestdata.green_bbox.Data;

    alg_red_area = algdata.red_area.Data;
    alg_red_centroid = algdata.red_centroid.Data;
    alg_red_bbox = algdata.red_bbox.Data;

    alg_green_area = algdata.green_area.Data;
    alg_green_centroid = algdata.green_centroid.Data;
    alg_green_bbox = algdata.green_bbox.Data;

    %% calculate "metrics" cell array from defined metrics
    [green_bestClosestBuoyIdx,green_algClosestBuoyIdx,green_closestBuoyOverlapped,green_nBlobsPerClosest] = overlapmetrics(best_green_bbox,alg_green_bbox,'green',badIdx.green);   
    [red_bestClosestBuoyIdx,red_algClosestBuoyIdx,red_closestBuoyOverlapped,red_nBlobsPerClosest] = overlapmetrics(best_red_bbox,alg_red_bbox,'red',badIdx.red);
    
    best_green_closestArea = zeros(ns,1);
    alg_green_closestArea = zeros(ns,4);
    alg_green_closest_meanArea = zeros(ns,1);
    
    best_red_closestArea = zeros(ns,1);
    alg_red_closestArea = zeros(ns,4);
    alg_red_closest_meanArea = zeros(ns,1);

    for idx = 1:ns
       % green
       if green_bestClosestBuoyIdx(idx,:)~=0
            % calculate array of closest areas for best
            best_green_closestArea(idx) = best_green_area(idx,green_bestClosestBuoyIdx(idx,:));
            
           % calculate array of closest areas for algorithm
           tempidx = green_algClosestBuoyIdx(idx,green_algClosestBuoyIdx(idx,:)~=0);
           temp = alg_green_area(idx,tempidx);
           alg_green_closestArea(idx,1:length(temp)) = temp;
           alg_green_closest_meanArea(idx) = mean(temp); % could use sum for different metric
       else
           best_green_closestArea(idx) = 0;
           alg_green_closest_meanArea(idx) = 0;
       end
       
       % red
       if red_bestClosestBuoyIdx(idx)~=0
           % calculate array of closest areas for best
           best_red_closestArea(idx) = best_red_area(idx,red_bestClosestBuoyIdx(idx));
           
           % calculate array of closest areas for algorithm
           tempidx = red_algClosestBuoyIdx(idx,red_algClosestBuoyIdx(idx,:)~=0);
           temp = alg_red_area(idx,tempidx);
           alg_red_closestArea(idx,1:length(temp)) = temp;
           alg_red_closest_meanArea(idx) = mean(temp);
       else
           best_red_closestArea(idx)=0;
           alg_red_closestArea(idx) = 0;
       end
    end
    
    best_green_closest_meanArea = mean(best_green_closestArea);
    alg_green_closest_meanArea = mean(alg_green_closest_meanArea(~isnan(alg_green_closest_meanArea)));
    best_red_closest_meanArea = mean(best_red_closestArea);
    alg_red_closest_meanArea = mean(alg_red_closest_meanArea(~isnan(alg_red_closest_meanArea)));
    
    metrics.green_nClosestMissing = ns-sum(green_closestBuoyOverlapped);
    metrics.green_nAvgBlobsPerClosest = mean(green_nBlobsPerClosest);
    metrics.green_bestAvgAreaClosest = best_green_closest_meanArea;
    metrics.green_algAvgAreaClosest = alg_green_closest_meanArea;
    
    metrics.red_nClosestMissing = ns-sum(red_closestBuoyOverlapped);
    metrics.red_nAvgBlobsPerClosest = mean(red_nBlobsPerClosest);
    metrics.red_bestAvgAreaClosest = best_red_closest_meanArea;
    metrics.red_algAvgAreaClosest = alg_red_closest_meanArea;

    %% plot metrics from "metrics" cell array
    if displayPlotsFlag==true
        % plot number of red buoys tracked from best algorithm vs. number of best red
        % buoys that have overlapping bounding boxes with the current algorithm
        % - this is not too indicative as algorithms are likely to differ greatly
        %   from each other
        % - also, this does not tell us how well an algorithm performs with respect
        %   to finding the closest buoys
        
        % green plots
        % plot # of algorithm blobs per closest best buoy
        figure
        set(gcf,'Units','Normalized');
        if isequal(res,[640 480])
            set(gcf,'Position',[0.2875    0.5208    0.3490    0.3967]);
        else
            set(gcf,'Position',[0.0057    0.7067    0.2060    0.2060]);
        end
        plot(t,green_nBlobsPerClosest);
        title('# Green Algorithm Blobs per Closest Best Buoy')
        axis([min(t) max(t) 0 5]) 
        
        % plot whether the closest buoy has been tracked
        figure
        set(gcf,'Units','Normalized');
        if isequal(res,[640 480])
            set(gcf,'Position',[0.6469    0.5208    0.3500    0.3967]);
        else
            set(gcf,'Position',[0.4542    0.7067    0.2060    0.2060]);
        end
        plot(t,green_closestBuoyOverlapped);
        titlestr = {'Has the closest green buoy been detected?',['Number of missed buoy samples = ',num2str(metrics.green_nClosestMissing)]};
        title(titlestr)
        axis([min(t) max(t) -0.5 1.5]);
        xlabel('Time in seconds')
        ylabel({'Detection Status','1 = detected, 0 = not detected'})

        % red plots
        % plot # of algorithm blobs per closest best buoy
        figure
        set(gcf,'Units','Normalized');
        if isequal(res,[640 480])
            set(gcf,'Position',[0.2854    0.0500    0.3500    0.3817]);
        else
            set(gcf,'Position',[0.0052    0.4100    0.2060    0.2060]);
        end
        plot(t,red_nBlobsPerClosest); 
        title('# Red Algorithm Blobs per Closest Best Buoy')
        axis([min(t) max(t) 0 5])
        
        % plot whether the closest buoy has been tracked
        figure
        set(gcf,'Units','Normalized');
        if isequal(res,[640 480])
            set(gcf,'Position',[0.6458    0.0483    0.3500    0.3850]);
        else
            set(gcf,'Position',[0.4547    0.4125    0.2060    0.2060]);
        end
        plot(t,red_closestBuoyOverlapped);
        titlestr = {'Has the closest red buoy been detected?',['Number of missed buoy samples = ',num2str(metrics.red_nClosestMissing)]};
        title(titlestr)
        axis([min(t) max(t) -0.5 1.5]);
        xlabel('Time in seconds')
        ylabel({'Detection Status','1 = detected, 0 = not detected'})
        debug = 1;
    end
    
    
    %% display video
    if displayVideoFlag == true;
        % initialize objects
        % initialize video reader and player objects
        filename = '..\media\rawVideo_640x480.avi';
        VideoFileReaderObject = vision.VideoFileReader(filename);
        VideoPlayerObject = vision.VideoPlayer;
        set(VideoPlayerObject,'Position',[31 365 732 537]);

        % initialize shape and line inserter objects
        ShapeInserterObject = vision.ShapeInserter('Fill',true,'FillColorSource','Input port');
        lineShapeInserterObject = vision.ShapeInserter;
        
        % initialize txt inserter objects
        redClosestTxtInserter = vision.TextInserter('Closest Red Buoy','LocationSource','Input port','Color',[1 0 0]);
        greenClosestTxtInserter = vision.TextInserter('Closest Green Buoy','LocationSource','Input port','Color',[0 1 0]);

        if recordVideoFlag==true
            % initialize video writer object
            VideoWriterObj = VideoWriter('boundingBoxVideo.avi');
            VideoWriterObj.FrameRate = 10;
            open(VideoWriterObj);     
        end
        
        % step through video
        for idx = 1:ns
%             display(idx)
            % obtain raw video frame
            frame_original = step(VideoFileReaderObject);
            frame = frame_original;

            % overlay solid rectangles for best buoys
            frame = step(ShapeInserterObject,frame,uint16(best_red_bbox(:,:,idx)),single([255 0 0]));
            frame = step(ShapeInserterObject,frame,uint16(best_green_bbox(:,:,idx)),single([0 255 0]));

            % overlay black line rectangles for algorithm buoys
            frame = step(lineShapeInserterObject,frame,uint16(alg_red_bbox(:,:,idx)));
            frame = step(lineShapeInserterObject,frame,uint16(alg_green_bbox(:,:,idx)));

            % overlay "closest buoy" text over closest buoy
            red_closeIdx = red_bestClosestBuoyIdx(idx);
            green_closeIdx = green_bestClosestBuoyIdx(idx);
            if red_closeIdx~=0
                frame = step(redClosestTxtInserter,frame,[best_red_centroid(red_closeIdx,1,idx)-20 best_red_bbox(red_closeIdx,2,idx)-15]);
            end
            if green_closeIdx~=0
                frame = step(greenClosestTxtInserter,frame,[best_green_centroid(green_closeIdx,1,idx)-20 best_green_bbox(green_closeIdx,2,idx)-15]);
            end

            if recordVideoFlag == true
                wframe = uint8(frame*255);
                writeVideo(VideoWriterObj,wframe);
            end
            
            step(VideoPlayerObject,frame);
            pause(0.1);
           
           current_time = t(idx);
           if green_closestBuoyOverlapped(idx)==0 && debugGreen==true
               debug = 1; % set breakpoint here to stop video when closest green buoy is not being detected
           end
           if red_closestBuoyOverlapped(idx)==0 && debugRed == true
               debug = 1; % set breakpoint here to stop video when closest red buoy is not being detected
           end
            
        end % end of Display Video
        if recordVideoFlag == true
            wframe = uint8(frame*255);
        	writeVideo(VideoWriterObj,wframe);
            close(VideoWriterObj);
        end
        
        
    end % end of if displayVideoFlag
    
end


function out = checkOverlap(buoy_bbox1,buoy_bbox2)
    out = 0;
    buoy_bbox = [buoy_bbox1; buoy_bbox2];
    % check to see if second object region is valid based on its overlap
            ax(1) = buoy_bbox(1,2);             bx(1) = buoy_bbox(2,2);
            ax(2) = buoy_bbox(1,2)+buoy_bbox(1,4); bx(2) = buoy_bbox(2,2)+buoy_bbox(2,4);
            ay(1) = buoy_bbox(1,1);             by(1) = buoy_bbox(2,1);
            ay(2) = buoy_bbox(1,1)+buoy_bbox(1,3); by(2) = buoy_bbox(2,1)+buoy_bbox(2,3);

            A = abs(by(1)+by(2)-ay(1)-ay(2));
            B = abs(bx(1)+bx(2)-ax(1)-ax(2));
            C = ay(2)-ay(1)+by(2)-by(1);  
            D = ax(2)-ax(1)+bx(2)-bx(1);  
            if A*D < B*C
                overlap = B < D;
            else
                overlap = A < C;
            end
            if overlap == 1
                out = 1;
            end
    debug = 1; %#ok<*NASGU>
end

function [bestClosestBuoyIdx,algClosestBuoyIdx,bestClosestBuoyOverlapped,nClosestBuoysOverlapped] = overlapmetrics(best_bbox,bbox,color,badIdx)
    ns = size(bbox,3);
    overlap = zeros(16,5,ns);
    nIsvalidBest = zeros(ns,1);
    nIsvalidAlgorithm = zeros(ns,1);
    nBestOverlapped = zeros(ns,1);
    bestClosestBuoyIdx = zeros(ns,1);
    algClosestBuoyIdx = zeros(ns,4);
    bestClosestBuoyOverlapped = zeros(ns,1);
    nClosestBuoysOverlapped = zeros(ns,1);
    
    for idx = 1:ns;
        % calculate number of buoys that have been detected
        nIsvalidBest(idx) = sum(best_bbox(:,1,idx)~=-1);
        nIsvalidAlgorithm(idx) = sum(bbox(:,1,idx)~=-1);
        % calculate overlap
        for jdx = 1:4 % cycle through 4 best bbox's
            for kdx = 1:4 % cycle through 4 data bbox's
                overlapBoolean = checkOverlap(best_bbox(jdx,:,idx),bbox(kdx,:,idx)); % does the best jdx and algorithm idx bbbox overlap
                isvalidBest = (best_bbox(jdx,1,idx)~=-1); % best buoy detected boolean
                isvalidAlgorithm = (bbox(kdx,1,idx)~=-1); % algorithm buoy detected boolean
                overlap((jdx-1)*4+kdx,:,idx) = [jdx kdx isvalidBest isvalidAlgorithm overlapBoolean]; % debugging matrix used 
            end
        end
        % calculate the number of best algorithm buoys that have overlapping bounding boxes
        % with the current algorithm
%         nBestOverlapped(idx) = any(overlap(1:4,5,idx))+any(overlap(5:8,5,idx))+any(overlap(9:12,5,idx))+any(overlap(13:16,5,idx));
        
        % invalid idx's: categories are;
%         1. idx where red buoys being tracked by best algorithm are from
%         the wrong course or track buoys are not in view
%         2. idx where best red blob is on the edge of the video and is leaving
%         3. idx where best red bob detects buoy that is not closest
        
        if (strcmp(color,'red')||strcmp(color,'green'))&&~isempty(find(badIdx==idx,1)) % when idx is invalid, ignore
            bestClosestBuoyOverlapped(idx) = 1;
            nClosestBuoysOverlapped(idx) = 1;
        elseif nIsvalidBest(idx)~=0
            if strcmp(color,'red') && idx<300 
               % remove buoys corresponding to 2nd track 
               secondTrackIdx = find(best_bbox(:,1,idx)>450);
               best_bbox(secondTrackIdx,:,idx) = -1; %#ok<FNDSB>
            end
            
            % determine which idx corresponds to the closest best buoy
            [~, bestClosestBuoyIdx(idx)] = max(best_bbox(:,2,idx)+best_bbox(:,4,idx));
            
            % Algorithm closest buoy idx is either calculated using max or
            % obtained via the overlap
            
            % Method 1: calculated using max
%             [~, algClosestBuoyIdx(idx)] = max(bbox(:,2,idx)+bbox(:,4,idx));

            % Method 2:         
            % determine whether the best closest buoy is overlapped by an algorithm buoy
            bestClosestBuoyOverlapped(idx) = any(overlap(bestClosestBuoyIdx(idx)*4-3:bestClosestBuoyIdx(idx)*4,5,idx)); 
            
            % determine how many algorithm buoys are overlapping the best closest buoy
            nClosestBuoysOverlapped(idx) =  sum(overlap(bestClosestBuoyIdx(idx)*4-3:bestClosestBuoyIdx(idx)*4,5,idx));
            
            % determine the indices of the closest algorithm buoys
            temp = find(overlap(bestClosestBuoyIdx(idx)*4-3:bestClosestBuoyIdx(idx)*4,5,idx)==1);
            algClosestBuoyIdx(idx,1:length(temp)) = temp;
            
        else % when best algorithm does not find any buoys, ignore results
            bestClosestBuoyOverlapped(idx) = 1;
            nClosestBuoysOverlapped(idx) = 1; 
        end
        
    end
end





