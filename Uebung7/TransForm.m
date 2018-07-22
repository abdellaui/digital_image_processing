function result = TransForm(image, multMatr)

[iX, iY] = size(image);
copyImage = zeros(iX, iY);
for x = 1:iX
    for y = 1:iY
        cordVec = [x+65;y];
        cordVec = multMatr * cordVec;
        tempX = ceil(cordVec(1));
        tempY = ceil(cordVec(2));
        
        if(tempX>0 && tempY>0)
            copyImage(tempX, tempY) = image(x, y);
        end
    end
end

result = uint8(copyImage);
end

