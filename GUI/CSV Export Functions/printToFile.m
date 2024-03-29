function [] = printToFile(fileId, lineNumber, values, newline, delim)
% printToFile(fileId, lineNumber, values, newline, delim)
% prints the values from the struct values into file at fileId. The
% lineNumber given is used for an excel formulae that may need to be
% written. newLine and delim (delimiter) values are given for ease of
% change in case a different format is needed
% required by GIANT

    rowChar = num2str(lineNumber);

    dobCell = ['C', rowChar];
    studyDateCell = ['E', rowChar];

    ageFormula = ['=(MONTH(', studyDateCell ,') - MONTH(', dobCell, '))+(YEAR(', studyDateCell, ') - YEAR(', dobCell, '))*12'];
    
    leftFatPercentFormula = ['=100*L', rowChar, '/K', rowChar];
    leftMusclePercentFormula = ['=100*M', rowChar, '/K', rowChar];
    
    rightFatPercentFormula = ['=100*Q', rowChar, '/P', rowChar];
    rightMusclePercentFormula = ['=100*R', rowChar, '/P', rowChar];
    
    totalCsaFormula = ['=K', rowChar, '+P', rowChar];
    totalFatCsaFormula = ['=L', rowChar, '+Q', rowChar];
    totalMuscleCsaFormula = ['=M', rowChar, '+R', rowChar];
    
    totalFatPercentFormula = ['=100*V', rowChar, '/U', rowChar];
    totalMusclePercentFormula = ['=100*W', rowChar, '/U', rowChar];
    
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
        'leftCsa', '%6.1f',...
        'leftFatCsa', '%6.1f',...
        'leftMuscleCsa', '%6.1f',...
        'leftFatPercent', '%s',... %since formula is string
        'leftMusclePercent', '%s',... %since formula is string
        'rightCsa', '%6.1f',...
        'rightFatCsa', '%6.1f',...
        'rightMuscleCsa', '%6.1f',...
        'rightFatPercent', '%s',... %since formula is string
        'rightMusclePercent', '%s',... %since formula is string
        'totalCsa', '%s',... %since formula is string
        'totalFatCsa', '%s',... %since formula is string
        'totalMuscleCsa', '%s',... %since formula is string
        'totalFatPercent', '%s',... %since formula is string
        'totalMusclePercent', '%s'); %since formula is string
    
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
        sprintf(format.leftCsa, values.leftCsa), delim,... 
        sprintf(format.leftFatCsa, values.leftFatCsa), delim,...
        sprintf(format.leftMuscleCsa, values.leftMuscleCsa), delim,...       
        sprintf(format.leftFatPercent, leftFatPercentFormula), delim,...        
        sprintf(format.leftMusclePercent, leftMusclePercentFormula), delim,...
        sprintf(format.rightCsa, values.rightCsa), delim,...
        sprintf(format.rightFatCsa, values.rightFatCsa), delim,...
        sprintf(format.rightMuscleCsa, values.rightMuscleCsa), delim,...
        sprintf(format.rightFatPercent, rightFatPercentFormula), delim,...
        sprintf(format.rightMusclePercent, rightMusclePercentFormula), delim,...
        sprintf(format.totalCsa, totalCsaFormula), delim,...
        sprintf(format.totalFatCsa, totalFatCsaFormula), delim,...
        sprintf(format.totalMuscleCsa, totalMuscleCsaFormula), delim,...
        sprintf(format.totalFatPercent, totalFatPercentFormula), delim,...
        sprintf(format.totalMusclePercent, totalMusclePercentFormula), delim);
    
    fprintf(fileId, line);

    fprintf(fileId, newline);
    
end

