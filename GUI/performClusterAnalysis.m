function [ sortedClusterIndices ] = performClusterAnalysis( data, numClusters )
% [ sortedClusterIndices ] = performClusterAnalysis( data, numClusters )
% divides the data into numClusters using the k-means algorithm. The
% clusters are returned sorted, from lowest mean intensities to the highest

maxData = max(data);
minData = min(data);

step = (maxData - minData) / (numClusters + 1);

trial1 = [minData + step; minData + 2*step; minData + 3*step];
trial2 = [minData; (maxData + minData)/2; maxData];

start = zeros(3,1,2);

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

