classdef SarcoFile < File
    %file represents an open DICOM file
    
    properties
        highlightedImage = [];
        
        roiOn = false;
        highlightingOn = false;
        quickMeasureOn = false;
        displayUnits = ''; %can be: none, absolute, relative, pixel
        
        roiPoints = cell(0);        
        quickMeasurePoints = [];
        pixelCounts = PixelCounts.empty; %stores the number of pixel of each intensity for each ROI
    end
    
    methods
        %% Constructor %%
        function file = SarcoFile(name, dicomInfo, dicomImage)
            file@File(name, dicomInfo, dicomImage);
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
        
        
        
    end
    
end

