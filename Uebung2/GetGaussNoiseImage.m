function result = GetGaussNoiseImage( sizeX, sizeY, std )
% randn(n,m) gives a random normally distributed matrix
% so default values are for mean = 0 and sigma = 1

mean = 0;
sigma = std;

tmpResult = randn(sizeX, sizeY) * sigma + mean;

% to scale the matrix range to [0,1] comment next line out
% tmpResult(:) = (tmpResult(:)-min(tmpResult(:)) ) / (max(tmpResult(:))-min(tmpResult(:)));

% i ignore the type of result
% so i can always convert it to the type i need 

result = tmpResult;
end

