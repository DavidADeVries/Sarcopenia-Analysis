function [ ] = updateGui(currentFile, handles)
%updateGui 
%updates the entire GUI.
%useful if switching files or patients. Overkill if small changes are
%occuring within a file

updateImageInfo(currentFile, handles);

updatePatientSelector(handles);
updateStudySelector(handles);
updateSeriesSelector(handles);

updateUnitPanel(currentFile, handles);

updateTissueAnalysisTable(currentFile, handles)

updateToggleButtons(handles);

end

