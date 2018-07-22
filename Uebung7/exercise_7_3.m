function [] = exercise_7_3()
p_1 = [0,1,0]';
p_2 = [0,-1,0]';
rv = [0,0,1]';

spanne = -50:50;
[sX, sY] = size(spanne);
g_1 = p_1 + rv*spanne;
g_2 = p_2 + rv*spanne;

figure(1), plot3(g_1(1,:), g_1(2,:), g_1(3,:), g_2(1,:), g_2(2,:), g_2(3,:));

fokalLaengen = [1,1];
optischeZentrum = [0,0];
K = [fokalLaengen(1) 0 optischeZentrum(1); 0 fokalLaengen(2) optischeZentrum(2); 0 0 1];

g_1_Data = reshape(g_1(:), [1,3,sY]);
g_2_Data = reshape(g_1(:), [1,3,sY]);

for i = 1:sY
    g_1_Data(:,:,i) = (K * g_1_Data(:,:,i)')';
    g_2_Data(:,:,i) = (K * g_2_Data(:,:,i)')';
end

g_1_Data = reshape(g_1_Data(:),[3, sY]);
g_2_Data = reshape(g_2_Data(:),[3, sY]);

figure(2), plot3(g_1_Data(1,:)/g_1_Data(3,:), g_1_Data(2,:)/g_1_Data(3,:), g_2_Data(1,:)/g_2_Data(3,:), g_2_Data(2,:)/g_2_Data(3,:));

end

