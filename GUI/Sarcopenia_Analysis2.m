function varargout = Sarcopenia_Analysis2(varargin)

% add needed librarys

%addpath('../Image Processing');
%addpath('../CircStat2012a');
%addpath('../arrow');
%addpath('/data/projects/GJtube/metadata/MATLAB Image Functions');
%addpath('/data/projects/GJtube/metadata/Peter Kovesi Computer Vision Libraries/Feature Detection');
addpath(genpath('.')); %add all subfolders in the current directory

rmpath('./Old Stuff [Delete]'); %ignore old files

% SARCOPENIA_ANALYSIS2 MATLAB code for Sarcopenia_Analysis2.fig
%      SARCOPENIA_ANALYSIS2, by itself, creates a new SARCOPENIA_ANALYSIS2 or raises the existing
%      singleton*.
%
%      H = SARCOPENIA_ANALYSIS2 returns the handle to a new SARCOPENIA_ANALYSIS2 or the handle to
%      the existing singleton*.
%
%      SARCOPENIA_ANALYSIS2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SARCOPENIA_ANALYSIS2.M with the given input arguments.
%
%      SARCOPENIA_ANALYSIS2('Property','Value',...) creates a new SARCOPENIA_ANALYSIS2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Sarcopenia_Analysis2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Sarcopenia_Analysis2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Sarcopenia_Analysis2

% Last Modified by GUIDE v2.5 07-Jul-2015 08:56:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Sarcopenia_Analysis2_OpeningFcn, ...
    'gui_OutputFcn',  @Sarcopenia_Analysis2_OutputFcn, ...
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


% --- Executes just before Sarcopenia_Analysis2 is made visible.
function Sarcopenia_Analysis2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Sarcopenia_Analysis2 (see VARARGIN)

% Choose default command line output for Sarcopenia_Analysis2
handles.output = hObject;

handles.numPatients = 0; %records the number of images that are currently open
handles.currentPatientNum = 0; %the current image being displayed
handles.updateUndoCache = false; %tells upclick listener whether or not to save undo data
handles.deleteRoiOn = false; %true if deleting ROIs by selection is active

handles.patients = Patient.empty;

% empty handle structures
handles.imageHandle = gobjects(0);
handles.roiSplineHandles = cell(0);
handles.roiPointHandles = cell(0);
handles.quickMeasureLineHandle = imline.empty;
handles.quickMeasureTextLabel = TextLabel.empty;


%clear axes
set(hObject, 'Pointer', 'arrow');
axes(handles.imageAxes);
imshow([],[]);
cla(handles.imageAxes); % clear axes

updateGui(File.empty, handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Sarcopenia_Analysis2 wait for user response (see UIRESUME)
% uiwait(handles.mainPanel);


% --- Outputs from this function are returned to the command line.
function varargout = Sarcopenia_Analysis2_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function open_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to menuopen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[imageFilename, imagePath, ~] = uigetfile({'*.dcm;*.mat','Valid Files (*.dcm;*.mat)';'*.dcm','DICOM Files (*.dcm)';'*.mat','Patient Analysis Files (*.mat)'},'Select Image',Constants.HOME_DIRECTORY);

if imageFilename ~= 0 %user didn't click cancel!
    len = length(imageFilename);
    fileType = imageFilename(len-2:len);
    
    completeFilepath = strcat(imagePath, imageFilename);
    
    openCancelled = false;
    
    if strcmp(fileType, 'dcm') %dicom file!
        % TODO: validate dicom file??
        
        dicomImage = dicomread(completeFilepath);
        dicomInfo = dicominfo(completeFilepath);
        
        currentFile = File(dicomInfo, dicomImage);
        
        [patientNum, patient] = findPatient(handles.patients, dicomInfo.PatientID);
        
        if isempty(patient)
            handles.numPatients = handles.numPatients + 1;
            handles.currentPatientNum = handles.numPatients;
            patient = Patient(dicomInfo.PatientID);
        else
            handles.currentPatientNum = patientNum;
        end
        
        patient = patient.addFile(currentFile);
        
    else % load previous analysis file .mat
        loadedData = load(completeFilepath);
        
        patient = loadedData.patient;
        
        [patientNum, ~] = findPatient(handles.patients, patient.patientId);
        
        if patientNum == 0 % create new
            handles.numPatients = handles.numPatients + 1;
            handles.currentPatientNum = handles.numPatients;            
        else %overwrite whatever patient with the same id was there before
            openCancelled = overwritePatientDialog(); %confirm with user that they want to overwrite              
        end
        
        if ~openCancelled
            currentFile = patient.getCurrentFile();
        end
    end     
    
    if ~openCancelled
        handles = updatePatient(patient, handles);
        
        updateGui(currentFile, handles);
        
        handles = deleteAll(handles);
        handles = drawAll(currentFile, handles, hObject);        
        
        guidata(hObject, handles);
    end
    
end

% --------------------------------------------------------------------
function addPatient_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to addPatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

folderPath = uigetdir(Constants.HOME_DIRECTORY, 'Select Image');

if folderPath ~= 0 %didn't click cancel
    filesToOpen = getAllDicomFiles(folderPath);
    
    if ~isempty(filesToOpen) %make patient if there is at least one patient
        firstFilePath = char(filesToOpen{1});
        
        dicomInfo = dicominfo(firstFilePath);
        
        [patientNum, ~] = findPatient(handles.patients, dicomInfo.PatientID); %see if the patient already exists
        
        openCancelled = false;
        
        if patientNum ~= 0 %ask user if they want to overwrite whatever patient with the same id was there before
            openCancelled = overwritePatientDialog(); %confirm with user that they want to overwrite
            
            handles.currentPatientNum = patientNum;
        else
            handles.numPatients = handles.numPatients + 1;
            handles.currentPatientNum = handles.numPatients;
        end
        
        if ~openCancelled %is not cancelled, assign new patient
            patient = Patient(dicomInfo.PatientID);
            
            %add all files
            for i=1:length(filesToOpen) %guaranteed by FilesToOpen to be dicom files
                filepath = char(filesToOpen(i));
                dicomInfo = dicominfo(filepath);
                
                if dicomInfo.PatientID == patient.patientId %double check sure patient is the same
                    dicomImage = dicomread(filepath);
                    
                    if (length(size(dicomImage)) == 2) %no multisplice support, sorry
                        file = File(dicomInfo, dicomImage);
                        
                        patient = patient.addFile(file);
                    end
                else
                    waitfor(patientIdConflictDialog(patient.patientId, firstFilePath, dicomInfo.PatientID, filepath));
                end
            end
            
            patient.currentFileNum = 1; %start at the beginning (earliest image)
            patient.changesPending = true;
            
            handles = updatePatient(patient, handles);
            
            currentFile = getCurrentFile(handles);
            
            %update view
            updateGui(currentFile, handles);
            
            handles = deleteAll(handles);
            handles = drawAll(currentFile, handles, hObject);
            
            %push up changes
            
            guidata(hObject, handles);
        end
    end
end

% --------------------------------------------------------------------
function addFile_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to addFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[imageFilename, imagePath, ~] = uigetfile({'*.dcm','DICOM Files (*.dcm)'},'Select Image',Constants.HOME_DIRECTORY);

if imageFilename ~= 0 %user didn't click cancel!
    currentPatient = getCurrentPatient(handles);
    
    completeFilepath = strcat(imagePath, imageFilename);
    dicomInfo = dicominfo(completeFilepath);
    
    if dicomInfo.PatientID == currentPatient.patientId %double check sure patient is the same
        dicomImage = dicomread(completeFilepath);
        
        if (length(size(dicomImage)) == 2) %no multisplice support, sorry
            file = File(dicomInfo, dicomImage);
            
            currentPatient = currentPatient.addFile(file);
        else
            waitfor(msgbox('Multi-slice images are not supported!','Error','error'));
        end
    else
        waitfor(patientIdConflictDialog(currentPatient.patientId, '', dicomInfo.PatientID, completeFilepath));
    end
    
    currentPatient.changesPending = true;
    
    handles = updatePatient(currentPatient, handles);
    
    currentFile = getCurrentFile(handles);
    
    %update view
    updateGui(currentFile, handles);
    
    handles = deleteAll(handles);
    handles = drawAll(currentFile, handles, hObject);
    
    %push up changes
    
    guidata(hObject, handles);    
end

% --------------------------------------------------------------------
function exportAllPatients_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to menuExportPatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

exportPatients(handles.patients);


% --------------------------------------------------------------------
function exportPatient_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to exportPatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

exportPatients(getCurrentPatient(handles));


% --------------------------------------------------------------------
function closeAllPatients_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to closeAllPatients (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

for i=1:handles.numPatients
    patient = handles.patients(i);
    
    closeCancelled = false;
    saveFirst = false;
    
    if patient.changesPending;
        [closeCancelled, saveFirst] = pendingChangesDialog(); %prompts user if they want to save unsaved changes
    end
    
    if closeCancelled
        break;
    elseif saveFirst %user chose to save
        patient.saveToDisk();
    end  
end

if ~closeCancelled
    handles.patients = Patient.empty;
    handles.currentPatientNum = 0;
    handles.numPatients = 0;
    
    currentFile = File.empty;
    
    %GUI updated
    updateGui(currentFile, handles);
    
    %displayed imaged updated
    handles = deleteAll(handles);
    handles = drawAll(currentFile, handles, hObject);
    
    %push up changes
    guidata(hObject, handles);
end

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
    
    updateToggleButtons(getCurrentFile(handles), handles);
    
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

updateToggleButtons(getCurrentFile(handles), handles);

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

updateToggleButtons(getCurrentFile(handles), handles);
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

updateToggleButtons(getCurrentFile(handles), handles);

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

updateToggleButtons(getCurrentFile(handles), handles);
updateUnitPanel(currentFile, handles);

% push up the changes
guidata(hObject, handles);


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

udpateGui(currentFile, handles);

% push up the changes
guidata(hObject, handles);

% --------------------------------------------------------------------
function earlierImage_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to earlierImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentPatient = getCurrentPatient(handles);

newFileNum = currentPatient.currentFileNum - 1;

if newFileNum < 1
    newFileNum = 1;
end

currentPatient.currentFileNum = newFileNum;
currentPatient.changesPending = true;

handles = updatePatient(currentPatient, handles);

currentFile = getCurrentFile(handles);

%update GUI
updateGui(currentFile, handles);

%draw new image
handles = deleteAll(handles);
handles = drawAll(currentFile, handles, hObject);

%push up changes
guidata(hObject, handles);


% --------------------------------------------------------------------
function laterImage_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to laterImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentPatient = getCurrentPatient(handles);

newFileNum = currentPatient.currentFileNum + 1;

numFiles = currentPatient.getNumFiles();

if newFileNum > numFiles
    newFileNum = numFiles;
end

currentPatient.currentFileNum = newFileNum;
currentPatient.changesPending = true;

handles = updatePatient(currentPatient, handles);

currentFile = getCurrentFile(handles);

%update GUI
updateGui(currentFile, handles);

%draw new image
handles = deleteAll(handles);
handles = drawAll(currentFile, handles, hObject);

%push up changes
guidata(hObject, handles);



% --------------------------------------------------------------------
function earliestImage_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to earliestImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentPatient = getCurrentPatient(handles);

newFileNum = 1;

currentPatient.currentFileNum = newFileNum;
currentPatient.changesPending = true;

handles = updatePatient(currentPatient, handles);

currentFile = getCurrentFile(handles);

%update GUI
updateGui(currentFile, handles);

%draw new image
handles = deleteAll(handles);
handles = drawAll(currentFile, handles, hObject);

%push up changes
guidata(hObject, handles);

% --------------------------------------------------------------------
function latestImage_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to latestImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentPatient = getCurrentPatient(handles);

newFileNum = currentPatient.getNumFiles();

currentPatient.currentFileNum = newFileNum;
currentPatient.changesPending = true;

handles = updatePatient(currentPatient, handles);

currentFile = getCurrentFile(handles);

%update GUI
updateGui(currentFile, handles);

%draw new image
handles = deleteAll(handles);
handles = drawAll(currentFile, handles, hObject);

%push up changes
guidata(hObject, handles);

% --- Executes on selection change in patientSelector.
function patientSelector_Callback(hObject, eventdata, handles)
% hObject    handle to patientSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns patientSelector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from patientSelector

handles.currentPatientNum = get(hObject,'Value');

currentFile = getCurrentFile(handles);

%update GUI
updateGui(currentFile, handles);

%draw new image
handles = deleteAll(handles);
handles = drawAll(currentFile, handles, hObject);

%push up changes
guidata(hObject, handles);



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

currentPatient = getCurrentPatient(handles);

currentPatient = currentPatient.saveToDisk();

handles = updatePatient(currentPatient, handles);

updateToggleButtons(currentPatient.getCurrentFile, handles);

guidata(hObject, handles);


% --------------------------------------------------------------------
function saveAll_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to saveAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

for i=1:handles.numPatients
    patient = handles.patients(i).saveToDisk();
        
    handles = updatePatient(patient, handles, i);    
end

updateToggleButtons(getCurrentFile(handles), handles);

guidata(hObject, handles);

% --------------------------------------------------------------------
function closePatient_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to closeAllPatients (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentPatient = getCurrentPatient(handles);

closeCancelled = false;
saveFirst = false;

if currentPatient.changesPending;
    [closeCancelled, saveFirst] = pendingChangesDialog(); %prompts user if they want to save unsaved changes
end

if ~closeCancelled
    if saveFirst %user chose to save
        currentPatient.saveToDisk();
    end
    
    handles = removeCurrentPatient(handles); %patient removed from patient list
    
    currentFile = getCurrentFile(handles);
    
    %GUI updated
    updateGui(currentFile, handles);
    
    %displayed imaged updated
    handles = deleteAll(handles);
    handles = drawAll(currentFile, handles, hObject);
    
    %push up changes
    guidata(hObject, handles);  
end

    
    


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
function menuSavePatientAs_Callback(hObject, eventdata, handles)
% hObject    handle to menuSavePatientAs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentPatient = getCurrentPatient(handles);

currentPatient.savePath = ''; %clear it so that it will be redefined (save as)

currentPatient = currentPatient.saveToDisk();

handles = updatePatient(currentPatient, handles);

updateToggleButtons(currentPatient.getCurrentFile(), handles);

guidata(hObject, handles);

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
function removeFile_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to removeFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cancelled = confirmRemoveFileDialog();

if ~cancelled    
    currentPatient = getCurrentPatient(handles);
    
    currentPatient = currentPatient.removeCurrentFile();    
    currentPatient.changesPending = true;
    
    handles = updatePatient(currentPatient, handles);
    
    currentFile = currentPatient.getCurrentFile();
    
    %GUI updated
    updateGui(currentFile, handles);
    
    %displayed imaged updated
    handles = deleteAll(handles);
    handles = drawAll(currentFile, handles, hObject);
    
    %push up changes
    guidata(hObject, handles);  
end

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

closeAllPatients_ClickedCallback(hObject, eventdata, handles)

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
    
    updateToggleButtons(currentFile, handles);
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

updateToggleButtons(getCurrentFile(handles), handles);

% push up the changes
guidata(hObject, handles);



% --------------------------------------------------------------------
function addSliceSeries_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to addSliceSeries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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
updateToggleButtons(getCurrentFile(handles), handles);

% push up the changes
guidata(hObject, handles);



% --------------------------------------------------------------------
function menuDeleteRoi_Callback(hObject, eventdata, handles)
% hObject    handle to menuDeleteRoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

deleteRoi_ClickedCallback(hObject, eventdata, handles);


% --- Executes on selection change in studySelector.
function studySelector_Callback(hObject, eventdata, handles)
% hObject    handle to studySelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns studySelector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from studySelector


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
