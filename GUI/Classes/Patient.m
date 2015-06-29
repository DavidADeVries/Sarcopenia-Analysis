classdef Patient
    %Patient a patient contains a list of (DICOM) Files, in order from
    %earliest to latest
    
    properties
        files = File.empty;
        currentFileNum = 0;
        patientId
        savePath = '';
        changesPending = true;
    end
    
    methods
        %% Constructor %%
        function patient = Patient(patientId)
            patient.patientId = patientId;
        end
        
        
        %% getCurrentFile %%
        function file = getCurrentFile(patient)
            if patient.currentFileNum == 0 %no files
                file = File.empty;
            else
                file = patient.files(patient.currentFileNum);
            end
        end
        
        %% updateCurrentFile %%
        function patient = updateCurrentFile(patient, file) %updates the current file to be the file provided
            patient.files(patient.currentFileNum) = file;
        end
        
        %% addFile %%
        function patient = addFile(patient, file)            
            oldFiles = patient.files;
            numOldFiles = length(oldFiles);            
            
            i = 1; %needs to be defined before hand, in case numOldFiles = 0;
            
            while i <= numOldFiles
                if file.date < oldFiles(i).date
                    break;
                end
                
                i = i+1;
            end
                      
            if i == 1
                newFiles = [file, oldFiles];                     
                patient.currentFileNum = 1;
            elseif i == numOldFiles
                newFiles = [oldFiles, file];                                 
                patient.currentFileNum = numOldFiles+1;
            else            
                newFiles = [oldFiles(1:i-1), file, oldFiles(i:numOldFiles)];
                patient.currentFileNum = i;
            end
                        
            patient.files = newFiles;   
        end
        
        %% getNumFiles %%
        function numFiles = getNumFiles(patient)
            numFiles = length(patient.files);
        end
        
        %% removeCurrentFile %%
        function patient = removeCurrentFile(patient) %removes current file, new current file is later image (earlier if latest image is removed)
            oldFiles = patient.files;
            numOldFiles = length(oldFiles);
            
            numNewFiles = numOldFiles - 1;
            
            currentFileNumber = patient.currentFileNum;
            
            if numNewFiles == 0
                patient.currentFileNum = 0;
                patient.files = [];
            else
                newFileCounter = 1;
                newFiles = File.empty(numNewFiles, 0);
                
                for i=1:numOldFiles
                    if i ~= currentFileNumber
                        newFiles(newFileCounter) = oldFiles(i);
                        newFileCounter = newFileCounter + 1;
                    end
                end
                
                patient.files = newFiles;
                
                if currentFileNumber > numNewFiles
                    currentFileNumber = numNewFiles; 
                end
                
                patient.currentFileNum = currentFileNumber;
            end            
        end
        
        %% updateFile %%
        function [ patient ] = updateFile( patient, file, updateUndo, changesPending, varargin)
            %pushUpChanges updates current file changes for a patient
            
            if updateUndo
                file = file.updateUndoCache();
            end
            
            if length(varargin) == 1 %fileNumber is specified! Not currentFile
                fileNum = varargin{1};
                patient.files(fileNum) = file;
            else
                patient = patient.updateCurrentFile(file);
            end
            
            if changesPending
                patient.changesPending = true;
            end
            
        end

        %% saveToDisk %%
        function [ patient ] = saveToDisk(patient)
            %saveToDisk saves the patient's data and open files to the disk
            if isempty(patient.savePath)
                filename = strcat(Constants.SAVE_TITLE_SUGGESTION, {' '}, num2str(patient.patientId), '.mat');
                path = strcat(Constants.HOME_DIRECTORY, filename);
                
                [saveFilename, savePathname] = uiputfile(path,'Save Patient');
                
                if saveFilename ~= 0
                    patient.savePath = strcat(savePathname, saveFilename);
                    
                    fid = fopen(patient.savePath, 'w'); %create file
                    fclose(fid);
                end
            end
            
            if ~isempty(patient.savePath) %if not empty, save, otherwise abort
                patient.changesPending = false; % because they're being saved now :)
                
                save(patient.savePath, 'patient');
            end
        end
    end
    
end

