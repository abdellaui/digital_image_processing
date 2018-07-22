function haarVal = getHaarFeature( whiteRect, blackRect, img ) 
img = double(img);
%[x,y,width,height]
wMinX = whiteRect(1);
wMaxX = wMinX + whiteRect(3);

wMinY = whiteRect(2);
wMaxY = wMinY + whiteRect(4);

bMinX = blackRect(1);
bMaxX = bMinX + blackRect(3);

bMinY = blackRect(2);
bMaxY = bMinY + blackRect(4);

whiteSubImg = img(wMinX:wMaxX-1, wMinY:wMaxY-1);
blackSubImg = img(bMinX:bMaxX-1, bMinY:bMaxY-1);

haarVal = sum(whiteSubImg(:))-sum(blackSubImg(:));
end

