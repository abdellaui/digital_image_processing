function hist = GetHistogram(image)

% convert image to gray
% cast to uint8, so all values are in range 0-255
tempImage = im2uint8(image);

% get props
height = size(tempImage, 1);
width = size(tempImage, 2);
maxValue = uint16(max(max(tempImage)))+1;
% make a array with 256 items, wich are all init with 0.
tempHisto = zeros(1, maxValue);
for x = 1:height
    for y = 1:width
       % matlab starts indexing by 1, but our expected values are between 0-255, so add 1
       currIndex = tempImage(x,y);
       currIndex = uint16(currIndex) + 1;
       % inkrement
       tempHisto(:,currIndex) = uint16(tempHisto(:,currIndex)) + 1;
       
    end
end

hist = tempHisto;
end

