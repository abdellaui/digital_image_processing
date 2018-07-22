function result = HistogramEqualization( image )

histogram = GetHistogram(image);


% getting the size of histogram, it contains info about max gray value
sizeOfHisto_L = size(histogram, 2);

% create an array of zeros
lookUpTable = zeros(sizeOfHisto_L);

% GetCumulativeHist returns a histogram with size of the parameter, so
% its guaranteed that cumulativeHist has same size of lookUpTable
cumulativeHist = GetCumulativeHist(histogram);

[M,N] = size(image);
L_DIV_MN = 256 / (M*N);

for a = 1:sizeOfHisto_L
    % maybe dont need floor, but i dont understand how matlab works,
    % its stupid, so its better to be sure its flooring the value.
    lookUpTable(a) = uint8(floor(cumulativeHist(a) * L_DIV_MN));
end


% make a copy of image for appyling result of the prev calculation
tmpImage = image;

for x = 1:M
    for y = 1:N
        % matlab annoys me, so i decide to use uint16 first and add 1
        currLookUpIndex = uint16(tmpImage(x,y)) + 1;
        tmpImage(x,y) = lookUpTable(currLookUpIndex);
    end
end

result = tmpImage;
end

