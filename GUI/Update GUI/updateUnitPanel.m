function [] = updateUnitPanel(currentFile, handles)
%updateUnitPanel takes the unitPanel radio buttons and enables/disables
%them

if ~isempty(currentFile) && currentFile.quickMeasureOn
    enableVal = 'on';
    
    switch currentFile.displayUnits
        case 'none'
            set(handles.unitNone, 'Value', 1);
        case 'absolute'
            set(handles.unitAbsolute, 'Value', 1);
        case 'pixel'
            set(handles.unitPixel, 'Value', 1);
        otherwise
            set(handles.unitNone, 'Value', 1);
    end
else
    enableVal = 'off';
end

set(handles.unitNone, 'Enable', enableVal);
set(handles.unitAbsolute, 'Enable', enableVal);
set(handles.unitPixel, 'Enable', enableVal);

end

