handle = imfreehand();

points = getPosition(handle);

len = length(points);

newPoints = zeros(floor(len/10),2);

for i=1:len
    if mod(i,10) == 0
        newPoints(i/10,:) = points(i,:);
    end
end

points = newPoints;

points(length(points)+1,:) = points(1,:);

x = points(:,1)';
y = points(:,2)';

curve = cscvn([x;y]);

hold on;
fnplt(curve);
plot(x,y,'x','MarkerEdgeColor','y');

% t = cumsum(sqrt([0,diff(x)].^2 + [0,diff(y)].^2)); %arclength
% 
% xSpline = spline(t, x);
% ySpline = spline(t, y);
% 
% tMin = 1;
% tMax = 3000;
% tRes = 1;
% 
% tVals = tMin:tRes:tMax;
% 
% xVals = ppval(xSpline, tVals);
% yVals = ppval(ySpline, tVals);
% 
% hold on;
% 
% plot(xVals, yVals);