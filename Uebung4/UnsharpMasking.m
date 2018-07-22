function result = UnsharpMasking(image, mask, a)

% im2double, image gets values in range [0,1]
image = double(image);
minValue = min(image(:));
maxValue = max(image(:));
image = (image - minValue ) / (maxValue - minValue);

% ImageFiltering returns an image with values in range [0,1]
% result = (I) + a*[ (I) - (I*H) ]
result = image + a*(image - ImageFiltering(image, mask));
end

