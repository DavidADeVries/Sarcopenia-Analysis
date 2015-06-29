function [ handles ] = drawRoiLine(currentFile, handles, toggled, roiIndex)
% [ handles ] = drawRoiWithCallback(currentFile, handles, hObject)
% takes the ROI points from the current file and interpolates them with a
% natural spline. The points are plotted as draggable impoints. The
% impoints are connected to callback such that when they are moved, the
% splines are redrawn

splineHandles = handles.roiSplineHandles;

if roiIndex > length(splineHandles)
    splineHandle = gobjects(0);
else
    splineHandle = splineHandles{roiIndex};
end

roiPoints = [];

if ~isempty(currentFile)
    roiPoints = currentFile.roiPoints{roiIndex};
end

if ~toggled
    if isempty(splineHandle) %create new
        if ~isempty(roiPoints)
            %constants
            
            %find spline
            roiPoints = [roiPoints; roiPoints(1,:)]; %duplicate last point
            
            x = roiPoints(:,1)';
            y = roiPoints(:,2)';
            
            spline = cscvn([x;y]); %spline store as a function
            
            %plot spline
            hold on;
            points = fnplt(spline);
            splineHandle = plot(points(1,:),points(2,:));
%             roiSplineHandle = impoly(handles.imageAxes, points');
%             setVerticesDraggable(roiSplineHandle, false);
            hold off;
        end
    else % update
        if ~isempty(roiPoints)
            %constants
            
            %find spline
            roiPoints = [roiPoints; roiPoints(1,:)]; %duplicate last point
            
            x = roiPoints(:,1)';
            y = roiPoints(:,2)';
            
            spline = cscvn([x;y]); %spline store as a function
            
            %plot spline
            points = fnplt(spline);
            set(splineHandle, 'XData', points(1,:), 'YData', points(2,:));
%             setPosition(roiSplineHandle, points');
            
        end
    end
end

if ~isempty(splineHandle)
    if currentFile.roiOn
        set(splineHandle, 'Visible', 'on');
    else
        set(splineHandle, 'Visible', 'off');
    end
                
    splineHandles{roiIndex} = splineHandle;
    handles.roiSplineHandles = splineHandles;
end


end

