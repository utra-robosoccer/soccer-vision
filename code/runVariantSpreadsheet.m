function runVariantSpreadsheet(varargin)
    % function runVariantSpreadsheet(varargin)
    % This function creates an excel sheet with a compilation of 
    % statistical data over the various variants. The input statarray comes 
    % from the output of runVariantSweep.
    % 
    % To call this function, use the following syntax;
    % runVariantSpreadsheet
    % runVariantSpreadsheet(statarray)
    %
    % runVariantSpreadsheet - runs through "target_transmit" with the
    %   variants specified in the runVariantSweep function and outputs to a
    %   spreadsheet called "variantSweepResults"
    % 
    % runVariantSpreadsheet(statarray) - uses the input statarray to output
    % a spreadsheet called "variantSweepResults"
    % 
    % The input statarray should be a 1x4 cell array if used. This is the output of
    % the runVariantSweep function. See doc for runVariantSweep for more
    % info.
    
    % Copyright 2013, The MathWorks, Inc.
    
    if isempty(varargin)
        statarray = runVariantSweep;
    else
        statarray = varargin{1};
    end
    
    variantNames = statarray{1}; % list of variant names
    nVariants = length(variantNames); % number of variants
    variantTimes = statarray{2}; % list of variant simulation times (time to execute in Simulink on PC)

    nClosestMissed = zeros(8,2); % # of closest buoys missed for each variant for green and red
    avgAlgorithmBlobsPerClosest = zeros(8,2); % average number of alg. blobs that represent the closest buoy in green and red
    avgAreaDiffClosestBlob = zeros(8,2); % difference between average area of best and algorithm closest blobs

    for idx = 1:nVariants
        nClosestMissed(idx,:) = [statarray{4}{idx}.green_nClosestMissing statarray{4}{idx}.red_nClosestMissing];
        avgAlgorithmBlobsPerClosest(idx,:) = [statarray{4}{idx}.green_nAvgBlobsPerClosest statarray{4}{idx}.red_nAvgBlobsPerClosest];

        green_bestAvgAreaClosest = statarray{4}{idx}.green_bestAvgAreaClosest;
        green_algAvgAreaClosest = statarray{4}{idx}.green_algAvgAreaClosest;
        green_avgAreaDiffClosestBlob = green_bestAvgAreaClosest - green_algAvgAreaClosest;

        red_bestAvgAreaClosest = statarray{4}{idx}.red_bestAvgAreaClosest;
        red_algAvgAreaClosest = statarray{4}{idx}.red_algAvgAreaClosest;
        red_avgAreaDiffClosestBlob = red_bestAvgAreaClosest - red_algAvgAreaClosest;

        avgAreaDiffClosestBlob(idx,:) = [green_avgAreaDiffClosestBlob red_avgAreaDiffClosestBlob];
    end 
    variantBlobMetrics = [nClosestMissed avgAlgorithmBlobsPerClosest avgAreaDiffClosestBlob];
    
    headers = {'','','# Closest Buoys Missed','','Average Algorithm Blobs','','Average Area Difference of Closest Blob','';'algorithm','t (sec)','Green','Red','Green','Red','Green Difference','Red Difference'};
    xlswrite('variantSweepResults',headers,'A1:H2') 
    xlswrite('variantSweepResults',variantNames,['A3:A' num2str(nVariants+2)]);
    xlswrite('variantSweepResults',variantTimes,['B3:B' num2str(nVariants+2)]);
    xlswrite('variantSweepResults',variantBlobMetrics,['C3:H' num2str(nVariants+2)]);
    
    % For complete formatting of the spreadsheet, check out the "tips"
    % section of the documentation for xlswrite. You will need to use the activex object
    % instead of xlsread
    
    display('Done!')
