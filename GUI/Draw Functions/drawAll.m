function [ handles ] = drawAll(currentFile, handles, hObject )
%drawAll Used when switching or opening files to get everything up right
%away

if isempty(currentFile)
    cla(handles.imageAxes);
else
    toggled = false;
    
    handles = drawImage(currentFile, handles);
    handles = drawAllRoiLines(currentFile, handles, toggled);
    handles = drawAllRoiPointsWithCallbacks(currentFile, handles, hObject, toggled);
    handles = drawQuickMeasureWithCallback(currentFile, handles, hObject, toggled);        
end


end

