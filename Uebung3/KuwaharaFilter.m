function result = KuwaharaFilter( image, maskSize )
image = im2double(image);
tmpImage = image;
[imgX, imgY] = size(image);

halfOfMaskSize = ceil(maskSize/2);

for iX = 1:imgX
    for iY = 1:imgY
        
        quadSumOfSubMask = double(zeros(4,1));
        sumOfSubMask = double(zeros(4,1));
        
        for mX = 1:maskSize
            for mY = 1:maskSize
                
                tempX = (iX - halfOfMaskSize + mX);
                tempY = (iY - halfOfMaskSize + mY);
                %{
                % reflected
                if(tempX>imgX)
                    tempX = tempX - imgX;
                end
                if(tempY>imgY)
                    tempY = tempY - imgY;
                end
                if(tempX<=0)
                    tempX = tempX + imgX;
                end
                if(tempY<=0)
                    tempY = tempY + imgY;
                end
                % reflecred end
                %}
                
                %{
                % periodic
                tempX = mod(tempX, imgX) + 1;
                tempY = mod(tempY, imgY) + 1;
                currPixelValue = tmpImage(tempX, tempY);
                % periodic end
                %}
                
                
                % i preffer to use zerro padding, because i dont know 
                % how matlab is handling modulo or operations like + -.

                % zerro padding
                
                currPixelValue = 0; 
                if(tempX >=1 && tempY >= 1 && tempX <= imgX && tempY <= imgY)
                    currPixelValue = image(tempX, tempY);
                end
                % zerro padding end
                
                
                
                % maybe it would be look better if i used nested functions
                
                % a block
                if(mX <= halfOfMaskSize && mY <= halfOfMaskSize)
                    quadSumOfSubMask(1) = quadSumOfSubMask(1) + (currPixelValue.^2);
                    sumOfSubMask(1) = sumOfSubMask(1) + currPixelValue;
                end
                
                % b block
                if(mX >= halfOfMaskSize && mY <= halfOfMaskSize)
                    quadSumOfSubMask(2) = quadSumOfSubMask(2) + (currPixelValue.^2);
                    sumOfSubMask(2) = sumOfSubMask(2) + currPixelValue;
                end
                
                % c block
                if(mX <= halfOfMaskSize && mY >= halfOfMaskSize) 
                    quadSumOfSubMask(3) = quadSumOfSubMask(3) + (currPixelValue.^2);
                    sumOfSubMask(3) = sumOfSubMask(3) + currPixelValue;
                end
                
                % d block
                if(mX >= halfOfMaskSize && mY >= halfOfMaskSize)
                    quadSumOfSubMask(4) = quadSumOfSubMask(4) + (currPixelValue.^2);
                    sumOfSubMask(4) = sumOfSubMask(4) + currPixelValue;
                end
                
            end
        end
        
        %{
        sigma^2 = sum((x-average)^2) / n
        
        // binomial
        =>  sum((x^2 - 2average*x + average^2)) / n
        
        // sum(a+b+c) = sum(a) + sum(b) * sum(c)
        =>  (sum(x^2) - sum(2average*x) + sum(average^2))/n
        
        
        // sum(a*x) = a*sum(x)
        =>  sum(x^2)/n - 2average*(sum(x)/n) + (n*average^2)/n
        
        // (sum(x)/n) = average
        =>  sum(x^2)/n - 2average^2 - avergage^2
        
        // 2a - 1a = 1a
        => sum(x^2)/n - average^2
        %}
        
        countElements = halfOfMaskSize.^2;
        avgOfSubMasks = sumOfSubMask / countElements;
        varianceOfSubMask = (quadSumOfSubMask/countElements) - avgOfSubMasks.^2;
        
        [unusedMinVarianceVal, indexOfSubMaskWithMinVariance] = min(varianceOfSubMask);
        
        tmpImage(iX,iY) = avgOfSubMasks(indexOfSubMaskWithMinVariance);
    end
end
result = tmpImage;
end

