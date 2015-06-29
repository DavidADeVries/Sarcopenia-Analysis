classdef File
    %file represents an open DICOM file
    
    properties
        dicomInfo
        date % I know dicomInfo would hold this, but to have it in an easily compared form is nice
        
        image
        highlightedImage = [];
        
        roiOn = false;
        highlightingOn = false;
        quickMeasureOn = false;
        displayUnits = ''; %can be: none, absolute, relative, pixel
        
        roiPoints = cell(0);        
        quickMeasurePoints = [];
        pixelCounts = PixelCounts.empty; %stores the number of pixel of each intensity for each ROI
                
        undoCache = UndoCache.empty;
    end
    
    methods
        %% Constructor %%
        function file = File(dicomInfo, dicomImage)
            file.dicomInfo = dicomInfo;
            file.image = double(dicomImage);
            file.date = Date(dicomInfo.AcquisitionDate);
            
            file.undoCache = UndoCache(file);
        end
        
        %% getCurrentImage %%
        function image = getCurrentImage(file)
            if file.highlightingOn
                image = file.highlightedImage;
            else
                image = file.image;
            end
        end
        
        %% getPixelArea %%
        function pixelArea = getPixelArea(file)
            pixelSpacing = file.dicomInfo.PixelSpacing;
            pixelArea = pixelSpacing(1)*pixelSpacing(2); %in mm^2
        end        
        
        %% addRoi %%
        function file = addRoi(file, points)
            file.roiPoints{file.numRoi()+1} = points;
        end
        
        %% numRoi %%
        function num = numRoi(file)
            num = length(file.roiPoints);
        end
        
        %% deleteRoi %%
        function file = deleteRoi(file, roiIndex)
            file.roiPoints(roiIndex) = [];
        end
          
        
        %% chooseDisplayUnits %%
        % sets the file's displayUnits field if not yet set
        function file = chooseDisplayUnits(file)
            if isempty(file.displayUnits) %only change if not yet defined
                % putting it in the reference units is preferred, but if not, pixels it is, boys, pixels it is
               
                    file.displayUnits = 'pixel';
                
            end
        end
        
        %% getUnitConversion %%
        %returns the unitString (px, mm, etc.) and the unitConversion
        %factor, in the form [xScalingFactor, yScalingFactor]
        %to convert take value in px and multiply by scaling factor
        function [ unitString, unitConversion ] = getUnitConversion(file)
            %getUnitConversions gives back a string for display purposes, as well as a
            %coefficient such that pixelMeaurement*coeff = measurementInUnits
            
            switch file.displayUnits
                case 'none'
                    unitString = '';
                    unitConversion = [];
                case 'absolute'
                    unitString = 'mm';
                    
                    pixelSpacing = file.dicomInfo.PixelSpacing;
                    
                    unitConversion = pixelSpacing;
                case 'pixel'
                    unitString = 'px';
                    unitConversion = [1,1]; %everything is stored in px measurements,so no conversion neeeded.
            end
        end
        
        %% updateUndoCache %%
        % saves the file at current into its own undo cache
        function [ file ] = updateUndoCache( file )
            %updateUndoCache takes whatever is in the currentFile that could be changed
            %and caches it
            
            cache = file.undoCache;
            
            oldCacheEntries = cache.cacheEntries;
            
            newCacheSize = cache.numCacheEntries()  - cache.cacheLocation + 2;
            
            maxCacheSize = cache.cacheSize;
            
            if newCacheSize > maxCacheSize
                newCacheSize = maxCacheSize;
            end
            
            newCacheEntries = CacheEntry.empty(newCacheSize,0);
            
            newCacheEntries(1) = CacheEntry(file); %most recent is now the current state (all previous redo options eliminated)
            
            %bring in all entries that are still in the "past". Any before
            %cacheLocation are technically in a "future" that since a change has been
            %made, it would be inconsistent for this "future" to be reachable, and so
            %the entries are removed.
            
            for i=2:newCacheSize
                newCacheEntries(i) = oldCacheEntries(cache.cacheLocation + i - 2);
            end
            
            cache.cacheEntries = newCacheEntries;
            cache.cacheLocation = 1;
            
            file.undoCache = cache;            
        end
        
        
        %% performUndo %%
        function [ file ] = performUndo( file )
            %performUndo actually what it says on the tin
            
            cacheLocation = file.undoCache.cacheLocation;
            
            numCacheEntries = length(file.undoCache.cacheEntries);
            
            cacheLocation = cacheLocation + 1; %go back in time
            
            if cacheLocation > numCacheEntries
                cacheLocation = numCacheEntries;
            end
            
            if cacheLocation > file.undoCache.cacheSize
                cacheLocation = file.undoCache.cacheSize;
            end
            
            file.undoCache.cacheLocation = cacheLocation;
            
            cacheEntry = file.undoCache.cacheEntries(cacheLocation);
            
            file = cacheEntry.restoreToFile(file);           
        end
        
        %% performRedo %%
        function [ file ] = performRedo( file )
            %performUndo actually what it says on the tin
                        
            cacheLocation = file.undoCache.cacheLocation;
            
            cacheLocation = cacheLocation - 1; %go forward in time
            
            if  cacheLocation == 0
                cacheLocation = 1;
            end
            
            file.undoCache.cacheLocation = cacheLocation;
            
            cacheEntry = file.undoCache.cacheEntries(cacheLocation);
            
            file = cacheEntry.restoreToFile(file); 
        end
        
    end
    
end

