function [ sortedClusterIndices ] = performClusterAnalysis5(data)
% [ sortedClusterIndices ] = performClusterAnalysis5(data)
% divides the data into 2 using the k-means algorithm. The
% clusters are returned sorted, from lowest mean intensities to the highest

numClusters = 2;
numTrials = 2;

maxData = max(data);
minData = min(data);

step = (maxData - minData) / (numClusters + 1);

trial1 = [minData + step; minData + 2*step];
trial2 = [minData; maxData];

start = zeros(numClusters,1,numTrials);

start(:,:,1) = trial1;
start(:,:,2) = trial2;

[clusterIdX, ~] = kmeans(data, numClusters, 'Start', start);

clusterIndices = cell(numClusters);
clusterMeanIntensities = zeros(numClusters,1);

for i=1:numClusters
    indices = (clusterIdX == i); 
    meanIntensity = mean(data(indices));
    
    clusterIndices{i} = indices;
    clusterMeanIntensities(i) = meanIntensity;
end

[~, I] = sort(clusterMeanIntensities);

sortedClusterIndices = cell(numClusters);

for i=1:numClusters
    sortedClusterIndices{i} = clusterIndices{I(i)};
end


end

