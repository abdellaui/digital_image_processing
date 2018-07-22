function accumulator = GetHoughCircle( image )

rStartInklusive = 5;
rEndExclusive = 21;
[iX, iY] = size(image);

Acc = zeros(iX, iY, rEndExclusive-rStartInklusive);

% get all edges
[u,v] = find(image);

for edgeIndex = 1:numel(u)
    for aX = 1:iX
    for aY = 1:iY
    for radius = rStartInklusive:rEndExclusive-1
        if( (u(edgeIndex) - aX)^2 + (v(edgeIndex) - aY)^2 == radius^2 )
            currRadiusIndex = radius-rStartInklusive+1;
            Acc(aX, aY, currRadiusIndex) = Acc(aX, aY, currRadiusIndex) + 1;
        end
    end
    end
    end
end

accumulator = Acc;

end

