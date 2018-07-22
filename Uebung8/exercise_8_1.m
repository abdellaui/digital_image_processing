%{
top   right
left  bottom
%}
corner_left = [202, 1209];
corner_bottom = [933, 1846];
corner_right = [2005, 975];
corner_top = [1259, 626];
sI = double(imread('bookOnTable.png'));
%figure(1),imshow(sI);
[sY, sX] = size(sI);

target = double(zeros(500,300));
[tY, tX] = size(target);
% getInverseProjectiveMatrix returns sym values, so double will execute it.
invMatrix = double(getInverseProjectiveMatrix(corner_top, corner_right, corner_bottom, corner_left, [1, 1], [tX, 1], [tX, tY], [1, tY]));

for x = 1:tX
    for y = 1:tY
        
        tempCoard = invMatrix * [x;y;1];
        tempCoard(1) = tempCoard(1)/tempCoard(3);
        tempCoard(2) = tempCoard(2)/tempCoard(3);

        xUp = ceil(tempCoard(1));
        xDown = floor(tempCoard(1));
        
        yUp = ceil(tempCoard(2));
        yDown = floor(tempCoard(2));
        
        x_0 = tempCoard(1) - xDown;
        y_0 = tempCoard(2) - yDown;
        
        w_0 = (1-y_0)*(1-x_0);
        w_1 = (1-y_0)*x_0;
        w_2 = y_0*(1-x_0);
        w_3 = y_0*x_0;
        target(y,x) = w_0*sI(yDown, xDown) + w_1*sI(yDown, xUp) + w_2*sI(yUp, xDown) + w_3*sI(yUp, xUp);
    end
end
% i dont understand why matlab is changing the x-y behaivor

target  = uint8(255 * mat2gray(target));
figure(2),imshow(target);