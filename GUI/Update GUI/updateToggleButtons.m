function [ ] = updateToggleButtons( handles )
%updateToggleButtons when switching images, the toggle buttons need to be
%correctly depressed or not to begin with

disableAllToggles(handles);

% always available
set(handles.open, 'Enable', 'on');
set(handles.menuOpen, 'Enable', 'on');

set(handles.importPatientDirectory, 'Enable', 'on');
set(handles.addPatient, 'Enable', 'on');

set(handles.menuImportPatientDirectory, 'Enable', 'on');
set(handles.menuAddPatient, 'Enable', 'on');


currentPatient = getCurrentPatient(handles);

if ~isempty(currentPatient) %add in patient operations
    
    if ~currentPatient.changesPending
        set(handles.savePatient, 'Enable', 'off');
        set(handles.menuSavePatient, 'Enable', 'off');
    else
        set(handles.savePatient, 'Enable', 'on');
        set(handles.menuSavePatient, 'Enable', 'on');        
    end
    
    set(handles.saveAll, 'Enable', 'on');
    set(handles.exportPatient, 'Enable', 'on');
    set(handles.exportAllPatients, 'Enable', 'on');
    
    set(handles.addStudy, 'Enable', 'on');
    set(handles.closePatient, 'Enable', 'on');
    set(handles.closeAllPatients, 'Enable', 'on');
    
    set(handles.menuOpen, 'Enable', 'on');
    set(handles.menuSavePatientAs, 'Enable', 'on');
    set(handles.menuSaveAll, 'Enable', 'on');
    set(handles.menuExportPatient, 'Enable', 'on');
    set(handles.menuExportAllPatients, 'Enable', 'on');
    
    set(handles.menuImportPatientDirectory, 'Enable', 'on');
    set(handles.menuAddPatient, 'Enable', 'on');    
    set(handles.menuAddStudy, 'Enable', 'on');
    set(handles.menuClosePatient, 'Enable', 'on');
    set(handles.menuCloseAllPatients, 'Enable', 'on');
           
    currentStudy = currentPatient.getCurrentStudy();
    
    if ~isempty(currentStudy) %add in study operations
        set(handles.addSeries, 'Enable', 'on');        
        set(handles.removeStudy, 'Enable', 'on');
                
        set(handles.menuAddSeries, 'Enable', 'on');        
        set(handles.menuRemoveStudy, 'Enable', 'on');
                
        currentSeries = currentStudy.getCurrentSeries();
        
        if ~isempty(currentSeries) %add in series operations
            set(handles.addFile, 'Enable', 'on');        
            set(handles.removeSeries, 'Enable', 'on');
                
            set(handles.menuAddFile, 'Enable', 'on');        
            set(handles.menuRemoveSeries, 'Enable', 'on');
            
            currentFile = currentSeries.getCurrentFile();
            
            if ~isempty(currentFile) %add in file operations
                % on no matter what state currentFile is in
                set(handles.removeFile, 'Enable', 'on');
                
                set(handles.zoomIn, 'Enable', 'on');
                set(handles.zoomOut, 'Enable', 'on');
                set(handles.pan, 'Enable', 'on');
                
                set(handles.selectRoi, 'Enable', 'on');
                set(handles.quickMeasure, 'Enable', 'on');
                
                set(handles.menuRemoveFile, 'Enable', 'on');
                
                set(handles.menuSelectRoi, 'Enable', 'on');        
                set(handles.menuQuickMeasure, 'Enable', 'on');
                
                %ROI toggle button
                if ~isempty(currentFile.roiPoints)
                    set(handles.toggleRoi, 'Enable', 'on');
                    set(handles.menuToggleRoi, 'Enable', 'on');
                    
                    set(handles.performAnalysis,'Enable','on');
                    set(handles.menuPerformAnalysis,'Enable','on');
                end
                
                if currentFile.roiOn
                    set(handles.toggleRoi, 'State', 'on');
                    set(handles.menuToggleRoi, 'Checked', 'on');
                end
                
                %analysis highlighting
                if ~isempty(currentFile.highlightedImage)
                    set(handles.toggleHighlighting, 'Enable', 'on');
                    set(handles.menuToggleHighlighting, 'Enable', 'on');
                end
                
                if currentFile.highlightingOn
                    set(handles.toggleHighlighting, 'State', 'on');
                    set(handles.menuToggleHighlighting, 'Checked', 'on');
                end
                
                % delete roi
                if currentFile.numRoi ~= 0
                    set(handles.deleteRoi, 'Enable', 'on');
                    set(handles.menuDeleteRoi, 'Enable', 'on');
                end
                
                if handles.deleteRoiOn
                    set(handles.deleteRoi, 'State', 'on');
                    set(handles.menuDeleteRoi, 'Checked', 'on');
                end
                
                %quick measure button
                if ~isempty(currentFile.quickMeasurePoints)
                    set(handles.toggleQuickMeasure, 'Enable', 'on');
                    set(handles.menuToggleQuickMeasure, 'Enable', 'on');
                end
                
                if currentFile.quickMeasureOn
                    set(handles.toggleQuickMeasure, 'State', 'on');
                    set(handles.menuToggleQuickMeasure, 'Checked', 'on');
                end
                
                % undo/redo buttons
                
                undoCache = currentFile.undoCache;
                
                if undoCache.cacheLocation ~= 1
                    set(handles.redo, 'Enable', 'on');
                    set(handles.menuRedo, 'Enable', 'on');
                end
                
                if undoCache.cacheLocation ~= undoCache.numCacheEntries()
                    set(handles.undo, 'Enable', 'on');
                    set(handles.menuUndo, 'Enable', 'on');
                end
                
                % time moving buttons
                
                if currentPatient.getCurrentFileNumInSeries() ~= 1
                    set(handles.earlierImage, 'Enable', 'on');
                    set(handles.earliestImage, 'Enable', 'on');
                    
                    set(handles.menuEarlierImage, 'Enable', 'on');
                    set(handles.menuEarliestImage, 'Enable', 'on');
                end
                
                if currentPatient.getCurrentFileNumInSeries() ~= currentPatient.getNumFilesInSeries()
                    set(handles.laterImage, 'Enable', 'on');
                    set(handles.latestImage, 'Enable', 'on');
                    
                    set(handles.menuLaterImage, 'Enable', 'on');
                    set(handles.menuLatestImage, 'Enable', 'on');
                end
            end
        end
    end      
end

    
end