function [ ] = updateToggleButtons( handles )
%updateToggleButtons when switching images, the toggle buttons need to be
%correctly depressed or not to begin with

disableAllToggles(handles);

updateGiantToggleButtons(handles)

% always available

currentFile = getCurrentFile(handles);

if ~isempty(currentFile) %add in module file operations
    % on no matter what state currentFile is in
    
    set(handles.zoomIn, 'Enable', 'on');
    set(handles.zoomOut, 'Enable', 'on');
    set(handles.pan, 'Enable', 'on');
    
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
        set(handles.toggleHighlighting, 'Enable', 'on');
        set(handles.menuToggleHighlighting, 'Enable', 'on');
        
        % allow trimming        
        set(handles.trimFat, 'Enable', 'on');
        set(handles.trimMuscle, 'Enable', 'on');
        
        set(handles.menuTrimFat, 'Enable', 'on');
        set(handles.menuTrimMuscle, 'Enable', 'on');
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
end

    
end