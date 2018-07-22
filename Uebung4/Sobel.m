function [gradientImageX, gradientImageY] = Sobel( image ) 

sX = [-1,0,1; -2,0,2; -1,0,1];
sY = [-1,-2,-1; 0,0,0; 1,2,1];

gradientImageX = ImageFiltering(image, sX);
gradientImageY = ImageFiltering(image, sY);
end

