function [ ] = roiPointCallback(hObject, roiIndex)
% [ ] = roiPointCallback(hObject)
% triggers when an roiPoint is moved.
% callback saves all the roiPoint positions, recomputes the splines, and
% then draws it all again.

handles = guidata(hObject);

handles.updateUndoCache = true; %make sure the undo updater is waiting on click up

currentFile = getCurrentFile(handles);

oneRoiPointHandles = handles.roiPointHandles{roiIndex};

numRoiPoints = length(oneRoiPointHandles);

roiPoints = zeros(numRoiPoints,2);

for i=1:numRoiPoints
    roiPoints(i,:) = oneRoiPointHandles(i).getPosition();  
end

currentFile.roiPoints{roiIndex} = roiPoints;

% updateUndo/pendingChanges should only be done at end of click and drag
% (clickup listener callback)
updateUndo = false;
changesPending = false;

handles = updateFile(currentFile, updateUndo, changesPending, handles);

%update roi
toggled = false;

handles = drawRoiLine(currentFile, handles, toggled, roiIndex);

%push up changes
guidata(hObject, handles);

end

