function [ sortedClusterIndices ] = performClusterAnalysis( data, numClusters )
% [ sortedClusterIndices ] = performClusterAnalysis( data, numClusters )
% divides the data into numClusters using the k-means algorithm. The
% clusters are returned sorted, from lowest mean intensities to the highest

[clusterIdX, ~] = kmeans(data, numClusters, 'Replicates',3);

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

