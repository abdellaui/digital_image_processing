function result = moveImage( image, u, v )
[imgX, imgY] = size(image);

% we want to move the pixel on the center of the mask
absU = abs(u)*2 + 1;
absV = abs(v)*2 + 1;

% make a matrix with absV rows absU columns
tmpMask = zeros(absV, absU);


% top
if(u > 0 && v > 0)
    tmpMask(1,1) = 1;
% right
elseif(u > 0 && v <= 0)
    tmpMask(absV, 1) = 1;
% bottom
elseif(u <= 0 && v > 0)
    tmpMask(1,absU) = 1;
% left
elseif(u <= 0 && v <= 0)
    tmpMask(absV,absU) = 1;
end
result = ImageFiltering(image, tmpMask);
end

