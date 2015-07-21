function varargout = histogramPopup(varargin)
% HISTOGRAMPOPUP MATLAB code for histogramPopup.fig
%      HISTOGRAMPOPUP, by itself, creates a new HISTOGRAMPOPUP or raises the existing
%      singleton*.
%
%      H = HISTOGRAMPOPUP returns the handle to a new HISTOGRAMPOPUP or the handle to
%      the existing singleton*.
%
%      HISTOGRAMPOPUP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HISTOGRAMPOPUP.M with the given input arguments.
%
%      HISTOGRAMPOPUP('Property','Value',...) creates a new HISTOGRAMPOPUP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before histogramPopup_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to histogramPopup_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help histogramPopup

% Last Modified by GUIDE v2.5 21-Jul-2015 11:32:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @histogramPopup_OpeningFcn, ...
                   'gui_OutputFcn',  @histogramPopup_OutputFcn, ...
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


% --- Executes just before histogramPopup is made visible.
function histogramPopup_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to histogramPopup (see VARARGIN)

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
            
            handles.tempFile = currentFile;
            
            currentThresholds = currentFile.thresholds;
                                   
            sliderMin = min(min(currentImage)); 
            sliderMax = currentThresholds.muscleUpper; %in case you want to set it high enough to let nothing through
            
            sliderValue = currentThresholds.muscleLower;
            
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
                        
            mainHandles = drawImage(currentFile, mainHandles);
            
            % histogram
            
            dims = size(currentImage);
            
            roiMasks = currentFile.getRoiMasks(currentImage);
            
            roiMask = zeros(dims);
            
            for i=1:length(roiMasks)
                roiMask = roiMask | roiMasks{i};
            end
            
            roiIntensities = currentImage(roiMask);
            
            imageMin = min(roiIntensities);
            imageMax = max(roiIntensities);
            
            numBins = imageMax - imageMin + 1;
            
            hist(handles.histogramAxes, roiIntensities, numBins);
            
            handles.lineHandles = plotThresholds(handles.histogramAxes, currentThresholds, []); 
            
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
set(handles.histogramMainPanel,'WindowStyle','modal');
% UIWAIT makes muscleThresholdPopup wait for user response (see UIRESUME)
uiwait(handles.histogramMainPanel);


% --- Outputs from this function are returned to the command line.
function varargout = histogramPopup_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% The figure can be deleted now
delete(handles.histogramMainPanel);


% --- Executes on button press in accept.
function accept_Callback(hObject, eventdata, handles)
% hObject    handle to accept (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = handles.tempFile;

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.histogramMainPanel);

% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = [];

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.histogramMainPanel);

% --- Executes during object creation, after setting all properties.
function thresholdLevelSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresholdLevelSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes when user attempts to close histogramMainPanel.
function histogramMainPanel_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to histogramMainPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end


% --- Executes on key press with focus on histogramMainPanel and none of its controls.
function histogramMainPanel_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to histogramMainPanel (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

% Check for "enter" or "escape"
if isequal(get(hObject,'CurrentKey'),'escape')
    % User said no by hitting escape
    handles.output = 'No';
    
    % Update handles structure
    guidata(hObject, handles);
    
    uiresume(handles.histogramMainPanel);
end    
    
if isequal(get(hObject,'CurrentKey'),'return')
    uiresume(handles.histogramMainPanel);
end
