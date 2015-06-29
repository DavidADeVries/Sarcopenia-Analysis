function [ handles ] = deleteRoiLine(handles, roiIndex)
%[ handles ] = deleteRoiLine(handles, roiIndex)
% deletes the spline drawn for the roi index give

splineHandle = handles.roiSplineHandles{roiIndex};

delete(splineHandle);

handles.roiSplineHandles(roiIndex) = []; %deletes

end

