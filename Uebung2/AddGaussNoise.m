function result = AddGaussNoise( image, std )

[imgX, imgY] = size(image);
tmpGaussNoise = GetGaussNoiseImage(imgX, imgY, std);

% i said that i ignore the type of GetGaussNoiseImage
% now i know that im working with bw image, i expect uint8 image
% let convert image to double
% so its additable to tmpGaussNoise

tmpImage = double(image);

% i hope matlab has a defined overflow behavior for this addition
result = tmpImage + tmpGaussNoise;
end
