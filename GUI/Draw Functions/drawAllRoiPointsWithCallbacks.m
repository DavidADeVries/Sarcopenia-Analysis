function handles = drawAllRoiPointsWithCallbacks(currentFile, handles, hObject, toggled)
%handles = drawAllRoiPointsWithCallbacks(currentFile, handles, hObject,
%toggled)
%draws all points for all rois with callbacks for dragging and what not

for i=1:currentFile.numRoi
    handles = drawRoiPointsWithCallback(currentFile, handles, hObject, toggled, i);
end


end

