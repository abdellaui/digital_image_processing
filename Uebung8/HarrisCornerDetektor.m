function result = HarrisCornerDetektor( image, windowSize, k )
dx = [-1 0 1; -1 0 1; -1 0 1]; 
dy = dx';

I = double(image);
copyI = I;
Ix = conv2(I, dx, 'same');   
Iy = conv2(I, dy, 'same');
%figure(1),imshow(Ix);
%figure(2),imshow(Iy);
Ix2 = Ix.^2;  
Iy2 = Iy.^2;
Ixy = Ix.*Iy;

[iX, iY] = size(I);
halfOfWindowSize = ceil(windowSize/2);
for i = 1+halfOfWindowSize:iX-halfOfWindowSize
    for j = 1+halfOfWindowSize:iY-halfOfWindowSize
        sumUpH = zeros(2,2);
        for x=1:windowSize
            for y = 1:windowSize
                tempX = i-halfOfWindowSize+x;
                tempY = j-halfOfWindowSize+y;
                
                sumUpH = sumUpH + [Ix2(tempX, tempY), Ixy(tempX, tempY);  Ixy(tempX, tempY), Iy2(tempX, tempY)];
            end
        end
        
        
        copyI(i,j) = det(sumUpH) - k * (trace(sumUpH).^2);
   
    end
end

% returning the result
result = copyI;


% optimize result for view
copyI  = uint8(255 * mat2gray(copyI));
figure(3),imshow(copyI);
end

