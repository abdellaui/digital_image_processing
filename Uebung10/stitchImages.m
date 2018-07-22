image1 = double(imread('RUBLeft.png'));
image2 = double(imread('RUBRight.png'));

% set defaultPoints to 1 for using default points
defaultPoints = 1;


if(defaultPoints == 0)
h1 = figure;
title('Markieren Sie ein paar markante Punkte, die auch im anderen Bild vorkommen (ENTER zum Beenden)');
hold on;
imshow(image1, []);

h2 = figure;
hold on;
imshow(image2, []);

% new
[X, Y] = getpts(h1);
pnts = zeros(size(X,1), 2);
pnts(:,1) = X;
pnts(:,2) = Y;
% end new

pnts = pnts(:, 2:-1:1); % die Koordinaten sollten vertauscht werden, damit man image1(pnts(1), pnts(2)) richtig zugreift

figure(h1);
hold on;
plot(pnts(:, 2), pnts(:, 1), 's');

figure(h2);
title('Markieren Sie ein paar markante Punkte, die auch im anderen Bild vorkommen (in derselben Reihenfolge wie vorher, aber ein paar Fehler sind erlaubt)');

% new
[X_, Y_] = getpts(h2);
pnts_ = zeros(size(X_,1), 2);
pnts_(:,1) = X_;
pnts_(:,2) = Y_;
% end new

pnts_ = pnts_(:, 2:-1:1); % die Koordinaten sollten vertauscht werden, damit man image1(pnts(1), pnts(2)) richtig zugreift

close all
else % defaultPoints
   pnts  = [   
       250   643
       284   817
       523   705
       498   915
       212   645
       205   730
       %187   932
       %177   665
       %169   741
       ];
   pnts_ = [   
       141    48
       191   244
       441   149
       389   346
       103    55
       102   150
       %103   344
       %60    72
       %60   159
       ];
end % defaultPoints

pnts = round(pnts);
pnts_ = round(pnts_);

pointCount = size(pnts_,1);

assert(isequal(size(pnts_),size(pnts)), 'please select same amount of points in each picture');
assert(pointCount>3, 'please select more than 4 points');

disp('calculating transformation...');

combinations = nchoosek(1:pointCount, 4);
[cX, cY] = size(combinations);

transformations = zeros(3,3, cX);
consensusSet = zeros(cX, 1);

for n = 1:cX
    currCombIt = combinations(n, :) %;  %comment out

    s1 = pnts_(currCombIt(1), :);
    s2 = pnts_(currCombIt(2), :);
    s3 = pnts_(currCombIt(3), :);
    s4 = pnts_(currCombIt(4), :);
    
    t1 = pnts(currCombIt(1), :);
    t2 = pnts(currCombIt(2), :);
    t3 = pnts(currCombIt(3), :);
    t4 = pnts(currCombIt(4), :);
    try
        transformations(:,:, n) =  double(getInverseProjectiveMatrix(s1, s2, s3, s4, t1, t2, t3, t4));
    catch 
        warning('choosen bad points, maybe it causes problems!');
    end
    
    % calculate consensus set with random points
    seed = RandStream('mt19937ar','Seed','shuffle');
    randomPoints = datasample(seed, 1:pointCount, ceil(pointCount/2),'Replace',false) %; %comment out
    for i = randomPoints
        chckPnt = pnts(i, :);
        [chckPnt(1), chckPnt(2)] = TRNS(transformations(:,:, n), chckPnt(1), chckPnt(2));
        chckPnt = round(chckPnt);
        if(pnts_(i, :) == chckPnt)
            consensusSet(n) = consensusSet(n) + 1; 
        end
    end % consensusSet
    
end % all comb transformation

% pick transformation with best consensusSet
[maxVal, position] = max(consensusSet);

assert(maxVal > 0, 'hmm... transformation doesnt make sense!');

T = transformations(:,:, position);

disp('slitching images...');

[i1_X, i1_Y] = size(image1);
[i2_X, i2_Y] = size(image2);

% calculating target size and other props

%{
calc transformated image2
top   right
left  bottom
coardinates.
%}

[top(1), top(2)] = TRNS(inv(T),1,1);
top = round(top);   

[right(1), right(2)] = TRNS(inv(T), i2_X, 1);
right = round(right);   

[bottom(1), bottom(2)] = TRNS(inv(T), i2_X, i2_Y);
bottom = round(bottom);     

[left(1), left(2)] = TRNS(inv(T), 1, i2_Y);
left = round(left);


tempSizeMinX = min([top(1), right(1), bottom(1), left(1)]);
tempSizeMaxX = max([top(1), right(1), bottom(1), left(1)]);
tempSizeMinY = min([top(2), right(2), bottom(2), left(2)]);
tempSizeMaxY = max([top(2), right(2), bottom(2), left(2)]);


targetX = abs(tempSizeMaxX - tempSizeMinX);
targetY = abs(tempSizeMaxY); 

offsetX = tempSizeMinX;
offsetY = 0;
target = double(zeros(targetX, targetY));
% end calculating target size and other props
% consistency - its not realy necessary, just calculated size one step before
[tX, tY] = size(target);

for x = 1:tX
    for y = 1:tY
        tempX = x + offsetX;
        tempY = y + offsetY;
        % put image
        if(tempX<=i1_X && tempX>0 && tempY <= i1_Y && tempY>0)
            target(x,y) = image1(tempX, tempY);
            
        end % put image
        
        
        % appending image2
        [tempCoard(1), tempCoard(2)] = TRNS(T, tempX, tempY);
        if( tempCoard(1)<i2_X && tempCoard(1)>=1 && tempCoard(2)<i2_Y && tempCoard(2)>=1 )
      
            % interpolate
            xUp = ceil(tempCoard(1));
            xDown = floor(tempCoard(1));

            yUp = ceil(tempCoard(2));
            yDown = floor(tempCoard(2));

            x_0 = tempCoard(1) - xDown;
            y_0 = tempCoard(2) - yDown;

            w_0 = (1-y_0)*(1-x_0);
            w_1 = (1-y_0)*x_0;
            w_2 = y_0*(1-x_0);
            w_3 = y_0*x_0;
            target(x, y) = w_0*image2(xDown, yDown) + w_1*image2(xUp, yDown) + w_2*image2(xDown, yUp) + w_3*image2(xUp, yUp);

        end % appending image2
    end % y it
end % x it
        
disp('finished!');
figure(3),imshow(imresize(uint8(target),0.3));

function [x, y] = TRNS(m, x_, y_)
assert(size(m,1) == 3 && size(m,2) == 3, 'm need to be 3x3');
try
    result_ = m * [x_; y_; 1];
    x = result_(1)/result_(3);
    y = result_(2)/result_(3);
catch
    warning('something went wrong!');
end
end
