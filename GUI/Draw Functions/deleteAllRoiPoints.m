function [ handles ] = deleteAllRoiPoints( handles )
%[ handles ] = deleteAllRoiPoints( handles )
% deletes all drawn roi points

allRoiPointHandles = handles.roiPointHandles;

for i=1:length(allRoiPointHandles)
    handles = deleteRoiPoints(handles, 1); %keep deleting first in list
end


end

