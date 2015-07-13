classdef Constants
    %Constants stores the constants
    
    properties (Constant = true)
        % for dev
        GIANT_PATH = '/data/projects/General Image Analysis Toolkit/metadata/';
        
        % for released
        %GIANT_PATH = '/data/projects/General Image Analysis Toolkit/Current Release/';
        
        
        
        
        SAVED_PATIENTS_DIRECTORY = '/data/projects/Sarcopenia/Sarcopenia Study/Saved Patient Analysis/'; %make sure it's absolute and ends with '/'
        RAW_DATA_DIRECTORY = '/data/projects/Sarcopenia/Sarcopenia Study/Raw Data/';
        CSV_EXPORT_DIRECTORY = '/data/projects/Sarcopenia/Sarcopenia Study/Exported Spreadsheets/';        
        
        SAVE_TITLE_SUGGESTION = 'Sarcopenia Analysis';
        
        TEXT_LABEL_BORDER_WIDTH = 1;
        
        ROI_POINT_RESOLUTION = 15; %the user does a free hand draw to define the ROI, so only some points are kept to construct the splines off of
        ROI_POINT_COLOUR = 'y'; %yellow
        
        ROI_LINE_WIDTH = 3;
        ROI_LINE_COLOUR = [0, 0.5, 1]; % blue
        
        QUICK_MEASURE_LINE_COLOUR = [255, 153, 51] / 255; %brownish-orange
        QUICK_MEASURE_LABEL_BORDER_COLOUR = [0 0 0] / 255; %black
        QUICK_MEASURE_LABEL_TEXT_COLOUR = [255, 153, 51] / 255; %brownish-orange
        QUICK_MEASURE_LABEL_FONT_SIZE = 13;
    end
    
    methods
    end
    
end

