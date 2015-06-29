classdef PixelCounts
    %PixelCounts
    % holds the pixel counts for the various intensities in the left and
    % right ROI
    
    properties
        leftHighInt = 0; %fat
        leftMidInt = 0; %muscle
        leftLowInt = 0; %ignore
        
        rightHighInt = 0; %fat
        rightMidInt = 0; %muscle
        rightLowInt = 0; %ignore
    end
    
    methods
        %% Constructor %%
        function pixelCounts = PixelCounts(leftLow, leftMid, leftHigh, rightLow, rightMid, rightHigh)
            pixelCounts.leftHighInt = leftHigh;
            pixelCounts.leftMidInt = leftMid;
            pixelCounts.leftLowInt = leftLow;
            
            pixelCounts.rightHighInt = rightHigh;
            pixelCounts.rightMidInt = rightMid;
            pixelCounts.rightLowInt = rightLow;
        end
        
        %% getStats %%
        function [csas, percentages] = getStats(pixelCounts, pixelArea)
            leftH = pixelCounts.leftHighInt;
            leftM = pixelCounts.leftMidInt;
            leftL = pixelCounts.leftLowInt;
            
            rightH = pixelCounts.rightHighInt;
            rightM = pixelCounts.rightMidInt;
            rightL = pixelCounts.rightLowInt;
            
            totalLeft = sum([leftH, leftM, leftL]);
            totalRight = sum([rightH, rightM, rightL]);
            totalBoth = totalLeft + totalRight;
            
            % cross sectional areas (CSA)
            leftHCsa = leftH * pixelArea;
            leftMCsa = leftM * pixelArea;
            leftLCsa = leftL * pixelArea;
            
            rightHCsa = rightH * pixelArea;
            rightMCsa = rightM * pixelArea;
            rightLCsa = rightL * pixelArea;
            
            totalHCsa = (leftH + rightH) * pixelArea;
            totalMCsa = (leftM + rightM) * pixelArea;
            totalLCsa = (leftL + rightL) * pixelArea;
            
            % percentages
            leftHPercent = 100 * (leftH / totalLeft);
            leftMPercent = 100 * (leftM / totalLeft);
            leftLPercent = 100 * (leftL / totalLeft);
            
            rightHPercent = 100 * (rightH / totalRight);
            rightMPercent = 100 * (rightM / totalRight);
            rightLPercent = 100 * (rightL / totalRight);
            
            totalHPercent = 100 * ((leftH + rightH) / totalBoth);
            totalMPercent = 100 * ((leftM + rightM) / totalBoth);
            totalLPercent = 100 * ((leftL + rightL) / totalBoth);
            
            % put it all in structs
            leftCsa = struct('high',leftHCsa,'mid',leftMCsa,'low',leftLCsa);
            rightCsa = struct('high',rightHCsa,'mid',rightMCsa,'low',rightLCsa);
            totalCsa = struct('high',totalHCsa,'mid',totalMCsa,'low',totalLCsa);
            
            csas = struct('left',leftCsa,'right',rightCsa','total',totalCsa);
            
            leftPercent = struct('high',leftHPercent,'mid',leftMPercent,'low',leftLPercent);
            rightPercent = struct('high',rightHPercent,'mid',rightMPercent,'low',rightLPercent);
            totalPercent = struct('high',totalHPercent,'mid',totalMPercent,'low',totalLPercent);
            
            percentages = struct('left',leftPercent,'right',rightPercent','total',totalPercent);
        end
        
    end
    
end

