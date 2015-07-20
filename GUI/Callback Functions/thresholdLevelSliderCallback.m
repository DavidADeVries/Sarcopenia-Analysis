function [ ] = thresholdLevelSliderCallback( hObject, event )
%UNTITLED Summary of this function goes here
% is triggered whenever the value of slider is changed

handles = guidata(hObject);

threshold = get(event, 'NewValue');

threshold = round(threshold); % go to nearest whole value

set(handles.thresholdLevelSlider, 'Value', threshold);

set(handles.thresholdLevelText, 'String', num2str(threshold));

mainHandles = guidata(handles.mainGuiHObject);

currentFile = getCurrentFile(mainHandles);

currentFile = currentFile.setMuscleLowerThreshold(mainHandles.currentImage, threshold);

mainHandles = drawImage(currentFile, mainHandles);

updateTissueAnalysisTable(currentFile, mainHandles); 

guidata(handles.mainGuiHObject, mainHandles);


end

