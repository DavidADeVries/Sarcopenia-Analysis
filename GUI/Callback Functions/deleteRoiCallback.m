function [ ] = deleteRoiCallback(hObject)
% [ ] = deleteRoiCallback(hObject)
% deletes a ROI if it pressed

handles = guidata(hObject);

handles.updateUndoCache = true; %make sure the undo updater is waiting on click up

currentFile = getCurrentFile(handles);

%create map of ROIs
dims = size(currentFile.image);
map = zeros(dims);

for i=1:currentFile.numRoi
    %calculate spline
    
    roiPoints = currentFile.roiPoints{i};
    
    roiPoints = [roiPoints; roiPoints(1,:)]; %duplicate last point
    
    x = roiPoints(:,1)';
    y = roiPoints(:,2)';
    
    spline = cscvn([x;y]); %spline store as a function
    
    %plot spline
    splinePoints = fnplt(spline)';
    
    roiMask = fastMask(splinePoints, dims);
    
    map = map + i*roiMask;
    
    for j=1:dims(1)
        for k=1:dims(2)
            if map(j,k) > i %overlap
                map(j,k) = i; %set to most recent roi
            end
        end
    end
end

currentPoint = get(handles.imageAxes, 'CurrentPoint');

clickedPoint = [currentPoint(2,1), currentPoint(2,2)];

roiIndex = map(round(clickedPoint(2)), round(clickedPoint(1)));

if roiIndex ~= 0 % need to delete something
    currentFile = currentFile.deleteRoi(roiIndex);
    
    if currentFile.numRoi == 0 %disable since no more can be deleted
        handles.deleteRoiOn = false;
        
        setptr(handles.mainPanel, 'arrow');
    
        set(handles.imageHandle, 'ButtonDownFcn', []);
        
        currentFile.roiOn = false;
    end
    
    % updateUndo/pendingChanges should only be done at end of click and drag
    % (clickup listener callback)
    updateUndo = false;
    changesPending = false;
    
    handles = updateFile(currentFile, updateUndo, changesPending, handles);
    
    %update roi   
    handles = deleteRoiLine(handles, roiIndex);
    handles = deleteRoiPoints(handles, roiIndex);
    
    %push up changes
    guidata(hObject, handles);
end

end

