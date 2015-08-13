function [ header ] = getHeader()
% [ header ] = getHeader()
% returns the header for the .csv export file as a cell array
% required by GIANT

% have two rows of headers, to help divide up
topHeader = { 'Patient Id',...
    'Patient Sex',...
    'Patient DOB (MMM-YY)',...
    'Sequence Number',...
    'Study Date (DD-MMM-YY)',...
    'Age at Acquisition (Months)',...
    'Modality',...
    'Study Name',...
    'Series Name',...
    'File Name',...
    'Left ROI','','','','',...
    'Right ROI','','','','',...
    'Total (Both ROIs)','','','',''};

roiSubHeader = {...
    'CSA (mm^2)',...
    'Fat CSA (mm^2)',...
    'Muscle CSA (mm^2)',...
    'Fat %% (%%)',...
    'Muscle %% (%%)'};

subHeader = [{ '','','','','','','','','',''}, roiSubHeader, roiSubHeader, roiSubHeader];

header = [topHeader; subHeader];

end

