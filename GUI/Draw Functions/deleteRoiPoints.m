function [ handles ] = deleteRoiPoints(handles, roiIndex)
%[ handles ] = deleteRoiPoints(handles, roiIndex)
% deletes the points  drawn for the roi index. Automatically sets
% their handles to be empty

oneRoiPointHandles = handles.roiPointHandles{roiIndex};

for i=1:length(oneRoiPointHandles)
    delete(oneRoiPointHandles(i));
end

handles.roiPointHandles(roiIndex) = []; %deletes

end

