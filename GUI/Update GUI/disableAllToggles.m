function [ ] = disableAllToggles( handles )
%disableAllToggles used when no patients are open to just lock everything
%down

disableAllGiantToggleButtons(handles);

%toolbar options

set(handles.zoomIn, 'Enable', 'off');
set(handles.zoomOut, 'Enable', 'off');
set(handles.pan, 'Enable', 'off');

set(handles.zoomIn, 'State', 'off');
set(handles.zoomOut, 'State', 'off');
set(handles.pan, 'State', 'off');

set(handles.selectRoi, 'Enable', 'off');
set(handles.deleteRoi, 'Enable', 'off');
set(handles.performAnalysis, 'Enable', 'off');
set(handles.trimFat, 'Enable', 'off');
set(handles.trimMuscle, 'Enable', 'off');
set(handles.quickMeasure, 'Enable', 'off');

set(handles.deleteRoi, 'State', 'off');

set(handles.toggleRoi, 'Enable', 'off');
set(handles.toggleFatHighlighting, 'Enable', 'off');
set(handles.toggleMuscleHighlighting, 'Enable', 'off');
set(handles.toggleQuickMeasure, 'Enable', 'off');

set(handles.toggleRoi, 'State', 'off');
set(handles.toggleFatHighlighting, 'State', 'off');
set(handles.toggleMuscleHighlighting, 'State', 'off');
set(handles.toggleQuickMeasure, 'State', 'off');

% don't even want to see these ones
set(handles.generalAccept, 'Visible', 'off');
set(handles.generalDecline, 'Visible', 'off');

%menu options

set(handles.menuSelectRoi, 'Enable', 'off');
set(handles.menuDeleteRoi, 'Enable', 'off');
set(handles.menuPerformAnalysis, 'Enable', 'off');
set(handles.menuTrimFat, 'Enable', 'off');
set(handles.menuTrimMuscle, 'Enable', 'off');
set(handles.menuQuickMeasure, 'Enable', 'off');

set(handles.menuDeleteRoi, 'Checked', 'off');

set(handles.menuToggleRoi, 'Enable', 'off');
set(handles.menuToggleFatHighlighting, 'Enable', 'off');
set(handles.menuToggleMuscleHighlighting, 'Enable', 'off');
set(handles.menuToggleQuickMeasure, 'Enable', 'off');

set(handles.menuToggleRoi, 'Checked', 'off');
set(handles.menuToggleFatHighlighting, 'Checked', 'off');
set(handles.menuToggleMuscleHighlighting, 'Checked', 'off');
set(handles.menuToggleQuickMeasure, 'Checked', 'off');

end

