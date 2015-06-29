classdef DisplayRoi
    %DisplayRoi used to store the handles for the points and lines to
    %display a single ROI
    
    properties
        splineHandle = gobjects(0);
        impointHandles = impoint.empty;
    end
    
    methods
        %% splineEmpty %%
        function bool = splineEmpty(displayRoi)
            bool = isEmpty(displayRoi.splineHandle);
        end
        
        %% pointsEmpty %%
        function bool = pointsEmpty(displayRoi)
            bool = isEmpty(displayRoi.impointHandles);
        end
        
    end
    
end

