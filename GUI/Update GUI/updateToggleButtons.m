function [ ] = updateToggleButtons( handles )
%updateToggleButtons when switching images, the toggle buttons need to be
%correctly depressed or not to begin with

disableAllToggles(handles);

updateGiantToggleButtons(handles)

% always available

currentFile = getCurrentFile(handles);

if ~isempty(currentFile) %add in module file operations
    % on no matter what state currentFile is in
        
    set(handles.selectRoi, 'Enable', 'on');
    set(handles.quickMeasure, 'Enable', 'on');
    
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
    if ~isempty(currentFile.clusterMap)
        set(handles.toggleFatHighlighting, 'Enable', 'on');
        set(handles.toggleMuscleHighlighting, 'Enable', 'on');
        
        set(handles.menuToggleFatHighlighting, 'Enable', 'on');
        set(handles.menuToggleMuscleHighlighting, 'Enable', 'on');
        
        % allow trimming        
        set(handles.setThresholds, 'Enable', 'on');
        set(handles.trimFat, 'Enable', 'on');
        
        set(handles.menuSetThresholds, 'Enable', 'on');
        set(handles.menuTrimFat, 'Enable', 'on');
    end
    
    if currentFile.fatHighlightOn
        set(handles.toggleFatHighlighting, 'State', 'on');
        set(handles.menuToggleFatHighlighting, 'Checked', 'on');
    end
    
    if currentFile.muscleHighlightOn
        set(handles.toggleMuscleHighlighting, 'State', 'on');
        set(handles.menuToggleMuscleHighlighting, 'Checked', 'on');
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
end

    
end