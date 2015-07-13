function varargout = Sarcopenia_Analysis(varargin)

% add needed librarys

addpath(genpath('.')); %add all subfolders in the current directory

addpath(genpath(strcat(Constants.GIANT_PATH, 'GIANT Code')));
addpath(strcat(Constants.GIANT_PATH, 'Common Module Functions/Quick Measure'));
addpath(strcat(Constants.GIANT_PATH,'Common Module Functions/Plot Impoint'));

% SARCOPENIA_ANALYSIS MATLAB code for Sarcopenia_Analysis.fig
%      SARCOPENIA_ANALYSIS, by itself, creates a new SARCOPENIA_ANALYSIS or raises the existing
%      singleton*.
%
%      H = SARCOPENIA_ANALYSIS returns the handle to a new SARCOPENIA_ANALYSIS or the handle to
%      the existing singleton*.
%
%      SARCOPENIA_ANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SARCOPENIA_ANALYSIS.M with the given input arguments.
%
%      SARCOPENIA_ANALYSIS('Property','Value',...) creates a new SARCOPENIA_ANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Sarcopenia_Analysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Sarcopenia_Analysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Sarcopenia_Analysis

% Last Modified by GUIDE v2.5 08-Jul-2015 10:55:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Sarcopenia_Analysis_OpeningFcn, ...
    'gui_OutputFcn',  @Sarcopenia_Analysis_OutputFcn, ...
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


% --- Executes just before Sarcopenia_Analysis is made visible.
function Sarcopenia_Analysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Sarcopenia_Analysis (see VARARGIN)

% Choose default command line output for Sarcopenia_Analysis
handles.deleteRoiOn = false;
set(hObject, 'Pointer', 'arrow');

giantOpeningFcn(hObject, handles);


% UIWAIT makes Sarcopenia_Analysis wait for user response (see UIRESUME)
% uiwait(handles.mainPanel);


% --- Outputs from this function are returned to the command line.
function varargout = Sarcopenia_Analysis_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% % % % % % % % % % % % % % % %
% % GIANT BASE UI FUNCTIONS % %
% % % % % % % % % % % % % % % %



% --------------------------------------------------------------------
function open_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to menuopen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantOpen(hObject, handles);

% --------------------------------------------------------------------
function exportAllPatients_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to menuExportPatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantExportAllPatients(hObject, handles);

% --------------------------------------------------------------------
function exportPatient_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to exportPatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantExportPatient(hObject, handles);

% --------------------------------------------------------------------
function closeAllPatients_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to closeAllPatients (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantCloseAllPatient(hObject, handles);

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
saveZoom = true; % preserves current zoom state

handles = deleteAll(handles);
handles = drawAll(currentFile, handles, hObject, saveZoom);

updateToggleButtons(handles);
updateUnitPanel(currentFile, handles);

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
saveZoom = true; % preserves current zoom state

handles = deleteAll(handles);
handles = drawAll(currentFile, handles, hObject, saveZoom);

updateToggleButtons(handles);
updateUnitPanel(currentFile, handles);

% push up the changes
guidata(hObject, handles);



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
function closePatient_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to closeAllPatients (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantClosePatient(hObject, handles);

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
function importPatientDirectory_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to importPatientDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantImportPatientDirectory(hObject, handles);

% --------------------------------------------------------------------
function menuSavePatientAs_Callback(hObject, eventdata, handles)
% hObject    handle to menuSavePatientAs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantSavePatientAs(hObject, handles);




% % % % % % % % % % % % % % % % %
% % MODULE SPECIFIC FUNCTIONS % %
% % % % % % % % % % % % % % % % %



% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function mainPanel_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to mainPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.updateUndoCache    
    currentFile = getCurrentFile(handles);
        
    %save changes
    updateUndo = true;
    pendingChanges = true;
    
    handles = updateFile(currentFile, updateUndo, pendingChanges, handles); %undo cache will be auto updated
    
    % reset updateUndoCache variable (will on go again when a callback is
    % triggered, not just any click)
    handles.updateUndoCache = false;
    
    updateToggleButtons(handles);
    
    %push up changes
    guidata(hObject, handles);
end

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

% --------------------------------------------------------------------
function selectRoi_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to selectRoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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
function menuSelectRoi_Callback(hObject, eventdata, handles)
% hObject    handle to menuSelectRoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selectRoi_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuQuickMeasure_Callback(hObject, eventdata, handles)
% hObject    handle to menuQuickMeasure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

quickMeasure_ClickedCallback(hObject, eventdata, handles);

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


% --------------------------------------------------------------------
function menuPerformAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to menuPerformAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

performAnalysis_ClickedCallback(hObject, eventdata, handles);


% --------------------------------------------------------------------
function menuClosePatient_Callback(hObject, eventdata, handles)
% hObject    handle to menuClosePatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

closePatient_ClickedCallback(hObject, eventdata, handles);


% --------------------------------------------------------------------
function menuEdit_Callback(hObject, eventdata, handles)
% hObject    handle to menuEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuTools_Callback(hObject, eventdata, handles)
% hObject    handle to menuTools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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
function menuToggleHighlighting_Callback(hObject, eventdata, handles)
% hObject    handle to menuToggleHighlighting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

toggleHighlighting_ClickedCallback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function menuToggleQuickMeasure_Callback(hObject, eventdata, handles)
% hObject    handle to menuToggleQuickMeasure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

toggleQuickMeasure_ClickedCallback(hObject, eventdata, handles);


% --------------------------------------------------------------------
function menuRemoveFile_Callback(hObject, eventdata, handles)
% hObject    handle to menuRemoveFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

removeFile_ClickedCallback(hObject, eventdata, handles);


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

% --------------------------------------------------------------------
function menuAddFile_Callback(hObject, eventdata, handles)
% hObject    handle to menuAddFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

addFile_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuAddPatient_Callback(hObject, eventdata, handles)
% hObject    handle to menuAddPatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

addPatient_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuExportPatient_Callback(hObject, eventdata, handles)
% hObject    handle to menuExportPatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

exportPatient_ClickedCallback(hObject, eventdata, handles);


% --------------------------------------------------------------------
function menuCloseAllPatients_Callback(hObject, eventdata, handles)
% hObject    handle to menuCloseAllPatients (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

closeAllPatients_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuExportAllPatients_Callback(hObject, eventdata, handles)
% hObject    handle to menuExportAllPatients (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

exportAllPatients_ClickedCallback(hObject, eventdata, handles);


% --------------------------------------------------------------------
function performAnalysis_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to performAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

numRoi = currentFile.numRoi;

if numRoi == 1 || numRoi == 2 %need left and right ROIs, no more, no less
    
    image = currentFile.image;
    dims = size(image);
    
    mask = zeros(dims);
    
    meanRoiX = zeros(numRoi, 1);
    roiMaskVecs = cell(numRoi,1);
    
    for i=1:numRoi
        
        %calculate spline
        
        roiPoints = currentFile.roiPoints{i};
        
        meanRoiX(i) = mean(roiPoints(:,1));
        
        roiPoints = [roiPoints; roiPoints(1,:)]; %duplicate last point
        
        x = roiPoints(:,1)';
        y = roiPoints(:,2)';
        
        spline = cscvn([x;y]); %spline store as a function
        
        %plot spline
        splinePoints = fnplt(spline)';
        
        roiMask = fastMask(splinePoints, dims);
        
        roiMaskVecs{i} = roiMask;
        
        mask = mask | roiMask;
        
    end
    
    [~,I] = sort(meanRoiX);
    
    leftRoiIndex = I(1);
    rightRoiIndex = I(numRoi);
    
    %get data for kmeans
    
    maskVec = reshape(mask, dims(1)*dims(2), 1);
    imageVec = reshape(image, dims(1)*dims(2), 1);
    
    maskIndices = (maskVec == 1); %returns all indices in the mask where the value is 1
    maskedImageVec = imageVec(maskIndices);
    
    numClusters = 3;
    
    [sortedClusterIndices] = performClusterAnalysis2(maskedImageVec);%performClusterAnalysis3(maskVec, imageVec, numClusters);%performClusterAnalysis(maskedImageVec, numClusters); % low to high intensities
    
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
    
    normedImage = image/max(max(image));
    
    resultRedChan = zeros(dims(1),dims(2));
    resultGreenChan = zeros(dims(1),dims(2));
    resultBlueChan = zeros(dims(1),dims(2));
    
    for i=1:dims(1)
        for j=1:dims(2)
            if clusterHighlighting{1}(i,j)
                resultRedChan(i,j) = 1;
            else
                resultRedChan(i,j) = normedImage(i,j);
            end
            
            if clusterHighlighting{2}(i,j)
                resultGreenChan(i,j) = 1;
            else
                resultGreenChan(i,j) = normedImage(i,j);
            end
            
            if clusterHighlighting{3}(i,j)
                resultBlueChan(i,j) = 1;
            else
                resultBlueChan(i,j) = normedImage(i,j);
            end
            
        end
    end
    
    resultImage = zeros(dims(1), dims(2), 3);
    
    resultImage(:,:,1) = resultRedChan;
    resultImage(:,:,2) = resultGreenChan;
    resultImage(:,:,3) = resultBlueChan;
    
    currentFile.highlightedImage = resultImage;
    currentFile.highlightingOn = true;
    
    pixelCounts = cell(numRoi,1);
    
    % get pixel counts
    for i=1:numRoi
        pixelCount = zeros(numClusters, 1);
        
        for j=1:numClusters
            pixelCount(j) = sum(clusterMaskVecs{j}(roiMaskVecs{i} == 1));
        end
        
        pixelCounts{i} = pixelCount;
    end
    
    leftPixelCount = pixelCounts{leftRoiIndex};
    rightPixelCount = pixelCounts{rightRoiIndex};
    
    if numRoi == 1 %get rid of right pixel counts
        rightPixelCount = zeros(numClusters, 1);
    end
    
    finalPixelCounts = PixelCounts(...
        leftPixelCount(1), leftPixelCount(2), leftPixelCount(3),...
        rightPixelCount(1), rightPixelCount(2), rightPixelCount(3));
    
    currentFile.pixelCounts = finalPixelCounts;
        
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
function toggleHighlighting_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toggleHighlighting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

currentFile.highlightingOn = ~currentFile.highlightingOn;

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
function menuDeleteRoi_Callback(hObject, eventdata, handles)
% hObject    handle to menuDeleteRoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

deleteRoi_ClickedCallback(hObject, eventdata, handles);

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


% --------------------------------------------------------------------
function menuImportPatientDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to menuImportPatientDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

importPatientDirectory_ClickedCallback(hObject, eventdata, handles);


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
function menuPatientManagement_Callback(hObject, eventdata, handles)
% hObject    handle to menuPatientManagement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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
    case 'unitRelative'
        currentFile.displayUnits = 'relative';
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


% --- Executes on mouse press over axes background.
function imageAxes_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to imageAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
