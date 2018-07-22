function result = GetGrayValueImage( image, weightedRed, weightedGreen, weightedBlue )

%{
thanks to:
https://de.mathworks.com/matlabcentral/answers/91036-how-do-i-split-a-color-image-into-its-3-rgb-channels#answer_100472

=> image(:,:,x) - in which x is 1,2,3 - returns the R,G,B matrices

- mult this matrices with depending scalar and get the sum
%}

tempImg = weightedRed * image(:,:,1) + weightedGreen * image(:,:,2) + weightedBlue * image(:,:,3);

% return a matrix with 1 dim
result(:,:,1) = tempImg;
end


