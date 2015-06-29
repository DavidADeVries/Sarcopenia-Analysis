classdef CacheEntry
    %CacheEntry stores the relevant fields from a File to allow an undo
    %command to be performed
    
    properties
        highlightedImage
        roiOn
        highlightingOn
        quickMeasureOn
        
        roiPoints
        quickMeasurePoints
        pixelCounts
    end
    
    methods
        function cacheEntry = CacheEntry(file)
            cacheEntry.highlightedImage = file.highlightedImage;
            cacheEntry.roiOn = file.roiOn;
            cacheEntry.highlightingOn = file.highlightingOn;
            cacheEntry.quickMeasureOn = file.quickMeasureOn;
            cacheEntry.roiPoints = file.roiPoints;
            cacheEntry.quickMeasurePoints = file.quickMeasurePoints;
            cacheEntry.pixelCounts = file.pixelCounts;
        end
        
        function file = restoreToFile(cacheEntry, file)
            file.highlightedImage = cacheEntry.highlightedImage;
            file.roiOn = cacheEntry.roiOn;
            file.highlightingOn = cacheEntry.highlightingOn;
            file.quickMeasureOn = cacheEntry.quickMeasureOn;
            file.roiPoints = cacheEntry.roiPoints;
            file.quickMeasurePoints = cacheEntry.quickMeasurePoints;
            file.pixelCounts = cacheEntry.pixelCounts;
        end
    end
    
end