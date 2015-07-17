classdef CacheEntry
    %CacheEntry stores the relevant fields from a File to allow an undo
    %command to be performed
    
    properties
        clusterMap
        roiOn
        highlightingOn
        quickMeasureOn
        
        roiPoints
        quickMeasurePoints
    end
    
    methods
        function cacheEntry = CacheEntry(file)
            cacheEntry.clusterMap = file.clusterMap;
            cacheEntry.roiOn = file.roiOn;
            cacheEntry.highlightingOn = file.highlightingOn;
            cacheEntry.quickMeasureOn = file.quickMeasureOn;
            cacheEntry.roiPoints = file.roiPoints;
            cacheEntry.quickMeasurePoints = file.quickMeasurePoints;
        end
        
        function file = restoreToFile(cacheEntry, file)
            file.clusterMap = cacheEntry.clusterMap;
            file.roiOn = cacheEntry.roiOn;
            file.highlightingOn = cacheEntry.highlightingOn;
            file.quickMeasureOn = cacheEntry.quickMeasureOn;
            file.roiPoints = cacheEntry.roiPoints;
            file.quickMeasurePoints = cacheEntry.quickMeasurePoints;
        end
    end
    
end