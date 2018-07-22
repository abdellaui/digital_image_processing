function result = GetCumulativeHist(histogram)

% copy histogram
tmpHist = histogram;

% get size of histo
histoSize = size(histogram, 2);

% start from 2, because first item has the same value before
for x = 2:histoSize
    % add to current item the value of previous item
    tmpHist(:,x) = tmpHist(:,x) + tmpHist(:,x-1);
end

result = tmpHist;

end

