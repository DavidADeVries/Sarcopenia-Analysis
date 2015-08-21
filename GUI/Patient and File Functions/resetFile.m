function file = resetFile(file)
% file = resetFile(file)
%   Detailed explanation goes here
%
% ** REQUIRED BY GIANT **
%
% this functions removes any changes done to a file, so that it is as if
% the file was deleted and then added to the patient again

file.clusterMap = []; %same size as image, where each number is a cluster, given by Constants.CLUSTER_MAP_TAGS
        
file.roiOn = false;
file.fatHighlightOn = false;
file.muscleHighlightOn = false;
file.quickMeasureOn = false;
        
%file.imageDims = []; %don't touch this!
        
file.thresholds = []; 

file.displayUnits = '';
        
file.roiPoints = cell(0);        
file.quickMeasurePoints = [];

end

