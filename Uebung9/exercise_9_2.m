klinkerImg = double(imread('klinker.png'));
[iX, iY] = size(klinkerImg);

tMinX = 58;
tMaxX = 80;
tMinY = 68;
tMaxY = 90;

assert(tMinX > -1 && tMinX<tMaxX && iX>(tMinX+tMaxX), "x for template image out of range");
assert(tMinY > -1 && tMinY<tMaxY && iY>(tMinY+tMaxY), "y for template image out of range");

template = klinkerImg(tMinX:tMaxX, tMinY:tMaxY, :);
figure(1), imshow(uint8(template));

disp("processing...");
currResult = GetCorrelationCoefficient(klinkerImg, template);
disp("finish!");

currResult(currResult<0.8) = 0;
%currResult(currResult>0.8) = 1;
figure(2), imagesc(currResult), colorbar;

figure(3), imshow(uint8(klinkerImg));

%%max(currResult)