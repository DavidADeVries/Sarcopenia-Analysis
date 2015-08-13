function [ values ] = setFields(cellValues)
%[ values ] = setFields(cellValues)
% takes in the values of a row cells read in, in order, and returns them,
% conveinently stored in a struct

values = struct(...
    'patientId', cellValues{1},...
    'patientSex', cellValues{2},...
    'patientDob', cellValues{3},...
    'sequenceNumber', str2double(cellValues{4}),...
    'studyDate', cellValues{5},...
    'modality', cellValues{7},... % cellFormula{6} skipped; age formula (must be updated to have proper cell references)
    'studyName', cellValues{8},...
    'seriesName', cellValues{9},...
    'fileName', cellValues{10},...
    'leftCsa', str2double(cellValues{11}),...
    'leftFatCsa', str2double(cellValues{12}),...
    'leftMuscleCsa', str2double(cellValues{13}),...
    'rightCsa', str2double(cellValues{16}),... %skip left ROI percent formulas, 14 -> 15
    'rightFatCsa', str2double(cellValues{17}),...
    'rightMuscleCsa', str2double(cellValues{18})); % everything from the total columns is formulas, no need to store 19 -> 25


end

