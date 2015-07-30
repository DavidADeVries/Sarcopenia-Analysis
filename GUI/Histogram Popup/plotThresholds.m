function lineHandles = plotThresholds(axes, thresholds, lineHandles)
    yLims = get(axes, 'YLim');
    
    yMin = yLims(1);
    yMax = yLims(2);
    
    for i=1:length(lineHandles)
        delete(lineHandles{i});
    end
    
    hold on;
    
    xLowerMuscle = [thresholds.muscleLower, thresholds.muscleLower];
    xUpperMuscle = [thresholds.muscleUpper, thresholds.muscleUpper];
    xLowerFat = [thresholds.fatLower, thresholds.fatLower];
    xUpperFat = [thresholds.fatUpper, thresholds.fatUpper];
    
    y = [yMin, yMax];
    
    lineHandles{1} = plot(axes, xLowerMuscle, y, 'r');
    lineHandles{2} = plot(axes, xUpperMuscle, y, 'r');
    lineHandles{3} = plot(axes, xLowerFat, y, 'g');
    lineHandles{4} = plot(axes, xUpperFat, y, 'g');    
    
    hold off;
end

