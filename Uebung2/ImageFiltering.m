function result = ImageFiltering( image, mask )

image = im2double(image);

[imgX, imgY] = size(image);

copyOfImage = image;

% for getting a black border comment next line out
%copyOfImage = double(zeros(imgX, imgY));

[maskX, maskY] = size(mask);
%{
+-----------+
| * * * * * |    got a 5x5 mask, need to calc X index
| * * * * * |    halfOfMaskX = floor(5/2);
| * * X * * |    halfOfMaskY = floor(5/2);
| * * * * * |   
| * * * * * |
+-----------+
%}

% i prefer ceil instead of floor because matlab starts indexing by 1 
halfOfMaskX = ceil(maskX/2);
halfOfMaskY = ceil(maskY/2);
endX = imgX - halfOfMaskX;
endY = imgY - halfOfMaskY;

% ignoring halfOfMaskX pixels on the left and right border
% ignoring halfOfMaskY pixels on the top and bottom border
for iX = halfOfMaskX:endX
    for iY = halfOfMaskY:endY
        
        % run mask for each pixel ans store it on tmpValue
        tmpColorValue = 0.0;
        for  mX = 1:maskX
            for mY = 1:maskY
                % iX and iY has a padding of halfOfMaskX/halfOfMaskY (for loops)
                % so get them out for reading pixels starting by index (1,1)
                 tmpX = iX - halfOfMaskX + mX;
                 tmpY = iY - halfOfMaskY + mY;
                 tmpColorValue = tmpColorValue + image(tmpX, tmpY) * mask(mX, mY);
 
            end
        end
        copyOfImage(iX, iY) = tmpColorValue;
    end
end


% make image double in range [0,1]
minValue = min(copyOfImage(:));
maxValue = max(copyOfImage(:));

result = (copyOfImage - minValue ) / (maxValue - minValue);
result = copyOfImage;
end

