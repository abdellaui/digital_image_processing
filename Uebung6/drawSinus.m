function result = drawSinus( image, x1, x2 )

[imgX, imgY] = size(image);

theta = ((-90:89)./180) .* pi;
dimensionSkalar = sqrt(imgX^2 + imgY^2);
tempImg = zeros(ceil(2 * dimensionSkalar), numel(theta));

% r = x1 * sin(?) + x2 * cos(?)
r = x1 * sin(theta) + x2 * cos(theta);
r = r + dimensionSkalar; 
% making r to usable indexes
r = floor(r) + 1; 

for i = 1:numel(r)
   tempImg(r(i),i) = 1; 
end

result = tempImg;
end

