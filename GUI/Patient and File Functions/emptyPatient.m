function [ patient ] = emptyPatient(varargin)
%[ patient ] = emptyPatient()
%   as required by GIANT

numArg = length(varargin);

if numArg == 1
    patient = Patient.empty(varargin{1});
elseif numArg == 2
    patient = Patient.empty(varargin{1}, varargin{2});
else
    patient = Patient.empty;
end

end

