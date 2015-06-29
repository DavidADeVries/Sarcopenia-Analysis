function [ handles ] = drawImage( currentFile, handles)
%drawImage draws the actual image itself, no lines or other points are
%drawn

image = currentFile.getCurrentImage(); %either highlighted or not

axesHandle = handles.imageAxes;

imageHandle = handles.imageHandle;

if isempty(imageHandle)
    axes(axesHandle);
    handles.imageHandle = imshow(image,[]);
else
    set(imageHandle, 'CData', image); %clims and dimensions shouldn't really change
end

end

