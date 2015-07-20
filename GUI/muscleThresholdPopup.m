function varargout = muscleThresholdPopup(varargin)
% MUSCLETHRESHOLDPOPUP MATLAB code for muscleThresholdPopup.fig
%      MUSCLETHRESHOLDPOPUP by itself, creates a new MUSCLETHRESHOLDPOPUP or raises the
%      existing singleton*.
%
%      H = MUSCLETHRESHOLDPOPUP returns the handle to a new MUSCLETHRESHOLDPOPUP or the handle to
%      the existing singleton*.
%
%      MUSCLETHRESHOLDPOPUP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MUSCLETHRESHOLDPOPUP.M with the given input arguments.
%
%      MUSCLETHRESHOLDPOPUP('Property','Value',...) creates a new MUSCLETHRESHOLDPOPUP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before muscleThresholdPopup_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to muscleThresholdPopup_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help muscleThresholdPopup

% Last Modified by GUIDE v2.5 20-Jul-2015 14:00:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @muscleThresholdPopup_OpeningFcn, ...
                   'gui_OutputFcn',  @muscleThresholdPopup_OutputFcn, ...
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

% --- Executes just before muscleThresholdPopup is made visible.
function muscleThresholdPopup_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to muscleThresholdPopup (see VARARGIN)

% Choose default command line output for muscleThresholdPopup
handles.output = 'Yes';

% Insert custom Title and Text if specified by the user
% Hint: when choosing keywords, be sure they are not easily confused 
% with existing figure properties.  See the output of set(figure) for
% a list of figure properties.

if(nargin > 3)  
    handles.mainGuiHObject = varargin{1};
    
    mainHandles = guidata(varargin{1});
    
    currentFile = getCurrentFile(mainHandles);
    currentImage = mainHandles.currentImage;
    
    if ~isempty(currentFile) && ~isempty(currentImage)
        clusterMap = currentFile.clusterMap;
        
        if ~isempty(clusterMap)
            clusterTags = Constants.CLUSTER_MAP_TAGS;
                       
            muscleMask = (clusterMap == clusterTags.muscle) | (clusterMap == clusterTags.lowIntMuscle);
            muscleIntensities = currentImage(muscleMask);
            
            sliderMin = min(min(muscleIntensities)); 
            sliderMax = max(max(muscleIntensities)) + 1; %in case you want to set it high enough to let nothing through
            
            if isempty(currentFile.muscleLowerThreshold)
                sliderValue = mean([sliderMin, sliderMax]);
            else
                sliderValue = currentFile.muscleLowerThreshold;
            end
            
            sliderStep = 1 / (sliderMax - sliderMin); %sliderStep is percentage
            
            set(handles.thresholdLevelSlider,...
                'Min', sliderMin,...
                'Max', sliderMax,...
                'Value', sliderValue,...
                'SliderStep', [sliderStep, sliderStep]);
            
            set(handles.thresholdLowerBound, 'String', num2str(sliderMin));
            set(handles.thresholdUpperBound, 'String', num2str(sliderMax));
            set(handles.thresholdLevelText, 'String', num2str(sliderValue));
            
            % adds on listener for when the value changes
            addlistener(handles.thresholdLevelSlider,'Value','PreSet',@(~, event)thresholdLevelSliderCallback(hObject, event));
            
            currentFile = currentFile.setMuscleLowerThreshold(currentImage, sliderValue);
            
            mainHandles = drawImage(currentFile, mainHandles);
            
            guidata(handles.mainGuiHObject, mainHandles);
        end
    end
end

% Update handles structure
guidata(hObject, handles);

% Determine the position of the dialog - centered on the callback figure
% if available, else, centered on the screen
FigPos=get(0,'DefaultFigurePosition');
OldUnits = get(hObject, 'Units');
set(hObject, 'Units', 'pixels');
OldPos = get(hObject,'Position');
FigWidth = OldPos(3);
FigHeight = OldPos(4);
if isempty(gcbf)
    ScreenUnits=get(0,'Units');
    set(0,'Units','pixels');
    ScreenSize=get(0,'ScreenSize');
    set(0,'Units',ScreenUnits);

    FigPos(1)=1/2*(ScreenSize(3)-FigWidth);
    FigPos(2)=2/3*(ScreenSize(4)-FigHeight);
else
    GCBFOldUnits = get(gcbf,'Units');
    set(gcbf,'Units','pixels');
    GCBFPos = get(gcbf,'Position');
    set(gcbf,'Units',GCBFOldUnits);
    FigPos(1:2) = [(GCBFPos(1) + GCBFPos(3) / 2) - FigWidth / 2, ...
                   (GCBFPos(2) + GCBFPos(4) / 2) - FigHeight / 2];
end
FigPos(3:4)=[FigWidth FigHeight];
set(hObject, 'Position', FigPos);
set(hObject, 'Units', OldUnits);

% Make the GUI modal
set(handles.thresholdMainPanel,'WindowStyle','modal');
% UIWAIT makes muscleThresholdPopup wait for user response (see UIRESUME)
uiwait(handles.thresholdMainPanel);

% --- Outputs from this function are returned to the command line.
function varargout = muscleThresholdPopup_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% The figure can be deleted now
delete(handles.thresholdMainPanel);

% --- Executes on button press in thresholdAccept.
function thresholdAccept_Callback(hObject, eventdata, handles)
% hObject    handle to thresholdAccept (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = round(get(handles.thresholdLevelSlider, 'Value'));

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.thresholdMainPanel);

% --- Executes on button press in thresholdCancel.
function thresholdCancel_Callback(hObject, eventdata, handles)
% hObject    handle to thresholdCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = [];

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.thresholdMainPanel);


% --- Executes when user attempts to close thresholdMainPanel.
function thresholdMainPanel_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to thresholdMainPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end


% --- Executes on key press over thresholdMainPanel with no controls selected.
function thresholdMainPanel_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to thresholdMainPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check for "enter" or "escape"
if isequal(get(hObject,'CurrentKey'),'escape')
    % User said no by hitting escape
    handles.output = 'No';
    
    % Update handles structure
    guidata(hObject, handles);
    
    uiresume(handles.thresholdMainPanel);
end    
    
if isequal(get(hObject,'CurrentKey'),'return')
    uiresume(handles.thresholdMainPanel);
end    

% --- Executes during object creation, after setting all properties.
function thresholdLevelSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresholdLevelSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
