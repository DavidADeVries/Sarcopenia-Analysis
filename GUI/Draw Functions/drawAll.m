function [ handles ] = drawAll(currentFile, handles, hObject, varargin )
%[ handles ] = drawAll(currentFile, handles, hObject, saveZoom*)
% Used when switching or opening files to get everything up right away
% saveZoom optional: default is false

if isempty(currentFile)
    cla(handles.imageAxes);
else
    toggled = false;
    
    saveZoom = false;
    
    if length(varargin) == 1
        saveZoom = varargin{1};
    end
    
    handles = drawImage(currentFile, handles, saveZoom);
    handles = drawAllRoiLines(currentFile, handles, toggled);
    handles = drawAllRoiPointsWithCallbacks(currentFile, handles, hObject, toggled);
    handles = drawQuickMeasureWithCallback(currentFile, handles, hObject, toggled);        
end


end

