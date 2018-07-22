function result = GetCorrelationCoefficient(image, template)

image = double(image);
template = double(template);
[iX, iY] = size(image);
[tX, tY] = size(template);

maxWidth  = iX-tX;
maxHeight = iY-tY;

tempStdR = std(template(:));
tempMeanR = mean(template(:));

C_N = double(zeros(maxWidth, maxHeight));
N = tX*tY;

for r = 1:maxWidth
    for s = 1:maxHeight
        
        subImgI = image(r:r+tX-1, s:s+tY-1, :);
        
        tempMeanI = mean(subImgI(:));
        tempStdI = std(subImgI(:));
        
        tempVal = (subImgI - tempMeanI) .* (template - tempMeanR);
        top = sum(tempVal(:));
        
        %bottom = sqrt(tempStdI^2 * N) * sqrt(tempStdR^2 * N)
        %bottom = sqrt(tempStdI^2 * tempStdR^2 * N^2);
        
        bottom = tempStdI * tempStdR * N;
        
        assert( (top/bottom)^2 <= 1, "value out of range: "+top/bottom);
        
        
        C_N(r,s) = top/bottom;
    end
end
result = C_N;
end

