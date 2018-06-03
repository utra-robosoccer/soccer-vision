function [blob_area, blob_centroid, blob_bbox] = target_transmit_singleThreshold_matlab(video,thresholds) %#ok<INUSD>
% This code performs rgb color segmentation and blob detection for green buoys

% Copyright 2013 The MathWorks, Inc.

clc
close all

% import video
videoFileReaderObject = vision.VideoFileReader('..\..\media\rawVideo_640x480.avi');
set(videoFileReaderObject,'VideoOutputDataType','uint8')

% initialize Video Player
videoPlayerObject = vision.VideoPlayer();
set(videoPlayerObject,'Position',[9 594 657 510]);

% create ShapeInserter,and BlobAnalysis objects
blobAnalysisObject = vision.BlobAnalysis('AreaOutputPort',true,'BoundingBoxOutputPort',true,'MinimumBlobArea',40,'MaximumCount',4);
shapeInserterObject = vision.ShapeInserter('BorderColor','Custom','CustomBorderColor',[0 255 0]);

% initialize thresholds
thresholds = [0 57; 100 242; 35 219];

i = 0;
while ~isDone(videoFileReaderObject)
    % increment frame counter i
    i = i + 1;
    
    % obtain the next frame in the video
    frame = step(videoFileReaderObject);

    %% algorithm
    % segment the RGB frame to obtain the segmented black and white image
    bw = thresholdImage(frame,thresholds);

    % perform blob detection
    [blob_area,blob_centroid,blob_bbox] = step(blobAnalysisObject,bw);

    %% visualize results
    % update the frame to be displayed and step the video player
    frame = step(shapeInserterObject,frame,blob_bbox);
    step(videoPlayerObject,frame);
    
    % show color image overlaid onto segmented black and white image
    % can be used to clean up noise easily
    % comment out if unnecessary
    frameseg = repmat(uint8(bw),[1,1,3]).*frame;
    imshow(frameseg);
end

release(videoPlayerObject);
release(videoFileReaderObject);

end

function bw = thresholdImage(img,thresholds)
    bw = false(480,640);
    nt = size(thresholds,1)/3; % bad for mfb
%     nt = 1; % good for mfbe
    for i = 1:nt
    bw = bw | logical(... % red threshold
            img(:,:,1)>=thresholds(3*i-2,1) & ...
            img(:,:,1)<=thresholds(3*i-2,2)  & ...
            ... % green threshold
            img(:,:,2)>=thresholds(3*i-1,1) & ...           
            img(:,:,2)<=thresholds(3*i-1,2)  & ...  
            ... % blue threshold
            img(:,:,3)>=thresholds(3*i,1) & ... 
            img(:,:,3)<=thresholds(3*i,2));
    end
    
end

