function [ ] = exportToCsv(patients, exportPath, overwrite)
%exportToCsv exports the list of patients to the given .csv path.
%'overwrite' specifies whether to overwrite the file completely, or whether
%to append. Note that when appending, only the patients in the file that
%are NOT in the list of patients are saved. If a patient in is the file and
%in the list, the one in the list takes precedent and COMPLETELY overwrites
%the existing patient data

newline = '\n';
delim = ',';

linesToKeep = cell(0);
    
if ~overwrite
    [fileId, err] = fopen(exportPath, 'r');
    
    if isempty(err)        
        fgets(fileId); %ignore header 1
        fgets(fileId); %ignore header 2
        line = fgets(fileId);
        
        ignoreTillNextId = false;
        
        i = 1;
        
        while(ischar(line))
            line = strrep(line, [delim, delim], [delim, ' ', delim]); %makes sure empty cells aren't swept aside
            split = strsplit(line, ',');
            patientId = char(split(1));
            
            if ignoreTillNextId && ~isempty(patientId)
                ignoreTillNextId = false;
            end
            
            if ~ignoreTillNextId && isPatientIdPresent(patientId, patients) %need to be removed, do not save lines
                ignoreTillNextId = true;
            end
            
            if ~ignoreTillNextId   
                linesToKeep{i} = struct(...
                    'patientId', char(split(1)),...
                    'patientSex', char(split(2)),...
                    'patientDob', strrep(char(split(3)), ' ', ''),... %if it was empty, it got set to ' ', so now put it back
                    'sequenceNumber', str2double(char(split(4))),...
                    'studyDate', char(split(5)),...
                    'modality', char(split(7)),... % split(6) skipped; age formula (must be updated to have proper cell references)
                    'studyName', char(split(8)),...
                    'seriesName', char(split(9)),...
                    'fileName', char(split(10)),...
                    'leftFatCsa', str2double(char(split(11))),...
                    'leftMuscleCsa', str2double(char(split(12))),...
                    'leftLowCsa', str2double(char(split(13))),...
                    'rightFatCsa', str2double(char(split(17))),... %skip left ROI percent formulas
                    'rightMuscleCsa', str2double(char(split(18))),...
                    'rightLowCsa', str2double(char(split(19)))); % everything from the total columns is formulas
                
                i = i + 1;
            end
            
            line = fgets(fileId);
        end
        
        fclose(fileId);
    else
        warning(err);
    end
end
    
[fileId, err] = fopen(exportPath, 'w');

if isempty(err) %write file anew
    %write column headers
    
    % have two rows of headers, to help divide up
    topHeaders = { 'Patient Id',...
        'Patient Sex',...
        'Patient DOB (MMM-YY)',...
        'Sequence Number',...
        'Study Date (DD-MMM-YY)',...
        'Age at Acquisition (Months)',...
        'Modality',...
        'Study Name',...
        'Series Name',...
        'File Name',...
        'Left ROI','','','','','',...
        'Right ROI','','','','','',...
        'Total (Both ROIs)','','','','',''};
        
    roiSubHeaders = {...
        'Fat CSA (mm^2)',...
        'Muscle CSA (mm^2)',...
        'Low Intensity CSA (mm^2)',...
        'Fat %% (%%)',...
        'Muscle %% (%%)',...
        'Low Intensity %% (%%)'};
    
    subHeaders = [{ '','','','','','','','','',''}, roiSubHeaders, roiSubHeaders, roiSubHeaders];
    
    numHeaders = length(topHeaders);
    
    for i=1:numHeaders
        fprintf(fileId, topHeaders{i});
        
        if i ~= numHeaders
            fprintf(fileId, ',');
        end
    end
    
    fprintf(fileId, newline);
    
    for i=1:numHeaders
        fprintf(fileId, subHeaders{i});
        
        if i ~= numHeaders
            fprintf(fileId, ',');
        end
    end
    
    fprintf(fileId, newline);
    
    lineNumber = 3; %lines 1 and 2 are the headers
    
    %write data from previous file if choosen to not overwrite
    
    for i=1:length(linesToKeep)
        printToFile(fileId, lineNumber, linesToKeep{i}, newline, delim);
        lineNumber = lineNumber + 1;
    end
    
    %write new data from patient list
    
    %loop through patients
    for i=1:length(patients)
        patient = patients(i);
        
        sequenceNumber = 1; %reset sequence number counter for each patient
        
        studies = patient.studies;
        
        %loop through studies
        for j=1:length(studies)
            study = studies(j);
            
            series = study.series;
            
            %loop through series
            for k=1:length(series)
                singularSeries = series(k);
                
                files = singularSeries.files; 
                
                %loop through files
                for l=1:length(files)
                    file = files(l);
                    
                    % these fields must be populated for analysis to be considered complete
                    if ~isempty(file.pixelCounts) 
                        pixelArea = file.getPixelArea();
                        [csas, ~] = file.pixelCounts.getStats(pixelArea);
                        
                        values = struct(...
                            'patientId', patient.patientId,...
                            'patientSex', file.dicomInfo.PatientSex,...
                            'patientDob', '',...
                            'sequenceNumber', sequenceNumber,...
                            'studyDate', file.date.stringForCsv(),...
                            'modality', file.dicomInfo.Modality,...
                            'studyName', study.name,...
                            'seriesName', singularSeries.name,...
                            'fileName', file.name,...
                            'leftFatCsa', csas.left.high,...
                            'leftMuscleCsa', csas.left.mid,...
                            'leftLowCsa', csas.left.low,...
                            'rightFatCsa', csas.right.high,...
                            'rightMuscleCsa', csas.right.mid,...
                            'rightLowCsa', csas.right.low);
                        
                        printToFile(fileId, lineNumber, values, newline, delim);
                        
                        lineNumber = lineNumber + 1;
                        sequenceNumber = sequenceNumber + 1;
                    end
                end
            end
        end
    end
    
    fclose(fileId); % close file after done writing
    
else
    warning(err);
end

end

function [bool] = isPatientIdPresent(patientId, patients)
    bool = false;
    
    i=1;
    
    while (i <= length(patients) && ~bool)
        if strcmp(patients(i).patientId, patientId)
            bool = true;
        end
        
        i = i+1;
    end
end

function [] = printToFile(fileId, lineNumber, values, newline, delim)
    rowChar = num2str(lineNumber);

    dobCell = ['C', rowChar];
    studyDateCell = ['E', rowChar];

    ageFormula = ['=(MONTH(', studyDateCell ,') - MONTH(', dobCell, '))+(YEAR(', studyDateCell, ') - YEAR(', dobCell, '))*12'];
    
    leftFatPercentFormula = ['=100*K', rowChar, '/SUM(K' rowChar, ':M', rowChar, ')'];
    leftMusclePercentFormula = ['=100*L', rowChar, '/SUM(K' rowChar, ':M', rowChar, ')'];
    leftLowPercentFormula = ['=100*M', rowChar, '/SUM(K' rowChar, ':M', rowChar, ')'];
    
    rightFatPercentFormula = ['=100*Q', rowChar, '/SUM(Q' rowChar, ':S', rowChar, ')'];
    rightMusclePercentFormula = ['=100*R', rowChar, '/SUM(Q' rowChar, ':S', rowChar, ')'];
    rightLowPercentFormula = ['=100*S', rowChar, '/SUM(Q' rowChar, ':S', rowChar, ')'];
    
    totalFatCsaFormula = ['=K', rowChar, '+Q', rowChar];
    totalMuscleCsaFormula = ['=L', rowChar, '+R', rowChar];
    totalLowCsaFormula = ['=M', rowChar, '+S', rowChar];
    
    totalFatPercentFormula = ['=100*W', rowChar, '/SUM(W' rowChar, ':Y', rowChar, ')'];
    totalMusclePercentFormula = ['=100*X', rowChar, '/SUM(W' rowChar, ':Y', rowChar, ')'];
    totalLowPercentFormula = ['=100*Y', rowChar, '/SUM(W' rowChar, ':Y', rowChar, ')'];
    
    format = struct(...
        'patientId', '%s',...
        'patientSex', '%s',...
        'patientDob', '%s',...
        'sequenceNumber', '%d',...
        'studyDate', '%s',...
        'ageInMonths', '%s',... %since formula is string
        'modality', '%s',...
        'studyName', '%s',...
        'seriesName', '%s',...
        'fileName', '%s',...
        'leftFatCsa', '%6.1f',...
        'leftMuscleCsa', '%6.1f',...
        'leftLowCsa', '%6.1f',...
        'leftFatPercent', '%s',... %since formula is string
        'leftMusclePercent', '%s',... %since formula is string
        'leftLowPercent', '%s',... %since formula is string
        'rightFatCsa', '%6.1f',...
        'rightMuscleCsa', '%6.1f',...
        'rightLowCsa', '%6.1f',...
        'rightFatPercent', '%s',... %since formula is string
        'rightMusclePercent', '%s',... %since formula is string
        'rightLowPercent', '%s',... %since formula is string
        'totalFatCsa', '%s',... %since formula is string
        'totalMuscleCsa', '%s',... %since formula is string
        'totalLowCsa', '%s',... %since formula is string
        'totalFatPercent', '%s',... %since formula is string
        'totalMusclePercent', '%s',... %since formula is string
        'totalLowPercent', '%s'); %since formula is string
    
    line = strcat(...
        sprintf(format.patientId, values.patientId), delim,...
        sprintf(format.patientSex, values.patientSex), delim,...
        sprintf(format.patientDob, values.patientDob), delim,...
        sprintf(format.sequenceNumber, values.sequenceNumber), delim,...
        sprintf(format.studyDate, values.studyDate), delim,...
        sprintf(format.ageInMonths, ageFormula), delim,...
        sprintf(format.modality, values.modality), delim,...
        sprintf(format.studyName, values.studyName), delim,...
        sprintf(format.seriesName, values.seriesName), delim,...        
        sprintf(format.fileName, values.fileName), delim,...
        sprintf(format.leftFatCsa, values.leftFatCsa), delim,...        
        sprintf(format.leftMuscleCsa, values.leftMuscleCsa), delim,...            
        sprintf(format.leftLowCsa, values.leftLowCsa), delim,...        
        sprintf(format.leftFatPercent, leftFatPercentFormula), delim,...        
        sprintf(format.leftMusclePercent, leftMusclePercentFormula), delim,...            
        sprintf(format.leftLowPercent, leftLowPercentFormula), delim,...
        sprintf(format.rightFatCsa, values.rightFatCsa), delim,...        
        sprintf(format.rightMuscleCsa, values.rightMuscleCsa), delim,...            
        sprintf(format.rightLowCsa, values.rightLowCsa), delim,...        
        sprintf(format.rightFatPercent, rightFatPercentFormula), delim,...        
        sprintf(format.rightMusclePercent, rightMusclePercentFormula), delim,...            
        sprintf(format.rightLowPercent, rightLowPercentFormula), delim,...
        sprintf(format.totalFatCsa, totalFatCsaFormula), delim,...        
        sprintf(format.totalMuscleCsa, totalMuscleCsaFormula), delim,...            
        sprintf(format.totalLowCsa, totalLowCsaFormula), delim,...        
        sprintf(format.totalFatPercent, totalFatPercentFormula), delim,...        
        sprintf(format.totalMusclePercent, totalMusclePercentFormula), delim,...            
        sprintf(format.totalLowPercent, totalLowPercentFormula), delim);
    
    fprintf(fileId, line);

    fprintf(fileId, newline);
end
