function C = getCovariance( data )
[cM, cN] = size(data);

meanSub = data - mean(data);
C = (meanSub.' * meanSub)/(cM-1);
end

