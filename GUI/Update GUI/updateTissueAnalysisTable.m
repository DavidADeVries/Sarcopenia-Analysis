function [ ] = updateTissueAnalysisTable(currentFile, handles)
%[ ], 'String', updateTissueAnalysisTable(handles)
% using the PixelCounts class object provided, the table with all the stats
% regarding the segmentation are updated.
% pixelArea should be in mm^2

if isempty(currentFile) || isempty(currentFile.clusterMap) % clear it out
    
    set(handles.cellLeftCsa, 'String', '');
    set(handles.cellLeftFatCsa, 'String', '');
    set(handles.cellLeftMuscleCsa, 'String', '');
    
    set(handles.cellLeftFatPercent, 'String', '');
    set(handles.cellLeftMusclePercent, 'String', '');
    
    % right ROI stats
    set(handles.cellRightCsa, 'String', '');
    set(handles.cellRightFatCsa, 'String', '');
    set(handles.cellRightMuscleCsa, 'String', '');
    
    set(handles.cellRightFatPercent, 'String', '');
    set(handles.cellRightMusclePercent, 'String', '');
    
    % all ROIs stats
    set(handles.cellTotalCsa, 'String', '');
    set(handles.cellTotalFatCsa, 'String', '');
    set(handles.cellTotalMuscleCsa, 'String', '');
    
    set(handles.cellTotalFatPercent, 'String', '');
    set(handles.cellTotalMusclePercent, 'String', '');
    
else % write stats from pixelCounts
    [csas, percentages] = currentFile.getStats(handles.currentImage);
    
    % left ROI stats
    
    leftCsa = csas.left.all;
    
    set(handles.cellLeftCsa, 'String', sprintf('%6.1f', leftCsa));
    set(handles.cellLeftFatCsa, 'String', sprintf('%6.1f', csas.left.fat));
    set(handles.cellLeftMuscleCsa, 'String', sprintf('%6.1f', csas.left.muscle));
    
    set(handles.cellLeftFatPercent, 'String', sprintf('%6.1f', percentages.left.fat));
    set(handles.cellLeftMusclePercent, 'String', sprintf('%6.1f', percentages.left.muscle));
    
    % right ROI stats
    
    rightCsa = csas.right.all;
    
    set(handles.cellRightCsa, 'String', sprintf('%6.1f', rightCsa));
    set(handles.cellRightFatCsa, 'String', sprintf('%6.1f', csas.right.fat));
    set(handles.cellRightMuscleCsa, 'String', sprintf('%6.1f', csas.right.muscle));
    
    set(handles.cellRightFatPercent, 'String', sprintf('%6.1f', percentages.right.fat));
    set(handles.cellRightMusclePercent, 'String', sprintf('%6.1f', percentages.right.muscle));
    
    % all ROIs stats
    
    totalCsa = csas.total.all;
    
    set(handles.cellTotalCsa, 'String', sprintf('%6.1f', totalCsa));
    set(handles.cellTotalFatCsa, 'String', sprintf('%6.1f', csas.total.fat));
    set(handles.cellTotalMuscleCsa, 'String', sprintf('%6.1f', csas.total.muscle));
    
    set(handles.cellTotalFatPercent, 'String', sprintf('%6.1f', percentages.total.fat));
    set(handles.cellTotalMusclePercent, 'String', sprintf('%6.1f', percentages.total.muscle));
    
end


end

