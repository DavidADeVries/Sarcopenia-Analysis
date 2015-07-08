classdef Patient
    %Patient a patient contains a list of (DICOM) Files, in order from
    %earliest to latest
    
    properties
        studies = Study.empty;
        currentStudyNum = 0;
        patientId
        savePath = '';
        changesPending = true;
    end
    
    methods
        %% Constructor %%
        function patient = Patient(patientId, studies)
            patient.patientId = patientId;
            patient.studies = studies;
            
            if ~isempty(studies)
                patient.currentStudyNum = 1;
            end            
        end
        
        
        %% getCurrentStudy %%
        function study = getCurrentStudy(patient)
            if patient.currentStudyNum <= patient.numStudies() && patient.currentStudyNum > 0
                study = patient.studies(patient.currentStudyNum);
            else
                study = Study.empty;
            end
        end
        
        %% numStudies %%
        function num = numStudies(patient)
            num = length(patient.studies);
        end        
        
        %% getCurrentFile %%
        function file = getCurrentFile(patient)
            study = patient.getCurrentStudy();
            
            if ~isempty(study)
                file = study.getCurrentFile();
            else
                file = File.empty;
            end
        end
                        
        %% addFile %%
        function patient = addFile(patient, newFile)  
            study = patient.getCurrentStudy();
            
            if ~isempty(study)
                study = study.addFile(newFile);
                patient.studies(patient.currentStudyNum) = study;
            end  
        end
        
        %% removeCurrentFile %%
        function patient = removeCurrentFile(patient)
            study = patient.getCurrentStudy();
            
            if ~isempty(study)
                study = study.removeCurrentFile();
                patient.studies(patient.currentStudyNum) = study;
            end
        end
        
        %% addStudy %%
        function patient = addStudy(patient, newStudy)
            localStudies = patient.studies;
            
            localStudies = [localStudies, newStudy];
            
            patient.studies = localStudies;
            patient.currentStudyNum = numStudies(patient);
        end
        
        %% removeCurrentStudy %%
        function patient = removeCurrentStudy(patient)
            localStudies = patient.studies;
            
            localStudies(patient.currentStudyNum) = []; %remove
            
            patient.studies = localStudies;
            
            numberStudies = patient.numStudies();
            
            if patient.currentStudyNum > numberStudies %currentStudyNum stays the same unless bottom study is removed
                patient.currentStudyNum = numberStudies;
            end   
        end
        
        %% addSeries %%
        function patient = addSeries(patient, newSeries)
            study = patient.getCurrentStudy();
            
            if ~isempty(study)
                study = study.addSeries(newSeries);
                patient.studies(patient.currentStudyNum) = study;
            end
        end
        
        %% removeCurrentSeries %%
        function patient = removeCurrentSeries(patient)
            study = patient.getCurrentStudy();
            
            if ~isempty(study)
                study = study.removeCurrentSeries();
                patient.studies(patient.currentStudyNum) = study;
            end
        end
        
        
        %% getNumFilesInSeries %%
        function numFiles = getNumFilesInSeries(patient)
            study = patient.getCurrentStudy();
            
            if ~isempty(study)
                numFiles = study.getNumFilesInSeries();
            else
                numFiles = 0;
            end
        end
        
        %% getCurrentFileNumInSeries %%
        function fileNum = getCurrentFileNumInSeries(patient)
            study = patient.getCurrentStudy();
            
            if ~isempty(study)
                fileNum = study.getCurrentFileNumInSeries();
            else
                fileNum = 0;
            end
        end
        
        %% getAllSeriesForCurrentStudy %%
        function series = getAllSeriesForCurrentStudy(patient)
            study = patient.getCurrentStudy();
            
            if isempty(study)
                series = Series.empty;
            else
                series = study.series();
            end
        end
        
        %% getCurrentSeries %%
        function series = getCurrentSeries(patient)
            study = patient.getCurrentStudy();
            
            if isempty(study)
                series = Series.empty;
            else
                series = study.getCurrentSeries();
            end
        end
        
        %% getCurrentSeriesNum %%
        function seriesNum = getCurrentSeriesNum(patient)
            study = patient.getCurrentStudy();
            
            if isempty(study)
                seriesNum = 0;
            else
                seriesNum = study.currentSeriesNum;
            end
        end
        
        %% setCurrentSeriesNum %%
        function patient = setCurrentSeriesNum(patient, seriesNum)
            study = patient.getCurrentStudy();
            
            if ~isempty(study)
                study.currentSeriesNum = seriesNum;
                patient.studies(patient.currentStudyNum) = study;
            end
        end
        
        %% earlierImage %%
        function patient = earlierImage(patient)
            study = patient.getCurrentStudy();
            
            if ~isempty(study)
                patient.studies(patient.currentStudyNum) = study.earlierImage();
            end
        end
        
        %% laterImage %%
        function patient = laterImage(patient)
            study = patient.getCurrentStudy();
            
            if ~isempty(study)
                patient.studies(patient.currentStudyNum) = study.laterImage();
            end
        end
        
        %% earliestImage %%
        function patient = earliestImage(patient)
            study = patient.getCurrentStudy();
            
            if ~isempty(study)
                patient.studies(patient.currentStudyNum) = study.earliestImage();
            end
        end
        
        %% latestImage %%
        function patient = latestImage(patient)
            study = patient.getCurrentStudy();
            
            if ~isempty(study)
                patient.studies(patient.currentStudyNum) = study.latestImage();
            end
        end
              
        %% updateFile %%
        function [ patient ] = updateFile( patient, file, updateUndo, changesPending, varargin)
            %pushUpChanges updates current file changes for a patient
            study = patient.getCurrentStudy();
            
            if ~isempty(study)
                if updateUndo
                    file = file.updateUndoCache();
                end
                
                if changesPending
                    patient.changesPending = true;
                end
                
                if length(varargin) == 1
                    patient.studies(patient.currentStudyNum) = study.updateFile(file, varargin);
                else
                    patient.studies(patient.currentStudyNum) = study.updateFile(file);
                end
            end  
        end

        %% saveToDisk %%
        function [ patient ] = saveToDisk(patient)
            %saveToDisk saves the patient's data and open files to the disk
            if isempty(patient.savePath)
                filename = strcat(Constants.SAVE_TITLE_SUGGESTION, {' '}, num2str(patient.patientId), '.mat');
                path = strcat(Constants.SAVED_PATIENTS_DIRECTORY, filename);
                
                [saveFilename, savePathname] = uiputfile(path,'Save Patient');
                
                if saveFilename ~= 0
                    patient.savePath = strcat(savePathname, saveFilename);
                    
                    fid = fopen(patient.savePath, 'w'); %create file
                    fclose(fid);
                end
            end
            
            if ~isempty(patient.savePath) %if not empty, save, otherwise abort
                patient.changesPending = false; % because they're being saved now :)
                
                waitHandle = pleaseWaitDialog('saving patient data.');
                
                save(patient.savePath, 'patient');
                
                delete(waitHandle);
            end
        end
    end
    
end

