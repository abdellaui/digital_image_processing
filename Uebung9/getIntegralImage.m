function result = getIntegralImage( image )
image = double(image);
[iX, iY] = size(image);

integral = image;

for x = 2:iX
    integral(x, :) = integral(x-1, :) + integral(x, :);
end

for y = 2:iY
    integral(:, y) = integral(:, y-1) + integral(:, y);
end

result = integral;
figure(1), imagesc(integral), colorbar;

%{
inklusives Integralbild, da diese bei 2x2 Bildern funktioniert.
%}
end