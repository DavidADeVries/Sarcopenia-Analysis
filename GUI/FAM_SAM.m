function varargout = FAM_SAM(varargin)

% add needed librarys

addpath(genpath('.')); %add all subfolders in the current directory

addpath(genpath(strcat(Constants.GIANT_PATH, 'GIANT Code')));
addpath(strcat(Constants.GIANT_PATH, 'Common Module Functions/Quick Measure'));
addpath(strcat(Constants.GIANT_PATH,'Common Module Functions/Plot Impoint'));
addpath(strcat(Constants.GIANT_PATH,'Common Module Functions/Line Labels'));

% FAM_SAM MATLAB code for FAM_SAM.fig
%      FAM_SAM, by itself, creates a new FAM_SAM or raises the existing
%      singleton*.
%
%      H = FAM_SAM returns the handle to a new FAM_SAM or the handle to
%      the existing singleton*.
%
%      FAM_SAM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FAM_SAM.M with the given input arguments.
%
%      FAM_SAM('Property','Value',...) creates a new FAM_SAM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FAM_SAM_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FAM_SAM_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FAM_SAM

% Last Modified by GUIDE v2.5 20-Aug-2015 11:04:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @FAM_SAM_OpeningFcn, ...
    'gui_OutputFcn',  @FAM_SAM_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before FAM_SAM is made visible.
function FAM_SAM_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FAM_SAM (see VARARGIN)

% Choose default command line output for FAM_SAM
handles.deleteRoiOn = false;
set(hObject, 'Pointer', 'arrow');

giantOpeningFcn(hObject, handles);


% UIWAIT makes FAM_SAM wait for user response (see UIRESUME)
% uiwait(handles.mainPanel);


% --- Outputs from this function are returned to the command line.
function varargout = FAM_SAM_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close mainPanel.
function mainPanel_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to mainPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
% delete(hObject);

giantCloseRequestFcn(hObject, handles);


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function mainPanel_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to mainPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantWindowButtonUpFcn(hObject, handles);



% % % % % % % % % % % % % % % %
% % GIANT BASE UI FUNCTIONS % %
% % % % % % % % % % % % % % % %



% % FILE FUNCTIONS % %

% ONLY FUNCTION IN MENU
% --------------------------------------------------------------------
function menuSavePatientAs_Callback(hObject, eventdata, handles)
% hObject    handle to menuSavePatientAs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantSavePatientAs(hObject, handles);

% --------------------------------------------------------------------
function open_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to menuopen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantOpen(hObject, handles);

% --------------------------------------------------------------------
function savePatient_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to savePatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantSavePatient(hObject, handles);

% --------------------------------------------------------------------
function saveAll_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to saveAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantSaveAll(hObject, handles);

% --------------------------------------------------------------------
function exportPatient_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to exportPatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantExportPatient(hObject, handles);

% --------------------------------------------------------------------
function exportAllPatients_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to menuExportPatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantExportAllPatients(hObject, handles);

% --------------------------------------------------------------------
function exportAsImage_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to exportAsImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantExportAsImage(hObject, handles);


% % EDIT FUNCTIONS % %


% % % % --------------------------------------------------------------------
% % % function undo_ClickedCallback(hObject, eventdata, handles) %#ok<*DEFNU>
% % % % hObject    handle to undo (see GCBO)
% % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % handles    structure with handles and user data (see GUIDATA)
% % % 
% % % giantUndo(hObject, handles);
% % % 
% % % % --------------------------------------------------------------------
% % % function redo_ClickedCallback(hObject, eventdata, handles)
% % % % hObject    handle to redo (see GCBO)
% % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % handles    structure with handles and user data (see GUIDATA)
% % % 
% % % giantRedo(hObject, handles);

% --------------------------------------------------------------------
function undo_ClickedCallback(hObject, eventdata, handles) %#ok<*DEFNU>
% hObject    handle to undo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

currentFile = performUndo(currentFile);

% finalize changes
updateUndo = false;
pendingChanges = true; 
handles = updateFile(currentFile, updateUndo, pendingChanges, handles);

% update display
handles = deleteAll(handles);
handles = drawAll(currentFile, handles, hObject);

updateGui(currentFile, handles);

% push up the changes
guidata(hObject, handles);

% --------------------------------------------------------------------
function redo_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to redo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

currentFile = performRedo(currentFile);

% finalize changes
updateUndo = false;
pendingChanges = true; 
handles = updateFile(currentFile, updateUndo, pendingChanges, handles);

% update display
handles = deleteAll(handles);
handles = drawAll(currentFile, handles, hObject);

updateGui(currentFile, handles);

% push up the changes
guidata(hObject, handles);


% % PATIENT MANAGEMENT FUNCTIONS % %


% --------------------------------------------------------------------
function importPatientDirectory_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to importPatientDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantImportPatientDirectory(hObject, handles);

% --------------------------------------------------------------------
function addPatient_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to addPatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantAddPatient(hObject, handles);

% --------------------------------------------------------------------
function addStudy_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to menuAddStudy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantAddStudy(hObject, handles);

% --------------------------------------------------------------------
function addSeries_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to addSeries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantAddSeries(hObject, handles);

% --------------------------------------------------------------------
function addFile_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to addFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantAddFile(hObject, handles);

% --------------------------------------------------------------------
function closePatient_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to closeAllPatients (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantClosePatient(hObject, handles);

% --------------------------------------------------------------------
function closeAllPatients_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to closeAllPatients (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantCloseAllPatients(hObject, handles);

% --------------------------------------------------------------------
function removeStudy_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to removeStudy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantRemoveStudy(hObject, handles);

% --------------------------------------------------------------------
function removeSeries_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to removeSeries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantRemoveSeries(hObject, handles);

% --------------------------------------------------------------------
function removeFile_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to removeFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantRemoveFile(hObject, handles);

% --------------------------------------------------------------------
function previousSeries_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to previousSeries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantPreviousSeries(hObject, handles);

% --------------------------------------------------------------------
function nextSeries_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to nextSeries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantNextSeries(hObject, handles);

% --------------------------------------------------------------------
function earlierImage_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to earlierImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantEarlierImage(hObject, handles);

% --------------------------------------------------------------------
function laterImage_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to laterImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantLaterImage(hObject, handles);

% --------------------------------------------------------------------
function earliestImage_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to earliestImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantEarliestImage(hObject, handles);

% --------------------------------------------------------------------
function latestImage_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to latestImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantLatestImage(hObject, handles);

% --------------------------------------------------------------------
function resetImage_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to resetImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantResetImage(hObject, handles);


% % DROP-DOWN SELECTORS % %


% --- Executes on selection change in patientSelector.
function patientSelector_Callback(hObject, eventdata, handles)
% hObject    handle to patientSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns patientSelector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from patientSelector

giantPatientSelector(hObject, handles);

% --- Executes during object creation, after setting all properties.
function patientSelector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to patientSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in studySelector.
function studySelector_Callback(hObject, eventdata, handles)
% hObject    handle to studySelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns studySelector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from studySelector

giantStudySelector(hObject, handles);

% --- Executes during object creation, after setting all properties.
function studySelector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to studySelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in seriesSelector.
function seriesSelector_Callback(hObject, eventdata, handles)
% hObject    handle to seriesSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns seriesSelector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from seriesSelector

giantSeriesSelector(hObject, handles);

% --- Executes during object creation, after setting all properties.
function seriesSelector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seriesSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

                    % % % % % % % % % % % % % % % % %
                    % % MODULE SPECIFIC FUNCTIONS % %
                    % % % % % % % % % % % % % % % % %

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 



% % % % % % % % % % % % %
% % ACTION CALLBACKS  % %
% % % % % % % % % % % % %



% --- Executes when selected object is changed in unitPanel.
function unitPanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in unitPanel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

newValue = get(eventdata.NewValue, 'Tag');

currentFile = getCurrentFile(handles);

switch newValue
    case 'unitNone'
        currentFile.displayUnits = 'none';
    case 'unitAbsolute'
        currentFile.displayUnits = 'absolute';
    case 'unitPixel'
        currentFile.displayUnits = 'pixel';
    otherwise
        currentFile.displayUnits = 'none';
end

% finalize changes
updateUndo = false;
pendingChanges = true;

handles = updateFile(currentFile, updateUndo, pendingChanges, handles);

% update display
toggled = false;
handles = drawQuickMeasureWithCallback(currentFile, handles, hObject, toggled);

% push up the changes
guidata(hObject, handles);



% --------------------------------------------------------------------
function selectRoi_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to selectRoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disableAllToggles(handles);

currentFile = getCurrentFile(handles);

% imfreehand returns a jagged ROI, so we will take the points from
% imfreehand, choose a uniform number of points from these.

% STEP 1: get imfreehand points
roiHandle = imfreehand(handles.imageAxes);

rawRoiPoints = getPosition(roiHandle);
delete(roiHandle); %don't need it no more, going draw some splines instead

% STEP 2: make spline from all points. This is NOT the spline displayed
spline = cscvn([rawRoiPoints(:,1)';rawRoiPoints(:,2)']); %spline store as a function
initSplinePoints = fnplt(spline)'; %returns points doesn't actually display them

% STEP 3: from this initial spline, find the spacing of all the points
% plotted for it (not actually displayed)
norms = zeros(height(initSplinePoints)-1,1);

for i=1:height(initSplinePoints)-1
    norms(i) = norm(initSplinePoints(i,:)-initSplinePoints(i+1,:));
end

% STEP 4: find the average spacing of these points and get a resolution so
% that the specified ROI_POINT_RESOLUTION will reflect a roi point every
% "ROI_POINT_RESOLUTION pixels" e.g. a roi point every 15 pxs
averSpacing = mean(norms);

res = round(Constants.ROI_POINT_RESOLUTION/averSpacing);

% STEP 5: Get the ROI points based upon this resolution from the initial
% spline

numPoints = floor(height(initSplinePoints)/res);

roiPoints = zeros(numPoints, 2);

for i=1:height(initSplinePoints)
    if mod(i,res) == 0
        roiPoints(i/res,:) = initSplinePoints(i,:);
    end
end

% STEP 6: Store to the current file. When drawn, a new spline will be fit
% to these sampled points.
% LAST STEP!
currentFile = currentFile.addRoi(roiPoints);
currentFile.roiOn = true;

% finalize changes
updateUndo = true;
pendingChanges = true;

handles = updateFile(currentFile, updateUndo, pendingChanges, handles);

% update display
toggled = false;

handles = drawRoiLine(currentFile, handles, toggled, currentFile.numRoi);
handles = drawRoiPointsWithCallback(currentFile, handles, hObject, toggled, currentFile.numRoi);

updateToggleButtons(handles);

% push up the changes
guidata(hObject, handles);



% --------------------------------------------------------------------
function deleteRoi_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to deleteRoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.deleteRoiOn = ~handles.deleteRoiOn;

if handles.deleteRoiOn
    zoom off;
    pan off;
    
    setptr(handles.mainPanel, 'eraser');
    
    func = @(~, ~) deleteRoiCallback(hObject);
    set(handles.imageHandle, 'ButtonDownFcn', func);
else
    setptr(handles.mainPanel, 'arrow');
    
    set(handles.imageHandle, 'ButtonDownFcn', []);
end

%update display
updateToggleButtons(handles);

% push up the changes
guidata(hObject, handles);



% --------------------------------------------------------------------
function performAnalysis_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to performAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

numRoi = currentFile.numRoi;

if numRoi == 1 || numRoi == 2 %need left and/or right ROIs, no more, no less
    
    disableAllToggles(handles);
    
    image = handles.currentImage;
    dims = size(image);
    
    roiMasks = currentFile.getRoiMasks();
    
    leftRoiMask = roiMasks{1};
    rightRoiMask = roiMasks{numRoi};
    
    mask = leftRoiMask | rightRoiMask;
    
    %get data for kmeans
    
    maskVec = reshape(mask, dims(1)*dims(2), 1);
    imageVec = reshape(image, dims(1)*dims(2), 1);
    
    maskIndices = (maskVec == 1); %returns all indices in the mask where the value is 1
    maskedImageVec = imageVec(maskIndices);
    
    [sortedClusterIndices] = performClusterAnalysis5(maskedImageVec); % low to high intensities returned; 2 clusters
    
    numClusters = 2;
    
    clusterHighlighting = cell(numClusters,1);
    clusterMaskVecs = cell(numClusters,1);
    
    for i=1:numClusters
        indices = sortedClusterIndices{i};
        clusterMaskVec = zeros(dims(1)*dims(2), 1);
        
        k=1; %counter for returned indices
        
        for j=1:dims(1)*dims(2)
            if maskVec(j) %was sent for clustering
                clusterMaskVec(j) = indices(k);
                k = k+1;
            end
        end
        
        clusterMaskVecs{i} = clusterMaskVec;
        clusterHighlighting{i} = reshape(clusterMaskVec, dims(1), dims(2));
        %clusterHighlighting{i} = reshape(sortedClusterIndices{i}, dims(1), dims(2));
    end
    
    clusterMap = zeros(dims);
    
    clusterTags = Constants.CLUSTER_MAP_TAGS;
    
    tagList = [clusterTags.muscle, clusterTags.fat]; %ordered from low to high intensity
    
    for i=1:numClusters
        clusterMap = clusterMap + tagList(i)*clusterHighlighting{i};
    end    
    
    muscleIntensities = image(clusterMap == clusterTags.muscle);
    
    minMuscle = min(muscleIntensities);
    maxMuscle = max(muscleIntensities);
    
    fatIntensities = image(clusterMap == clusterTags.fat);
    
    minFat = min(fatIntensities);
    maxFat = max(fatIntensities);
    
    if maxMuscle == minFat %just in case
        maxMuscle = maxMuscle - 1;
    end
    
    thresholds = struct(...
        'muscleLower', minMuscle,...
        'muscleUpper', maxMuscle,...
        'fatLower', minFat,...
        'fatUpper', maxFat);        
    
    currentFile.clusterMap = []; %reset
    currentFile = currentFile.setThresholds(image, thresholds);
    
    currentFile.fatHighlightOn = true;
    currentFile.muscleHighlightOn = true;
        
    % finalize changes
    updateUndo = true;
    pendingChanges = true;
    
    handles = updateFile(currentFile, updateUndo, pendingChanges, handles);
    
    % update display
    handles = drawImage(currentFile, handles);
    
    updateToggleButtons(handles);
    updateTissueAnalysisTable(currentFile, handles);
    
    % push up the changes
    guidata(hObject, handles);
    
end



% --------------------------------------------------------------------
function setThresholds_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to setThresholds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

clusterMap = currentFile.clusterMap;

if ~isempty(clusterMap)
    disableAllToggles(handles);
    
    updatedFile = histogramPopup(hObject);
    
    if ~isempty(updatedFile) %user didn't click 'Cancel'
        currentFile = updatedFile;
        
        % finalize changes
        updateUndo = true;
        pendingChanges = true;
        
        handles = updateFile(currentFile, updateUndo, pendingChanges, handles);
    end
        
    % update display
    % update for either case because doing the thresholding selection
    % changes the displayed image
    handles = drawImage(currentFile, handles);
    
    updateTissueAnalysisTable(currentFile, handles);    
    updateToggleButtons(handles);
    
    % push up the changes
    guidata(hObject, handles);
end



% --------------------------------------------------------------------
function trimFat_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to trimFat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

clusterMap = currentFile.clusterMap;

if ~isempty(clusterMap)
    clusterTags = Constants.CLUSTER_MAP_TAGS;
    
    toFillMask = (clusterMap == clusterTags.muscle); %have a mask where muscle is 1's, rest is 0's
    
    filledMask = imfill(toFillMask, 'holes'); %fills in all groups of 0 pixels that can't be reached from the background (aka, fat on the inside)
    
    diffMask = filledMask - toFillMask; %now a mask of only the pixels that were filled in last step, aka the interior fat pixels.
    
    fatMask = (clusterMap == clusterTags.fat);
    
    notFatOrMuscleMask = ~( (clusterMap == clusterTags.muscle) | (clusterMap == clusterTags.fat)) ;
    
    exteriorFatMask = (fatMask - (diffMask & ~notFatOrMuscleMask)); %don't want any low intensity muscle that was trimmed to get in   
    
    trimmedClusterMap = clusterMap + (exteriorFatMask * (clusterTags.trimmedFat - clusterTags.fat));
    
    currentFile.clusterMap = trimmedClusterMap;
end

% finalize changes
updateUndo = true;
pendingChanges = true;

handles = updateFile(currentFile, updateUndo, pendingChanges, handles);

% update display
handles = drawImage(currentFile, handles);

updateTissueAnalysisTable(currentFile, handles);

% push up the changes
guidata(hObject, handles);



% --------------------------------------------------------------------
function quickMeasure_ClickedCallback(hObject, eventdata, handles) %#ok<*INUSL>
% hObject    handle to quickMeasure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

lineHandle = imline(handles.imageAxes);

quickMeasurePoints = lineHandle.getPosition();

delete(lineHandle); %will be redrawn shortly, with proper formatting

currentFile = getCurrentFile(handles);

currentFile.quickMeasurePoints = quickMeasurePoints;
currentFile.quickMeasureOn = true;
currentFile = currentFile.chooseDisplayUnits();

% finalize changes
updateUndo = true;
pendingChanges = true; 
handles = updateFile(currentFile, updateUndo, pendingChanges, handles);

% update display
toggled = false;
handles = drawQuickMeasureWithCallback(currentFile, handles, hObject, toggled);

updateToggleButtons(handles);
updateUnitPanel(currentFile, handles);

% push up the changes
guidata(hObject, handles);



% --------------------------------------------------------------------
function generalAccept_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to generalAccept (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

func = get(handles.generalAccept, 'UserData');

switch func
    otherwise
        warning('Invalid UserData setting for generalAccept');
end



% --------------------------------------------------------------------
function generalDecline_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to generalDecline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

func = get(handles.generalAccept, 'UserData');

switch func
    otherwise
        warning('Invalid UserData setting for generalDecline');
end



% % % % % % % % % % % % %
% % TOGGLE CALLBACKS  % %
% % % % % % % % % % % % %



% --------------------------------------------------------------------
function toggleRoi_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toggleRoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);
    
currentFile.roiOn = ~currentFile.roiOn;

% finalize changes
updateUndo = false;
pendingChanges = true;

handles = updateFile(currentFile, updateUndo, pendingChanges, handles);

% update display
toggled = true;

handles = drawAllRoiLines(currentFile, handles, toggled);
handles = drawAllRoiPointsWithCallbacks(currentFile, handles, hObject, toggled);

updateToggleButtons(handles);

% push up the changes
guidata(hObject, handles);



% --------------------------------------------------------------------
function toggleFatHighlighting_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toggleFatHighlighting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

currentFile.fatHighlightOn = ~currentFile.fatHighlightOn;

% finalize changes
updateUndo = false;
pendingChanges = true;

handles = updateFile(currentFile, updateUndo, pendingChanges, handles);

% update display
handles = drawImage(currentFile, handles);

updateToggleButtons(handles);

% push up the changes
guidata(hObject, handles);



% --------------------------------------------------------------------
function toggleMuscleHighlighting_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toggleMuscleHighlighting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

currentFile.muscleHighlightOn = ~currentFile.muscleHighlightOn;

% finalize changes
updateUndo = false;
pendingChanges = true;

handles = updateFile(currentFile, updateUndo, pendingChanges, handles);

% update display
handles = drawImage(currentFile, handles);

updateToggleButtons(handles);

% push up the changes
guidata(hObject, handles);



% --------------------------------------------------------------------
function toggleQuickMeasure_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toggleQuickMeasure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

currentFile.quickMeasureOn = ~currentFile.quickMeasureOn;

% finalize changes
updateUndo = false;
pendingChanges = true; 
handles = updateFile(currentFile, updateUndo, pendingChanges, handles);

% update display
toggled = true;
handles = drawQuickMeasureWithCallback(currentFile, handles, hObject, toggled);

updateToggleButtons(handles);
updateUnitPanel(currentFile, handles);

% push up the changes
guidata(hObject, handles);




% % % % % % % % % % % %
% % MENU CALLBACKS  % %
% % % % % % % % % % % %




% these simply call their clickable toolbar counterparts



% MENU FILE CALLBACKS



% --------------------------------------------------------------------
function menuFile_Callback(hObject, eventdata, handles)
% hObject    handle to menuFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menuOpen_Callback(hObject, eventdata, handles)
% hObject    handle to menuOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

open_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuSavePatient_Callback(hObject, eventdata, handles)
% hObject    handle to menuSavePatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

savePatient_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuSaveAll_Callback(hObject, eventdata, handles)
% hObject    handle to menuSaveAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

saveAll_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuExportPatient_Callback(hObject, eventdata, handles)
% hObject    handle to menuExportPatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

exportPatient_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuExportAllPatients_Callback(hObject, eventdata, handles)
% hObject    handle to menuExportAllPatients (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

exportAllPatients_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuExportAsImage_Callback(hObject, eventdata, handles)
% hObject    handle to menuExportAsImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

exportAsImage_ClickedCallback(hObject, eventdata, handles);



% MENU PATIENT MANAGMENT CALLBACKS



% --------------------------------------------------------------------
function menuPatientManagement_Callback(hObject, eventdata, handles)
% hObject    handle to menuPatientManagement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menuImportPatientDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to menuImportPatientDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

importPatientDirectory_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuAddPatient_Callback(hObject, eventdata, handles)
% hObject    handle to menuAddPatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

addPatient_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuAddStudy_Callback(hObject, eventdata, handles)
% hObject    handle to menuAddStudy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

addStudy_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuAddSeries_Callback(hObject, eventdata, handles)
% hObject    handle to menuAddSeries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

addSeries_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuAddFile_Callback(hObject, eventdata, handles)
% hObject    handle to menuAddFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

addFile_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuClosePatient_Callback(hObject, eventdata, handles)
% hObject    handle to menuClosePatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

closePatient_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuCloseAllPatients_Callback(hObject, eventdata, handles)
% hObject    handle to menuCloseAllPatients (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

closeAllPatients_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuRemoveStudy_Callback(hObject, eventdata, handles)
% hObject    handle to menuRemoveStudy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

removeStudy_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuRemoveSeries_Callback(hObject, eventdata, handles)
% hObject    handle to menuRemoveSeries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

removeSeries_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuRemoveFile_Callback(hObject, eventdata, handles)
% hObject    handle to menuRemoveFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

removeFile_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuPreviousSeries_Callback(hObject, eventdata, handles)
% hObject    handle to menuPreviousSeries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

previousSeries_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuNextSeries_Callback(hObject, eventdata, handles)
% hObject    handle to menuNextSeries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

nextSeries_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuEarlierImage_Callback(hObject, eventdata, handles)
% hObject    handle to menuEarlierImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

earlierImage_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuLaterImage_Callback(hObject, eventdata, handles)
% hObject    handle to menuLaterImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

laterImage_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuEarliestImage_Callback(hObject, eventdata, handles)
% hObject    handle to menuEarliestImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

earliestImage_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuLatestImage_Callback(hObject, eventdata, handles)
% hObject    handle to menuLatestImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

latestImage_ClickedCallback(hObject, eventdata, handles);



% MENU EDIT CALLBACKS



% --------------------------------------------------------------------
function menuEdit_Callback(hObject, eventdata, handles)
% hObject    handle to menuEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menuUndo_Callback(hObject, eventdata, handles)
% hObject    handle to menuUndo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

undo_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuRedo_Callback(hObject, eventdata, handles)
% hObject    handle to menuRedo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

redo_ClickedCallback(hObject, eventdata, handles);



% MENU TOOLS CALLBACKS



% --------------------------------------------------------------------
function menuTools_Callback(hObject, eventdata, handles)
% hObject    handle to menuTools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menuResetImage_Callback(hObject, eventdata, handles)
% hObject    handle to menuResetImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

resetImage_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuSelectRoi_Callback(hObject, eventdata, handles)
% hObject    handle to menuSelectRoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selectRoi_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuDeleteRoi_Callback(hObject, eventdata, handles)
% hObject    handle to menuDeleteRoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

deleteRoi_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuPerformAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to menuPerformAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

performAnalysis_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuSetThresholds_Callback(hObject, eventdata, handles)
% hObject    handle to menuSetThresholds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setThresholds_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuTrimFat_Callback(hObject, eventdata, handles)
% hObject    handle to menuTrimFat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

trimFat_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuQuickMeasure_Callback(hObject, eventdata, handles)
% hObject    handle to menuQuickMeasure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

quickMeasure_ClickedCallback(hObject, eventdata, handles);



% MENU VIEW (TOGGLE) CALLBACKS



% --------------------------------------------------------------------
function menuView_Callback(hObject, eventdata, handles)
% hObject    handle to menuView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menuToggleRoi_Callback(hObject, eventdata, handles)
% hObject    handle to menuToggleRoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

toggleRoi_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuToggleFatHighlighting_Callback(hObject, eventdata, handles)
% hObject    handle to menuToggleFatHighlighting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

toggleFatHighlighting_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuToggleMuscleHighlighting_Callback(hObject, eventdata, handles)
% hObject    handle to menuToggleMuscleHighlighting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

toggleMuscleHighlighting_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuToggleQuickMeasure_Callback(hObject, eventdata, handles)
% hObject    handle to menuToggleQuickMeasure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

toggleQuickMeasure_ClickedCallback(hObject, eventdata, handles);
