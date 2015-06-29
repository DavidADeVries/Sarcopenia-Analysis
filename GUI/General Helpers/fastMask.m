function [ mask ] = fastMask( splinePoints, imageSize)
%[ mask ] = fastMask( splinePoints) 
%creates a mask given the spline points.
%way faster than doing:
%   h = impoly(axesHandle, splinePoints);
%   h.createMask();

mask = zeros(imageSize);

lastPoint = splinePoints(1,:);

for j=2:height(splinePoints)
    curPoint = splinePoints(j,:);
    
    delX = curPoint(1) - lastPoint(1);
    delY = curPoint(2) - lastPoint(2);
    
    len = norm(curPoint - lastPoint);
    
    if len ~= 0
        stepX = delX/len;
        stepY = delY/len;
        
        for k=0:ceil(len)
            mask(round(lastPoint(2) + k*stepY), round(lastPoint(1) + k*stepX)) = 1;
        end
    end
    
    lastPoint = curPoint;
end

mask = imfill(mask,'holes');

end

