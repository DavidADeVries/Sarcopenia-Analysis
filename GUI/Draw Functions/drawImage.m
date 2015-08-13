function [ handles ] = drawImage( currentFile, handles)
%[ handles ] = drawImage( currentFile, handles)
%draws the actual image itself, no lines or other points are drawn

image = currentFile.getCurrentImage(handles.currentImage); %either highlighted or not

axesHandle = handles.imageAxes;

imageHandle = handles.imageHandle;

if isempty(imageHandle)
    axes(axesHandle);
    
    handles.imageHandle = imshow(image, []);
else
    set(imageHandle, 'CData', image); %clims and dimensions shouldn't really change
end

xLim = currentFile.zoomLims.xLim;
yLim = currentFile.zoomLims.yLim;

%zoom reset; % do this or else zooming out becomes an issue
set(axesHandle, 'XLim', xLim, 'YLim', yLim);


end

