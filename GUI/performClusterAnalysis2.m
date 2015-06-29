function [ sortedClusterIndices ] = performClusterAnalysis2( data )
% [ sortedClusterIndices ] = performClusterAnalysis( data, numClusters )
% divides the data into numClusters using the k-means algorithm. The
% clusters are returned sorted, from lowest mean intensities to the highest

[clusterIdX, ~] = kmeans(data, 2, 'Replicates',3);

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

[clusterIdX, ~] = kmeans(lowData, 2, 'Replicates',3);

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

