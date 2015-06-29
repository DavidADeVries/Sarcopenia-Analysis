function [ ] = updateTissueAnalysisTable(currentFile, handles)
%[ ], 'String', updateTissueAnalysisTable(handles)
% using the PixelCounts class object provided, the table with all the stats
% regarding the segmentation are updated.
% pixelArea should be in mm^2

if isempty(currentFile) || isempty(currentFile.pixelCounts) % clear it out
    
    set(handles.cellLeftFatCsa, 'String', '');
    set(handles.cellLeftMuscleCsa, 'String', '');
    set(handles.cellLeftLowCsa, 'String', '');
    
    set(handles.cellLeftFatPercent, 'String', '');
    set(handles.cellLeftMusclePercent, 'String', '');
    
    % right ROI stats
    set(handles.cellRightFatCsa, 'String', '');
    set(handles.cellRightMuscleCsa, 'String', '');
    set(handles.cellRightLowCsa, 'String', '');
    
    set(handles.cellRightFatPercent, 'String', '');
    set(handles.cellRightMusclePercent, 'String', '');
    
    % all ROIs stats
    set(handles.cellTotalFatCsa, 'String', '');
    set(handles.cellTotalMuscleCsa, 'String', '');
    set(handles.cellTotalLowCsa, 'String', '');
    
    set(handles.cellTotalFatPercent, 'String', '');
    set(handles.cellTotalMusclePercent, 'String', '');
    
else % write stats from pixelCounts
    
    pixelArea = currentFile.getPixelArea();
    
    [csas, percentages] = currentFile.pixelCounts.getStats(pixelArea);
    
    % left ROI stats
    set(handles.cellLeftFatCsa, 'String', csas.left.high);
    set(handles.cellLeftMuscleCsa, 'String', csas.left.mid);
    set(handles.cellLeftLowCsa, 'String', csas.left.low);
    
    set(handles.cellLeftFatPercent, 'String', percentages.left.high);
    set(handles.cellLeftMusclePercent, 'String', percentages.left.mid);
    
    % right ROI stats
    set(handles.cellRightFatCsa, 'String', csas.right.high);
    set(handles.cellRightMuscleCsa, 'String', csas.right.mid);
    set(handles.cellRightLowCsa, 'String', csas.right.low);
    
    set(handles.cellRightFatPercent, 'String', percentages.right.high);
    set(handles.cellRightMusclePercent, 'String', percentages.right.mid);
    
    % all ROIs stats
    set(handles.cellTotalFatCsa, 'String', csas.total.high);
    set(handles.cellTotalMuscleCsa, 'String', csas.total.mid);
    set(handles.cellTotalLowCsa, 'String', csas.total.low);
    
    set(handles.cellTotalFatPercent, 'String', percentages.total.high);
    set(handles.cellTotalMusclePercent, 'String', percentages.total.mid);
    
end


end

