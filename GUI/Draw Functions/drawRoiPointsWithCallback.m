function [ handles ] = drawRoiPointsWithCallback(currentFile, handles, hObject, toggled, roiIndex)
% [ handles ] = drawRoiWithCallback(currentFile, handles, hObject)
% takes the ROI points from the current file and interpolates them with a
% natural spline. The points are plotted as draggable impoints. The
% impoints are connected to callback such that when they are moved, the
% splines are redrawn

allRoiPointHandles = handles.roiPointHandles;

if roiIndex > length(allRoiPointHandles)
    oneRoiPointHandles = impoint.empty;
else
    oneRoiPointHandles = allRoiPointHandles{roiIndex};
end

roiPoints = [];

if ~isempty(currentFile)
    roiPoints = currentFile.roiPoints{roiIndex};
end

if ~toggled
    if isempty(oneRoiPointHandles) %create new
        if ~isempty(roiPoints)
            %constants
            pointColour = Constants.ROI_POINT_COLOUR;
            
            %plot impoints/create callbacks
            
            draggable = true;
            
            numRoiPoints = height(roiPoints);
            
            pointHandles = impoint.empty(numRoiPoints, 0);
            
            for i=1:height(roiPoints)
                impointHandle = plotImpoint(roiPoints(i,:), pointColour, draggable, handles.imageAxes);
                
                func = @(pos) roiPointCallback(hObject, roiIndex);
                addNewPositionCallback(impointHandle, func);
                
                pointHandles(i) = impointHandle;
            end
            
            oneRoiPointHandles = pointHandles;
        end
    end
end

if ~isempty(oneRoiPointHandles)
    if currentFile.roiOn
        for i=1:length(oneRoiPointHandles)
            set(oneRoiPointHandles(i),'Visible','on');
        end
    else
        for i=1:length(oneRoiPointHandles)
            set(oneRoiPointHandles(i),'Visible','off');
        end
    end
    
    allRoiPointHandles{roiIndex} = oneRoiPointHandles;
    handles.roiPointHandles = allRoiPointHandles;
end

end

