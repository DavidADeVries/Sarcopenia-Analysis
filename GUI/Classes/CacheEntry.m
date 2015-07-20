classdef CacheEntry
    %CacheEntry stores the relevant fields from a File to allow an undo
    %command to be performed
    
    properties
        clusterMap
        roiOn
        fatHighlightOn
        muscleHighlightOn
        quickMeasureOn
        
        muscleLowerThreshold
        
        roiPoints
        quickMeasurePoints
    end
    
    methods
        function cacheEntry = CacheEntry(file)
            cacheEntry.clusterMap = file.clusterMap;
            cacheEntry.roiOn = file.roiOn;
            cacheEntry.fatHighlightOn = file.fatHighlightOn;
            cacheEntry.muscleHighlightOn = file.muscleHighlightOn;
            cacheEntry.quickMeasureOn = file.quickMeasureOn;
            cacheEntry.muscleLowerThreshold = file.muscleLowerThreshold;
            cacheEntry.roiPoints = file.roiPoints;
            cacheEntry.quickMeasurePoints = file.quickMeasurePoints;
        end
        
        function file = restoreToFile(cacheEntry, file)
            file.clusterMap = cacheEntry.clusterMap;
            file.roiOn = cacheEntry.roiOn;
            file.fatHighlightOn = cacheEntry.fatHighlightOn;
            file.muscleHighlightOn = cacheEntry.muscleHighlightOn;
            file.quickMeasureOn = cacheEntry.quickMeasureOn;
            file.muscleLowerThreshold = cacheEntry.muscleLowerThreshold;
            file.roiPoints = cacheEntry.roiPoints;
            file.quickMeasurePoints = cacheEntry.quickMeasurePoints;
        end
    end
    
end