function [ ] = updateToggleButtons( file, handles )
%updateToggleButtons when switching images, the toggle buttons need to be
%correctly depressed or not to begin with

currentPatient = getCurrentPatient(handles);

if handles.numPatients == 0 %if no patients, only allow opening new files
    disableAllToggles(handles);
    
    set(handles.menuOpen, 'Enable', 'on');
    set(handles.open, 'Enable', 'on');
    set(handles.menuAddPatient, 'Enable', 'on');
    set(handles.addPatient, 'Enable', 'on');
elseif isempty(file) %patient open, but no files. Can only perform patient operations
    disableAllToggles(handles);
    
    set(handles.open, 'Enable', 'on');
    set(handles.savePatient, 'Enable', 'on');
    set(handles.saveAll, 'Enable', 'on');
    set(handles.exportPatient, 'Enable', 'on');
    set(handles.exportAllPatients, 'Enable', 'on');
    set(handles.addPatient, 'Enable', 'on');
    set(handles.addFile, 'Enable', 'on');
    set(handles.closePatient, 'Enable', 'on');
    set(handles.closeAllPatients, 'Enable', 'on');
    
    set(handles.menuOpen, 'Enable', 'on');
    set(handles.menuSavePatient, 'Enable', 'on');
    set(handles.menuSavePatientAs, 'Enable', 'on');
    set(handles.menuSaveAll, 'Enable', 'on');
    set(handles.menuExportPatient, 'Enable', 'on');
    set(handles.menuExportAllPatients, 'Enable', 'on');
    set(handles.menuAddPatient, 'Enable', 'on');
    set(handles.menuAddFile, 'Enable', 'on');
    set(handles.menuClosePatient, 'Enable', 'on');
    set(handles.menuCloseAllPatients, 'Enable', 'on');
    
    set(handles.patientSelector, 'Enable', 'on');   
    
    if ~currentPatient.changesPending
        set(handles.savePatient, 'Enable', 'off');
        set(handles.menuSavePatient, 'Enable', 'off');
    end
else %general toggles that must be turned on if any file is open, regardless of what state its at
    set(handles.patientSelector, 'Enable', 'on');
    
    set(handles.open, 'Enable', 'on');
    set(handles.savePatient, 'Enable', 'on');
    set(handles.saveAll, 'Enable', 'on');
    set(handles.exportPatient, 'Enable', 'on');
    set(handles.exportAllPatients, 'Enable', 'on');
    set(handles.addPatient, 'Enable', 'on');
    set(handles.addFile, 'Enable', 'on');
    set(handles.closePatient, 'Enable', 'on');
    set(handles.closeAllPatients, 'Enable', 'on');
    set(handles.removeFile, 'Enable', 'on');
    set(handles.zoomIn, 'Enable', 'on');
    set(handles.zoomOut, 'Enable', 'on');
    set(handles.pan, 'Enable', 'on');
    set(handles.selectRoi, 'Enable', 'on');
    set(handles.performAnalysis, 'Enable', 'on');
    set(handles.quickMeasure, 'Enable', 'on');
    
    set(handles.menuOpen, 'Enable', 'on');
    set(handles.menuSavePatient, 'Enable', 'on');
    set(handles.menuSavePatientAs, 'Enable', 'on');
    set(handles.menuSaveAll, 'Enable', 'on');
    set(handles.menuExportPatient, 'Enable', 'on');
    set(handles.menuExportAllPatients, 'Enable', 'on');
    set(handles.menuAddPatient, 'Enable', 'on');
    set(handles.menuAddFile, 'Enable', 'on');
    set(handles.menuClosePatient, 'Enable', 'on');
    set(handles.menuCloseAllPatients, 'Enable', 'on');
    set(handles.menuRemoveFile, 'Enable', 'on');
    %     set(handles.menuzoomIn, 'Enable', 'on');
    %     set(handles.menuzoomOut, 'Enable', 'on');
    %     set(handles.menupan, 'Enable', 'on');
    set(handles.menuSelectRoi, 'Enable', 'on');
    set(handles.menuPerformAnalysis, 'Enable', 'on');
    set(handles.menuQuickMeasure, 'Enable', 'on');
    
    %ROI toggle button
    if isempty(file.roiPoints)
        set(handles.toggleRoi, 'Enable', 'off');
        set(handles.menuToggleRoi, 'Enable', 'off');
        
        set(handles.performAnalysis,'Enable','off');
        set(handles.menuPerformAnalysis,'Enable','off');
    else
        set(handles.toggleRoi, 'Enable', 'on');
        set(handles.menuToggleRoi, 'Enable', 'on');
        
        set(handles.performAnalysis,'Enable','on');
        set(handles.menuPerformAnalysis,'Enable','on');
    end
    
    if file.roiOn
        set(handles.toggleRoi, 'State', 'on');
        set(handles.menuToggleRoi, 'Checked', 'on');
    else
        set(handles.toggleRoi, 'State', 'off');
        set(handles.menuToggleRoi, 'Checked', 'off');
    end
    
    %analysis highlighting
    if isempty(file.highlightedImage)
        set(handles.toggleHighlighting, 'Enable', 'off');
        set(handles.menuToggleHighlighting, 'Enable', 'off');
    else
        set(handles.toggleHighlighting, 'Enable', 'on');
        set(handles.menuToggleHighlighting, 'Enable', 'on');
    end
    
    if file.highlightingOn
        set(handles.toggleHighlighting, 'State', 'on');
        set(handles.menuToggleHighlighting, 'Checked', 'on');
    else
        set(handles.toggleHighlighting, 'State', 'off');
        set(handles.menuToggleHighlighting, 'Checked', 'off');
    end
    
    % delete roi
    if file.numRoi ~= 0
       set(handles.deleteRoi, 'Enable', 'on');
       set(handles.menuDeleteRoi, 'Enable', 'on');
    else
        set(handles.deleteRoi, 'Enable', 'off');
        set(handles.menuDeleteRoi, 'Enable', 'off');
    end
    
    if handles.deleteRoiOn
        set(handles.deleteRoi, 'State', 'on');
        set(handles.menuDeleteRoi, 'Checked', 'on');
    else
        set(handles.deleteRoi, 'State', 'off');
        set(handles.menuDeleteRoi, 'Checked', 'off');
    end
    
    %quick measure button
    if isempty(file.quickMeasurePoints)
        set(handles.toggleQuickMeasure, 'Enable', 'off');
        set(handles.menuToggleQuickMeasure, 'Enable', 'off');
    else
        set(handles.toggleQuickMeasure, 'Enable', 'on');
        set(handles.menuToggleQuickMeasure, 'Enable', 'on');
    end
    
    if file.quickMeasureOn
        set(handles.toggleQuickMeasure, 'State', 'on');
        set(handles.menuToggleQuickMeasure, 'Checked', 'on');
    else
        set(handles.toggleQuickMeasure, 'State', 'off');
        set(handles.menuToggleQuickMeasure, 'Checked', 'off');
    end
    
    % undo/redo buttons
    
    undoCache = file.undoCache;
    
    if undoCache.cacheLocation == 1
        set(handles.redo, 'Enable', 'off');
        set(handles.menuRedo, 'Enable', 'off');
    else
        set(handles.redo, 'Enable', 'on');
        set(handles.menuRedo, 'Enable', 'on');
    end
    
    if undoCache.cacheLocation == undoCache.numCacheEntries()
        set(handles.undo, 'Enable', 'off');
        set(handles.menuUndo, 'Enable', 'off');
    else
        set(handles.undo, 'Enable', 'on');
        set(handles.menuUndo, 'Enable', 'on');
    end
        
    % time moving buttons
        
    if currentPatient.currentFileNum == 1
        set(handles.earlierImage, 'Enable', 'off');
        set(handles.earliestImage, 'Enable', 'off');
    else
        set(handles.earlierImage, 'Enable', 'on');
        set(handles.earliestImage, 'Enable', 'on');
    end
    
    if currentPatient.currentFileNum == length(currentPatient.files)
        set(handles.laterImage, 'Enable', 'off');
        set(handles.latestImage, 'Enable', 'off');
    else
        set(handles.laterImage, 'Enable', 'on');
        set(handles.latestImage, 'Enable', 'on');
    end
        
    % save button
    
    if ~currentPatient.changesPending
        set(handles.savePatient, 'Enable', 'off');
    end    
    
end