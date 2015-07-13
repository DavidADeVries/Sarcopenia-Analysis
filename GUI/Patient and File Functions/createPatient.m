function [ patient ] = createPatient(patientId, studies)
%createPatient(patientId, studies)
%   as required by GIANT

patient = Patient(patientId, studies); %sarco doesn't need different patient class

end

