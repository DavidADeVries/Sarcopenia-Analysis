function [ file ] = createFile(imageFilename, dicomInfo, imagePath, image)
%[ file ] = createFile(imageFilename, dicomInfo, imagePath)
%   as required by GIANT

imageDims = size(image);

file = FamSamFile(imageFilename, dicomInfo, imagePath, image, imageDims);

end

