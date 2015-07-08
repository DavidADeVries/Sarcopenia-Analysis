function [ handles ] = emptyDisplayHandles( handles )
%[ handles ] = emptyDisplayHandles( handles )
% sets all display object handles to be empty
% useful when an imshow clears everything, but you still have the handles
% for objects lying around

handles.imageHandle = gobjects(0);
handles.roiSplineHandles = cell(0);
handles.roiPointHandles = cell(0);
handles.quickMeasureLineHandle = imline.empty;
handles.quickMeasureTextLabel = TextLabel.empty;

end

