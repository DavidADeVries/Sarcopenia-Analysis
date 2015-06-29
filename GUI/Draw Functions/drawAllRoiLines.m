function handles = drawAllRoiLines(currentFile, handles, toggled)
%handles = drawAllRoiLines(currentFile, handles, toggled)
% draws all the roi splines for the current file

for i=1:currentFile.numRoi
    handles = drawRoiLine(currentFile, handles, toggled, i);
end


end

