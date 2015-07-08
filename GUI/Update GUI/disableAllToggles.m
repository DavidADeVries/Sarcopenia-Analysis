function [ ] = disableAllToggles( handles )
%disableAllToggles used when no patients are open to just lock everything
%down

%toolbar options
set(handles.open, 'Enable', 'off');
set(handles.savePatient, 'Enable', 'off');
set(handles.saveAll, 'Enable', 'off');
set(handles.exportPatient, 'Enable', 'off');
set(handles.exportAllPatients, 'Enable', 'off');

set(handles.undo, 'Enable', 'off');
set(handles.redo, 'Enable', 'off');

set(handles.importPatientDirectory, 'Enable', 'off');
set(handles.addPatient, 'Enable', 'off');
set(handles.addStudy, 'Enable', 'off');
set(handles.addSeries, 'Enable', 'off');
set(handles.addFile, 'Enable', 'off');
set(handles.closePatient, 'Enable', 'off');
set(handles.closeAllPatients, 'Enable', 'off');
set(handles.removeStudy, 'Enable', 'off');
set(handles.removeSeries, 'Enable', 'off');
set(handles.removeFile, 'Enable', 'off');

set(handles.earliestImage, 'Enable', 'off');
set(handles.earlierImage, 'Enable', 'off');
set(handles.laterImage, 'Enable', 'off');
set(handles.latestImage, 'Enable', 'off');

set(handles.zoomIn, 'Enable', 'off');
set(handles.zoomOut, 'Enable', 'off');
set(handles.pan, 'Enable', 'off');

set(handles.selectRoi, 'Enable', 'off');
set(handles.deleteRoi, 'Enable', 'off');
set(handles.performAnalysis, 'Enable', 'off');
set(handles.quickMeasure, 'Enable', 'off');

set(handles.deleteRoi, 'State', 'off');

set(handles.toggleRoi, 'Enable', 'off');
set(handles.toggleHighlighting, 'Enable', 'off');
set(handles.toggleQuickMeasure, 'Enable', 'off');

set(handles.toggleRoi, 'State', 'off');
set(handles.toggleHighlighting, 'State', 'off');
set(handles.toggleQuickMeasure, 'State', 'off');

% don't even want to see these ones
set(handles.generalAccept, 'Visible', 'off');
set(handles.generalDecline, 'Visible', 'off');

%menu options
set(handles.menuOpen, 'Enable', 'off');
set(handles.menuSavePatient, 'Enable', 'off');
set(handles.menuSavePatientAs, 'Enable', 'off');
set(handles.menuSaveAll, 'Enable', 'off');
set(handles.menuExportPatient, 'Enable', 'off');
set(handles.menuExportAllPatients, 'Enable', 'off');

set(handles.menuUndo, 'Enable', 'off');
set(handles.menuRedo, 'Enable', 'off');

set(handles.menuImportPatientDirectory, 'Enable', 'off');
set(handles.menuAddPatient, 'Enable', 'off');
set(handles.menuAddStudy, 'Enable', 'off');
set(handles.menuAddSeries, 'Enable', 'off');
set(handles.menuAddFile, 'Enable', 'off');
set(handles.menuClosePatient, 'Enable', 'off');
set(handles.menuCloseAllPatients, 'Enable', 'off');
set(handles.menuRemoveStudy, 'Enable', 'off');
set(handles.menuRemoveSeries, 'Enable', 'off');
set(handles.menuRemoveFile, 'Enable', 'off');

set(handles.menuEarliestImage, 'Enable', 'off');
set(handles.menuEarlierImage, 'Enable', 'off');
set(handles.menuLaterImage, 'Enable', 'off');
set(handles.menuLatestImage, 'Enable', 'off');

set(handles.menuSelectRoi, 'Enable', 'off');
set(handles.menuDeleteRoi, 'Enable', 'off');
set(handles.menuPerformAnalysis, 'Enable', 'off');
set(handles.menuQuickMeasure, 'Enable', 'off');

set(handles.menuDeleteRoi, 'Checked', 'off');

set(handles.menuToggleRoi, 'Enable', 'off');
set(handles.menuToggleHighlighting, 'Enable', 'off');
set(handles.menuToggleQuickMeasure, 'Enable', 'off');

set(handles.menuToggleRoi, 'Checked', 'off');
set(handles.menuToggleHighlighting, 'Checked', 'off');
set(handles.menuToggleQuickMeasure, 'Checked', 'off');

end

