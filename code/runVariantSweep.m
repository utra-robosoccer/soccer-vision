function statarray = runVariantSweep(varargin)
% function statarray = runVariantSweep(variantList)
% This function runs through the model target_transmit with  each of the
% variants from the variantList input to create an array of statistics. 
% 
% To call the funtion, the syntax is;
% statarray = runVariantSweep;
% statarray = runVariantSweep(variantList)
% 
% statarray = runVariantSweep - Outputs the array of statistics based on
% the default variant list specified in  this function
%
% statarray = runVariantSweep(variantList) - Outputs the array of statistics 
% based on variant list provided as an input to the function.
% The variantList must be a nx1 cell array of variant control names;
% variantList = {'variant1'; 'variant2'};
%
% The output statarray is a 1x4 cell array;
% - First cell is the nx1 cell array variant list
% - Second cell is nx1 vector containing the time taken to execute each variant
% - Third cell is a nx1 cell array containing the variant's data; area,
% centroid, bbox at each time step
% - Fourth cell is a nx1 cell array containing the variant's statistics as
% determined by the postSimulationAnalysis function

% Copyright 2013, The MathWorks, Inc.

if isempty(varargin)
    variantList = {'subtraction4BlobsVariant';...
                'subtraction50BlobsVariant';...
                'singleBoundedSetSimulinkVariant';...
                'multipleBoundedSetsSimulinkVariant';...
                'bestSimulinkVariant';...
                'hsvVariant'};
else
    variantList = varargin{1};
end

nidx = length(variantList);

% initialize save variables
time_save = zeros(nidx,1);
data_save = cell(nidx,1);
metrics_save = cell(nidx,1);

load data/bestsimulink_data;
open('target_transmit')
varb = 'target_transmit/Buoy Detection Algorithm'; % variant block name
for idx = 1:nidx
    % display variant being executed 
    display(variantList{idx})
    
    % set the variant
    set_param(varb, 'OverrideUsingVariant',variantList{idx})    
    
    % run simulation to obtain data
    tic
    sim('target_transmit')
    time_save(idx,1) = toc;
    
    % run postSimulationAnalysis to obtain statistics, including the
    % number of times that the closest buoy has been found "closestBuoyOverlapSum"
    metrics = postSimulationAnalysis(bestsimulink_data,data); 
    
    % save data
    data_save{idx} = data;
    metrics_save{idx} = metrics;

end
bdclose('target_transmit');
statarray = {variantList, time_save, data_save, metrics_save};
