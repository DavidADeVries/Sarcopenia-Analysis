function [ handles ] = drawImage( currentFile, handles, varargin)
%[ handles ] = drawImage( currentFile, handles, saveZoom*)
%draws the actual image itself, no lines or other points are drawn
% saveZoom optional: default is false (only needed when imageHandle is
% empty (aka when image was deleted and now is being redrawn)

image = currentFile.getCurrentImage(handles.currentImage); %either highlighted or not

axesHandle = handles.imageAxes;

imageHandle = handles.imageHandle;

if isempty(imageHandle)
    axes(axesHandle);
    
    saveZoom = false;
    
    if length(varargin) ==1
        saveZoom = varargin{1};
    end
    
    if saveZoom
        xLim = get(axesHandle, 'XLim');
        yLim = get(axesHandle, 'YLim'); 
    end
    
    handles.imageHandle = imshow(image,[]);
    
    if saveZoom
        set(axesHandle, 'XLim', xLim, 'YLim', yLim);
    end
else
    set(imageHandle, 'CData', image); %clims and dimensions shouldn't really change
end

end

