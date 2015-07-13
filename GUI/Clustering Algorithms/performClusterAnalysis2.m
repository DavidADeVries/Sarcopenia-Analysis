function [ sortedClusterIndices ] = performClusterAnalysis2( data )
% [ sortedClusterIndices ] = performClusterAnalysis( data, numClusters )
% divides the data into numClusters using the k-means algorithm. The
% clusters are returned sorted, from lowest mean intensities to the highest

numClusters = 2;

maxData = max(data);
minData = min(data);

step = (maxData - minData) / (numClusters + 1);

trial1 = [minData + step; minData + 2*step];
trial2 = [minData; maxData];

start = zeros(2,1,2);

start(:,:,1) = trial1;
start(:,:,2) = trial2;

[clusterIdX, ~] = kmeans(data, 2, 'Start', start);

clusterIndices = cell(2);
clusterMeanIntensities = zeros(2,1);

for i=1:2
    indices = (clusterIdX == i); 
    meanIntensity = mean(data(indices));
    
    clusterIndices{i} = indices;
    clusterMeanIntensities(i) = meanIntensity;
end

[~, I] = sort(clusterMeanIntensities);

sortedClusterIndices = cell(2);

for i=1:2
    sortedClusterIndices{i} = clusterIndices{I(i)};
end

highIndices = sortedClusterIndices{2}; %we'll leave these alone
tempLowIndices = sortedClusterIndices{1}; %divide these further

lowData = data(tempLowIndices);

maxData = max(lowData);
minData = min(lowData);

step = (maxData - minData) / (numClusters + 1);

trial1 = [minData + step; minData + 2*step];
trial2 = [minData; maxData];
trial3 = [minData + step; maxData];
trial4 = [maxData; maxData - step];

start = zeros(2,1,4);

start(:,:,1) = trial4;
start(:,:,2) = trial2;
start(:,:,3) = trial3;
start(:,:,4) = trial4;

[clusterIdX, ~] = kmeans(lowData, 2, 'Start', start);

clusterIndices = cell(2);
clusterMeanIntensities = zeros(2,1);

for i=1:2
    indices = (clusterIdX == i); 
    meanIntensity = mean(lowData(indices));
    
    clusterIndices{i} = indices;
    clusterMeanIntensities(i) = meanIntensity;
end

[~, I] = sort(clusterMeanIntensities);

sortedClusterIndices = cell(2);

for i=1:2
    sortedClusterIndices{i} = clusterIndices{I(i)};
end

lowIndices = zeros(size(highIndices));
midIndices = zeros(size(highIndices));

j = 1; %lowData index

for i=1:length(tempLowIndices)
    if tempLowIndices(i) %was sent away to be in the low data
        lowIndices(i) = sortedClusterIndices{1}(j);
        midIndices(i) = sortedClusterIndices{2}(j);
        j = j + 1;
    end
end

sortedClusterIndices = {lowIndices, midIndices, highIndices};

end

