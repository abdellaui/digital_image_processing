function result = ContrastChange(image, a, b)
% cast img to uint8 img to know min and max of range
uint8Img = im2uint8(image);
% make a copy of this img
tempImage = uint8Img;

% get props
height = size(tempImage, 1); 
width = size(tempImage, 2);
channel = size(tempImage, 3);

% set min and max of range
minOfRange = 0;
maxOfRange = 255;

for x = 1:height
    for y = 1:width
        for c = 1:channel
           tempPixel = (b * uint8Img(x,y,c)) + a;

           % check range 
           if(tempPixel > maxOfRange)
               tempPixel = maxOfRange;
           end

           if(tempPixel < minOfRange)
               tempPixel = minOfRange;
           end
           % override value
           tempImage(x,y, c) = tempPixel;
        end
    end
end

result = tempImage;
end

