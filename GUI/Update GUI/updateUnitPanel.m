function [] = updateUnitPanel(currentFile, handles)
%updateUnitPanel takes the unitPanel radio buttons and enables/disables
%them

if isempty(currentFile)
    enableVal = 'off';
    
    set(handles.unitNone, 'Value', 1);
elseif currentFile.quickMeasureOn
    displayUnits = currentFile.displayUnits();
    
    enableVal = 'on';
      
    switch displayUnits
        case 'none'
            set(handles.unitNone, 'Value', 1);
        case 'absolute'
            set(handles.unitAbsolute, 'Value', 1);
        case 'pixel'
            set(handles.unitPixel, 'Value', 1);
        otherwise
            set(handles.unitNone, 'Value', 1);
    end
else %nothing is on that needs unit measurement
    enableVal = 'off';
end

% apply the found enableVal to each radio button
set(handles.unitNone, 'Enable', enableVal);
set(handles.unitAbsolute, 'Enable', enableVal);
set(handles.unitPixel, 'Enable', enableVal);

end

