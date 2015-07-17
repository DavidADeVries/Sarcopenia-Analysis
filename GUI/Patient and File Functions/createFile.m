function [ file ] = createFile(imageFilename, dicomInfo, imagePath)
%[ file ] = createFile(imageFilename, dicomInfo, imagePath)
%   as required by GIANT

file = FamSamFile(imageFilename, dicomInfo, imagePath);

end

