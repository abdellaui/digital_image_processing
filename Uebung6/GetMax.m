function [mx, my, r] = GetMax( accumulator )
copyAcc = accumulator;
[aX, aY, aZ] = size(accumulator);

% because our radius stars by 5 & matlab index starts by 1
radiusOffset = 4; 
for radius = 1:aZ
    %figure(radius),imshow(copyAcc(:,:,radius));
    currRadius = radius+radiusOffset;
    copyAcc(:,:,radius) = copyAcc(:,:,radius) ./ (pi*currRadius^2);
    
end   

[maxValue, position] = max(copyAcc(:));
[tempX, tempY, tempZ] = ind2sub(size(copyAcc), position);

% return values
mx = tempX;
my = tempY;
r = tempY+radiusOffset;
  
end

