function [ handles ] = deleteAll( handles )
%[ handles ] = deleteAll( handles )
% deletes literally all drawn, plotted objects and images as well. To be
% used usually before a drawAll

handles = deleteImage(handles);
handles = deleteAllRoiLines(handles);
handles = deleteAllRoiPoints(handles);
handles = deleteQuickMeasure(handles);


end

