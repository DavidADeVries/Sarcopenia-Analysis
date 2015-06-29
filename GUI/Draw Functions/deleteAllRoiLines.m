function [ handles ] = deleteAllRoiLines( handles )
%[ handles ] = deleteAllRoiLines( handles )
% deletes all drawn roi lines

splineHandles = handles.roiSplineHandles;

for i=1:length(splineHandles)
    handles = deleteRoiLine(handles, 1); %keep deleting first in list
end


end

