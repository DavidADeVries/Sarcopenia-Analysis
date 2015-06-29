function [ ] = updateGui(currentFile, handles)
%updateGui 
%updates the entire GUI.
%useful if switching files or patients. Overkill if small changes are
%occuring within a file

updateImageInfo(currentFile, handles);
updatePatientSelector(handles);
updateTissueAnalysisTable(currentFile, handles)
updateUnitPanel(currentFile, handles);

disableAllToggles(handles);
updateToggleButtons(currentFile, handles);


end

