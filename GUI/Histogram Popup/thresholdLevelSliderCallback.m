function [ ] = thresholdLevelSliderCallback( hObject, event )
%UNTITLED Summary of this function goes here
% is triggered whenever the value of slider is changed
handles = guidata(hObject);

tempFile = handles.tempFile;

mainHandles = guidata(handles.mainGuiHObject);



threshold = get(event, 'NewValue');
threshold = round(threshold); % go to nearest whole value


currentThresholds = tempFile.thresholds;
currentThresholds.muscleLower = threshold;

set(handles.thresholdLevelSlider, 'Value', threshold);
set(handles.thresholdLevelText, 'String', num2str(threshold));

handles.lineHandles = plotThresholds(handles.histogramAxes, currentThresholds, handles.lineHandles);

tempFile = tempFile.setThresholds(mainHandles.currentImage, currentThresholds);

handles.tempFile = tempFile;


mainHandles = drawImage(tempFile, mainHandles);
updateTissueAnalysisTable(tempFile, mainHandles); 



guidata(hObject, handles);

guidata(handles.mainGuiHObject, mainHandles);


end

