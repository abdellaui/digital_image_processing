function demonstrateAdaBoost()

close all;

no_weak_classifiers = 10; % adjust me (number of weak classifiers)
grid_on = true; % adjust me (switches between two distributions to classify)

% sample some points (half-ring pattern)
if ~ grid_on
    samples_per_class = 100; % adjust me
    samples = randn( samples_per_class, 2 );
    orientations = 0.5 * 2 * pi * rand( samples_per_class, 1 );
    radii = randn( samples_per_class, 1 ) + 4;
    samples = cat(1, samples, cat(2, cos(orientations), sin(orientations)) .* (repmat(radii, [1, 2])) );
    labels = cat(1, ones(samples_per_class, 1), - ones(samples_per_class, 1) );
else
    [x, y] = meshgrid( -6:0.5:6, -6:0.5:6 );
    samples(:, 1) = x(:);
    samples(:, 2) = y(:);
    norms = sqrt(samples(:, 1).^2 + samples(:, 2).^2);
    labels = 1 .* double( norms < 3 ) + (-1) .* double( norms >= 3 & y(:) > 0 );
    
    samples(labels == 0, :) = [];
    labels(labels == 0) = [];
end

sample_weights = ones( size(samples, 1), 1 );
sample_weights = sample_weights / sum(sample_weights);


hMain = figure;




alpha_vec = []; % vector of weights, alpha on the lecture slides
ws = []; % weight vectors of weak linear classifiers
cs = []; % offset scalars of weak linear classifiers

for t = 1:no_weak_classifiers
    
%     [w,c] = trainLDA( samples, sample_weights, samples_per_class );
    %owndebug(sprintf('before_%d', t), samples, sample_weights, labels);
    [w,c] = trainLinClass( samples, sample_weights, labels );
    %owndebug(sprintf('after_%d', t), samples, w, labels);

    % trainLinClass yields a linear classifier with weight vector w and
    % offset c to minimize the weighted classification error of all samples
    % given the corresponding sample_weights, 
    % sample_weights(i) contains the weight of sample(i, :)
    % labels(i) contains a 1 or -1 for the class of sample(i, :)

    ws(end + 1, :) = w; % store w and c for each chosen weak classifier
    cs(end + 1) = c;

    [alpha_vec, sample_weights, strong_correct] = buildStrongClassifier( alpha_vec, ws, cs, samples, sample_weights, labels );
    % buildStrongClassifier updates the strong classifier given by
    % alpha_vec
    % ws, cs, store all weak classifiers that were so far selected
    % buildStrongClassifier also updates the sample_weights according to
    % the classification results of the latest weak classifier
    % strong_correct(i) is true iff samples(i, :) is correctly classified
    % by the current strong classifier

    % draw state of AdaBoost into main figure and wait 1 sec
    
    figure(hMain);
    cla;
    colors = [[1., 0, 0]; [0., 0., 1.]];
    min_marker_size = 15;
    marker_sizes = 20 * size(samples, 1) * sample_weights(labels == 1);
    marker_sizes( marker_sizes < min_marker_size ) = min_marker_size;
    scatter( samples(labels == 1, 1), samples(labels == 1, 2), marker_sizes, ...
        colors( int32(strong_correct(labels == 1)) + 1 , : ), 'x');
    hold on;
    marker_sizes = 20 * size(samples, 1) * sample_weights(labels == -1);
    marker_sizes( marker_sizes < min_marker_size ) = min_marker_size;    
    scatter( samples(labels == -1, 1), samples(labels == -1, 2), marker_sizes, ...
        colors( int32(strong_correct(labels == -1)) + 1 , : ), 'o');
    xlim([-6;6]);
    ylim([-6;6]);
    for k = 1:numel(cs)
        drawHyperplane( ws(k, :), cs(k) );
    end
    drawnow();
    pause(1);
    
end
end

function [w, c] = trainLinClass( samples, sample_weights, labels )

X = sqrt(sum(samples.^2, 2));
y_ = labels;

w = sample_weights;
%c = X'*w;
c = 0;

% explained here: https://people.eecs.berkeley.edu/~jrs/189/lec/02.pdf
% explained here: https://people.eecs.berkeley.edu/~jrs/189/lec/03.pdf
learnrate = 0.15;
run = true;
while run
    V = y_ .* (X .* w) + c;
    indexes = find(V<0);
    if isempty(indexes)
        run = false;
    end
    for i = indexes
        w(i) = w(i) + learnrate.*y_(i).*X(i);
    end
end


% train a linear classifier that minimizes the weighted error when
% classifying samples
%
% do this brute-force: try orientations from 0 to 2pi and useful offsets
% and return the linear classifier with minimum weighted error
%
% you can you my_sign (see below) if you want, do not user Matlab's sign
% function
end

    
    
function [alpha_vec, sample_weights, strong_correct] = buildStrongClassifier( alpha_vec, ws, cs, samples, sample_weights, labels )
% perform one iteration of AdaBoost, ws(end), cs(end) contain the most recent weakest classifier, integrate it into the strong classifier

% according to the rules from AdaBoost as shown on the lecture slides
X = sqrt(sum(samples.^2, 2));
w_ = sample_weights;
y_ = labels;
currC = cs(end);
h_j = my_sign(ws(end)' .* X + currC);
e_j = 0.5 * sum( w_ .* abs( h_j - y_) );


w_ = w_ .* (e_j/(1-e_j)) .^ (y_ .* h_j);

%{
[wX, wY] = size(w_);
for i = 1:wX
    w_(i) = w_(i) * (e_j/(1-e_j)) ^ (y_(i) * h_j(i));
end
%}

alpha_vec(end + 1) = log( (1-e_j) / e_j );
strong_correct = my_sign(w_ .* X + currC) == y_;
sample_weights = w_;
end
    
    
function drawHyperplane( w, c )

    pnts_on_line = zeros(2, 2);
    if abs(w(2)) < 1e-5
        pnts_on_line(1, 1) = c / w(1);
        pnts_on_line(2, 1) = 0;
        pnts_on_line(1, 2) = pnts_on_line(1, 1) + 10 * w(2);
        pnts_on_line(2, 2) = pnts_on_line(2, 1) - 10 * w(1);
        pnts_on_line(1, 1) = pnts_on_line(1, 2) - 20 * w(2);
        pnts_on_line(2, 1) = pnts_on_line(2, 2) + 20 * w(1);        
    else
        pnts_on_line(1, 1) = 0;
        pnts_on_line(2, 1) = c / w(2);
        pnts_on_line(1, 2) = pnts_on_line(1, 1) + 10 * w(2);
        pnts_on_line(2, 2) = pnts_on_line(2, 1) - 10 * w(1);
        pnts_on_line(1, 1) = pnts_on_line(1, 2) - 20 * w(2);
        pnts_on_line(2, 1) = pnts_on_line(2, 2) + 20 * w(1);
    end
            
    line( pnts_on_line( 1, : ), pnts_on_line( 2, : ) );
end

function s = my_sign( x )
    s = double(x >= 0) - double(x < 0);
end

function owndebug(name, samples, sample_weights, labels)
     
    figure('Name', sprintf('%s weights', name)), plot([1:size(sample_weights,1)], sample_weights);
    
    samples_ = samples .* sample_weights;
    samples_(:,3)=labels;

    samples1 = samples_(samples_(:,3)==1, 1:2);
    samples2 = samples_(samples_(:,3)==-1, 1:2);

    
    figure('Name', sprintf('%s 2D', name)), plot(samples1(:,1), samples1(:,2), 'bx', samples2(:,1), samples2(:,2), 'rx'), grid on;
  
    
    distance = sqrt(samples_(:,1).^2 + samples_(:,2).^2) .* sample_weights;
    distance(:,2)=labels;
    
    dist1 = distance(distance(:,2)==1);
    dist2 = distance(distance(:,2)==-1);
    
    %text(samples1(:,1), samples1(:,2), num2str(round(dist1,2)));
    %text(samples2(:,1), samples2(:,2), num2str(round(dist2,2)));

    
    figure('Name',sprintf('%s 1D', name)), plot(dist1, 1, 'bx', dist2, -1, 'rx'), grid on;

end