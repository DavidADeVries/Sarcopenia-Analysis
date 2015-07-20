classdef FamSamFile < File
    %file represents an open DICOM file
    
    properties
        clusterMap = []; %same size as image, where each number is a cluster, given by Constants.CLUSTER_MAP_TAGS
        
        roiOn = false;
        fatHighlightOn = false;
        muscleHighlightOn = false;
        quickMeasureOn = false;
        muscleLowerThreshold = []; % used to reject tissue that was segmented as muscle, but is too dark.
        displayUnits = ''; %can be: none, relative, pixel
        
        roiPoints = cell(0);        
        quickMeasurePoints = [];
    end
    
    methods
        %% Constructor %%
        function file = FamSamFile(name, dicomInfo, imagePath)
            file@File(name, dicomInfo, imagePath);
        end
        
        %% getCurrentImage %%
        function image = getCurrentImage(file, image)
            if file.fatHighlightOn || file.muscleHighlightOn
                image = file.getHighlightedImage(image);
            end
        end
        
        %% getHighlightedImage %%
        function highlightedImage = getHighlightedImage(file, image)
            localClusterMap = file.clusterMap;
            
            clusterTags = Constants.CLUSTER_MAP_TAGS;
            
            normedImage = image/max(max(image));
            
            dims = size(image);
            
            highlightRedChan = zeros(dims);
            highlightGreenChan = zeros(dims);
            highlightBlueChan = zeros(dims);
            
            transparency = 0.9; % 0 - 1
            
            for i=1:dims(1)
                for j=1:dims(2)      
                    if localClusterMap(i,j) == clusterTags.fat && file.fatHighlightOn %fat green
                        highlightGreenChan(i,j) = transparency;
                    else
                        highlightGreenChan(i,j) = normedImage(i,j);
                    end
                    
                    if localClusterMap(i,j) == clusterTags.muscle && file.muscleHighlightOn %muscle red
                        highlightRedChan(i,j) = transparency;
                    else
                        highlightRedChan(i,j) = normedImage(i,j);
                    end
                    
                    highlightBlueChan(i,j) = normedImage(i,j);
                end
            end
            
            highlightedImage = zeros(dims(1), dims(2), 3);
            
            highlightedImage(:,:,1) = highlightRedChan;
            highlightedImage(:,:,2) = highlightGreenChan;
            highlightedImage(:,:,3) = highlightBlueChan;
        end
        
        %% isValidForExport %%
        % ** required by GIANT **
        function isValid = isValidForExport(file)
            isValid = ~isempty(file.pixelCounts);
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
        
        %% setQuickMeasurePoints %%
        function file = setQuickMeasurePoints(file, points)
            file.quickMeasurePoints = points;
        end
        
        %% getQuickMeasurePoints %%
        function points = getQuickMeasurePoints(file)
            points = file.quickMeasurePoints;
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
        
         %% getStats %%
        function [csas, percentages] = getStats(file, image)
            pixelArea = file.getPixelArea();
            clusterTags = Constants.CLUSTER_MAP_TAGS;
            
            % count up number of pixels for ROIs
            
            roiMasks = file.getRoiMasks(image);
            
            leftRoiMask = roiMasks{1};
            
            if file.numRoi == 1
                rightRoiMask = []; % kept empty, or else left and right ROI will be the same
            else
                rightRoiMask = roiMasks{file.numRoi};
            end
            
            localClusterMap = file.clusterMap;
            
            leftClusterMap = localClusterMap(leftRoiMask==1);
            rightClusterMap = localClusterMap(rightRoiMask==1);
            
            leftFatCount = sum(leftClusterMap == clusterTags.fat);
            leftMuscleCount = sum(leftClusterMap == clusterTags.muscle);
            leftOtherCount = sum(leftClusterMap == clusterTags.other);
            
            rightFatCount = sum(rightClusterMap == clusterTags.fat);
            rightMuscleCount = sum(rightClusterMap == clusterTags.muscle);
            rightOtherCount = sum(rightClusterMap == clusterTags.other);
                        
            totalLeft = sum([leftFatCount, leftMuscleCount, leftOtherCount]);
            totalRight = sum([rightFatCount, rightMuscleCount, rightOtherCount]);
            totalBoth = totalLeft + totalRight;
            
            % figure out CSAs and percentages
            % cross sectional areas (CSA)
            leftFatCsa = leftFatCount * pixelArea;
            leftMuscleCsa = leftMuscleCount * pixelArea;
            leftOtherCsa = leftOtherCount * pixelArea;
            
            rightFatCsa = rightFatCount * pixelArea;
            rightMuscleCsa = rightMuscleCount * pixelArea;
            rightOtherCsa = rightOtherCount * pixelArea;
            
            totalFatCsa = (leftFatCount + rightFatCount) * pixelArea;
            totalMuscleCsa = (leftMuscleCount + rightMuscleCount) * pixelArea;
            totalOtherCsa = (leftOtherCount + rightOtherCount) * pixelArea;
            
            % percentages
            localLeftFatPercent = 100 * (leftFatCount / totalLeft);
            localLeftMusclePercent = 100 * (leftMuscleCount / totalLeft);
            localLeftOtherPercent = 100 * (leftOtherCount / totalLeft);
            
            localRightFatPercent = 100 * (rightFatCount / totalRight);
            localRightMusclePercent = 100 * (rightMuscleCount / totalRight);
            localRightOtherPercent = 100 * (rightOtherCount / totalRight);
            
            totalFatPercent = 100 * ((leftFatCount + rightFatCount) / totalBoth);
            totalMusclePercent = 100 * ((leftMuscleCount + rightMuscleCount) / totalBoth);
            totalOtherPercent = 100 * ((leftOtherCount + rightOtherCount) / totalBoth);
            
            % put it all in structs
            leftCsa = struct('fat',leftFatCsa,'muscle',leftMuscleCsa,'other',leftOtherCsa);
            rightCsa = struct('fat',rightFatCsa,'muscle',rightMuscleCsa,'other',rightOtherCsa);
            totalCsa = struct('fat',totalFatCsa,'muscle',totalMuscleCsa,'other',totalOtherCsa);
            
            csas = struct('left',leftCsa,'right',rightCsa','total',totalCsa);
            
            leftPercent = struct('fat',localLeftFatPercent,'muscle',localLeftMusclePercent,'other',localLeftOtherPercent);
            rightPercent = struct('fat',localRightFatPercent,'muscle',localRightMusclePercent,'other',localRightOtherPercent);
            totalPercent = struct('fat',totalFatPercent,'muscle',totalMusclePercent,'other',totalOtherPercent);
            
            percentages = struct('left',leftPercent,'right',rightPercent','total',totalPercent);
        end
        
        %% getRoiMasks %%
        % in order from left to right
        function [roiMasks] = getRoiMasks(file, image)
            dims = size(image);
            
            numRoi = file.numRoi;           
            
            meanRoiX = zeros(numRoi, 1);
            roiMasks = cell(numRoi,1);                       
            
            for i=1:numRoi
                %calculate spline
                
                localRoiPoints = [file.roiPoints{i}; file.roiPoints{i}(1,:)]; %duplicate last point
                
                meanRoiX(i) = mean(localRoiPoints(:,1));
                                
                x = localRoiPoints(:,1)';
                y = localRoiPoints(:,2)';
                
                spline = cscvn([x;y]); %spline store as a function
                
                %plot spline
                splinePoints = fnplt(spline)';
                
                roiMask = fastMask(splinePoints, dims);
                
                roiMasks{i} = roiMask;                
            end
            
            [~,I] = sort(meanRoiX);
                    
            roiMasks = roiMasks(I); %sort them from left to right
        end
        
        %% setLowerMuscleThreshold %%
        function file = setMuscleLowerThreshold(file, image, lowerThreshold)
            % set all pixels tagged as muscle that are below the threshold
            % to be 'other'
                       
            clusterTags = Constants.CLUSTER_MAP_TAGS;
            localClusterMap = file.clusterMap;
            
            lowIntMuscleMask = (localClusterMap == clusterTags.lowIntMuscle);
            allMuscleMask = (localClusterMap == clusterTags.muscle) | lowIntMuscleMask;
                        
            newLowIntMuscleMask = allMuscleMask & (image < lowerThreshold);
            
            clusterMapWithoutLowIntMuscle = localClusterMap + lowIntMuscleMask*(clusterTags.muscle - clusterTags.lowIntMuscle);
            
            newClusterMap = clusterMapWithoutLowIntMuscle + newLowIntMuscleMask*(clusterTags.lowIntMuscle - clusterTags.muscle);
            
            file.clusterMap = newClusterMap;   
            file.muscleLowerThreshold = lowerThreshold;
        end
    end
    
end

