function haarVal = getHaarFeatureIntImg( whiteRect, blackRect, intImg )
img = double(intImg);
%[x,y,width,height]
wMinX = whiteRect(1);
wMaxX = wMinX + whiteRect(3);

wMinY = whiteRect(2);
wMaxY = wMinY + whiteRect(4);

%{
bMinX = blackRect(1);
bMaxX = bMinX + blackRect(3);

bMinY = blackRect(2);
bMaxY = bMinY + blackRect(4);
%}
rect_1 = img(1:wMaxX-1, 1:wMaxY-1);
rect_2 = img(1:wMinX, wMinY:wMaxY-1);
rect_3 = img(wMinX:wMaxX-1, 1:wMinY);
rect_4 = img(1:wMinX, 1:wMinY);

haarVal = sum(rect_1(:))-sum(rect_2(:))-sum(rect_3(:))-sum(rect_4(:));
end

