function [ file ] = createFile(imageFilename, dicomInfo, dicomImage)
%[ file ] = createFile(imageFilename, dicomInfo, dicomImage)
%   as required by GIANT

file = FamSamFile(imageFilename, dicomInfo, dicomImage);

end

