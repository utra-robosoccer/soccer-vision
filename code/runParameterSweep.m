function output = runParameterSweep
% function output = runParameterSweep
% This function sweeps through the model "target_transmit_subtraction" model by 
% varying the green and red thresholds for the subtraction algorithm. The 
% results are plotted and made an output of this function. 
% 
% To call this function, use the following syntax;
% output = runParameterSweep
%
% "output" is a structure containing the data and metrics at every time step.
% output.data and output.metrics are nx1 vectors where n are the of thresholds 
% being swept through. The output also contains a table of data called 
% "nclosestmissing_table" which can used to plot the "Thresholds vs. Number 
% of Missing Closest Best Buoys"

% Copyright 2013, The MathWorks, Inc.

%% Modify Parameters in this Section
% open the "target_transmit" model 
% User should modify the model name if using a different model
modelname = 'target_transmit';
open(modelname)

% set active variant to variant2: Subtraction Based Thresholding 50 Blobs
bdah = get_param('target_transmit/Buoy Detection Algorithm','Handle');
set(bdah,'OverrideUsingVariant','subtraction50BlobsVariant')

% obtain green and red threshold handles for threshold updating
% User should modify the path to the thresholds if using a different model
gth = get_param('target_transmit/Buoy Detection Algorithm/variant2: Subtraction Based Thresholding 50 Blobs/Compare To Constant Green Competition Video','Handle');
rth = get_param('target_transmit/Buoy Detection Algorithm/variant2: Subtraction Based Thresholding 50 Blobs/Compare To Constant Red Competition Video','Handle');

% define threshold update range
% User should modify gthresholds and rthresholds to the desired ranges
gthresholds = 60+(-20:20);
rthresholds = 90+(-20:20);
nidx = length(gthresholds);

% load best data for call to postSimulationAnalysis
% User should modify if another best data set is desired
load data/bestsimulink_data

%% 
% initialize save variables
data_save = cell(nidx,1);
metrics_save = cell(nidx,1);
nclosestmissing_table = zeros(nidx,4);

for idx = 1:nidx;
    % update threshold parameters
    gthreshold = gthresholds(idx);
    rthreshold = rthresholds(idx);
    set_param(gth,'const',num2str(gthreshold));
    set_param(rth,'const',num2str(rthreshold));
    % run simulation to obtain data
    sim(modelname)
    % run postSimulationAnalysis to obtain statistics, including the
    % number of times that the closest buoy has been found "closestBuoyOverlapSum"
    metrics = postSimulationAnalysis(bestsimulink_data,data); 
    
    % save data
    data_save{idx} = data;
    metrics_save{idx} = metrics;
    nclosestmissing_table(idx,1) = gthreshold;
    nclosestmissing_table(idx,2) = metrics.green_nClosestMissing;
    nclosestmissing_table(idx,3) = rthreshold;
    nclosestmissing_table(idx,4) = metrics.red_nClosestMissing;
%     debug = 1;
end

% close the model
bdclose(modelname)

%% plot results
figure;
set(gcf,'Units','Normalized')
set(gcf,'Position',[0.3245    0.4400    0.3839    0.4742])

subplot(2,1,1);
hold on;
plot(nclosestmissing_table(:,1),nclosestmissing_table(:,2),'g')
plot([60 60],[0 max(nclosestmissing_table(:,2))+50],'k');
axis([min(nclosestmissing_table(:,1)) max(nclosestmissing_table(:,1)) min(nclosestmissing_table(:,2))-50 max(nclosestmissing_table(:,2))+50])
title('Closest Buoy Samples Missed vs. Threshold Values')
ylabel('Number of Missed Samples')
xlabel('Green Threshold Values')
legend('Green Threshold Results','Original Value')

subplot(2,1,2);
hold on;
plot(nclosestmissing_table(:,3),nclosestmissing_table(:,4),'r')
axis([min(nclosestmissing_table(:,3)) max(nclosestmissing_table(:,3)) min(nclosestmissing_table(:,4))-50 max(nclosestmissing_table(:,4))+50])
plot([90 90],[0 max(nclosestmissing_table(:,4))+50],'k');
ylabel('Number of Missed Samples')
xlabel('Red Threshold Values')
legend('Red Threshold Results','Original Value')

%% output data
output.data_save = data_save;
output.metrics_save = metrics_save;
output.nclosestmissing_table = nclosestmissing_table;

end

