% Create a two-cluster data set with 100 points in each cluster


    [x, y] = meshgrid( -6:0.5:6, -6:0.5:6 );
    samples(:, 1) = x(:);
    samples(:, 2) = y(:);
    norms = sqrt(samples(:, 1).^2 + samples(:, 2).^2);
    labels = 1 .* double( norms < 3 ) + (-1) .* double( norms >= 3 & y(:) > 0 );
    
    samples(labels == 0, :) = [];
    labels(labels == 0) = [];

    
    w = ones( size(samples, 1), 1 );
    w = w / sum(w);
% Create a 200 by 3 data matrix similar to the one you have
% (see note below why 200 by 3 and not 200 by 2)
X = samples .* w;
X(:,3)=1;

% Create 200 by 1 vector containing 1 for each point in the first cluster
% and -1 for each point in the second cluster
b = labels;

% Solve least squares problem
[z,resnorm,residual,exitflag,output,lambda]  = lsqlin(X, b);

% Plot data points and linear separator found above
z(3)/z(2)
y = -z(3)/z(2) - (z(1)/z(2))*X;
hold on;
plot(X(:, 1), X(:, 2), 'bx'); %xlim([-6 6]); ylim([-6 6]);
plot(X, y, 'r');