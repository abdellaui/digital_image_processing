function result = NonMaximumSuppression( gradientImageX, gradientImageY )

% atan2(x,y) returns values in the closed interval [-pi,pi]
directions = atan2(gradientImageX, gradientImageY);

gardients = sqrt(gradientImageX.^2 + gradientImageY.^2);
copyOfGardients = gardients;

[imgX, imgY] = size(gardients);

for iX = 1:imgX
    for iY = 1:imgY
        currDir = directions(iX,iY);
        neightborCoard_1 = [0, 0];
        neightborCoard_2 = [0, 0];
        
        %{
         imagine a map of neightbors
         1 2 3
         4 x 5
         6 7 8
        %}
        
        % 5
        if(currDir > -1*pi/8 && currDir <= pi/8)
            neightborCoard_1 = [iX, iY-1]; % 2
            neightborCoard_2 = [iX, iY+1]; % 7
        % 3
        elseif(currDir > pi/8 && currDir <= 3*pi/8)
            neightborCoard_1 = [iX-1, iY-1]; % 1
            neightborCoard_2 = [iX+1, iY+1]; % 8
        % 2
        elseif(currDir > 3*pi/8 && currDir <= 5*pi/8)
            neightborCoard_1 = [iX-1, iY]; % 4
            neightborCoard_2 = [iX+1, iY]; % 5
        % 1
        elseif(currDir > 5*pi/8 && currDir <= 7*pi/8)
            neightborCoard_1 = [iX+1, iY-1]; % 3
            neightborCoard_2 = [iX-1, iY+1]; % 6
            
        % maybe i can handle this better
        
        % 4, similiar to 5
        elseif(currDir > 7*pi/8 && currDir <= -7*pi/8)
            neightborCoard_1 = [iX, iY-1]; % 2
            neightborCoard_2 = [iX, iY+1]; % 7
        % 6, similiar to 3
        elseif(currDir > -7*pi/8 && currDir <= -5*pi/8)
            neightborCoard_1 = [iX-1, iY-1]; % 1
            neightborCoard_2 = [iX+1, iY+1]; % 8
        % 7, similiar to 2
        elseif(currDir > -5*pi/8 && currDir <= -3*pi/8)
            neightborCoard_1 = [iX-1, iY]; % 4
            neightborCoard_2 = [iX+1, iY]; % 5
        % 8, similiar to 1
        elseif(currDir > -3*pi/8 && currDir <= -1*pi/8)
            neightborCoard_1 = [iX+1, iY-1]; % 3
            neightborCoard_2 = [iX-1, iY+1]; % 6
        end
        
        
        % zero padding
        neightbor_1 = 0; 
        if(neightborCoard_1(1) >=1 && neightborCoard_1(2) >= 1 && neightborCoard_1(1) <= imgX && neightborCoard_1(2) <= imgY)
           neightbor_1 = gardients(neightborCoard_1(1), neightborCoard_1(2));
        end
        
        % zero padding
        neightbor_2 = 0; 
        if(neightborCoard_2(1) >=1 && neightborCoard_2(2) >= 1 && neightborCoard_2(1) <= imgX && neightborCoard_2(2) <= imgY)
           neightbor_2 = gardients(neightborCoard_2(1), neightborCoard_2(2));
        end

        % check if neightbor is greather
        if(max([neightbor_1, neightbor_2]) > gardients(iX, iY))
            copyOfGardients(iX, iY) = 0;
        end
    end
end

% scale the range to [0,1]
minValue = min(copyOfGardients(:));
maxValue = max(copyOfGardients(:));
copyOfGardients = (copyOfGardients - minValue ) / (maxValue - minValue);

result = copyOfGardients;
end

