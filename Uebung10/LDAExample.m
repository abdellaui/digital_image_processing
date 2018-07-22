samples1 = [ 1.5643 1.4902; 2.3943 2.4583; 2.0497 2.1490; 1.6297 1.7609; 1.6956 1.4698; 1.9083 2.2626; 1.4613 2.0446; 2.1729 2.1671; 1.7803 2.0499; 1.4265 2.2069];
samples2 = [ 1.2766 0.9779; 1.8158 0.9339; 1.0831 1.7136; 1.0613 1.4084; 0.8061 1.8477; 1.4055 1.1933; 2.0285 0.9672; 1.7974 0.7391; 1.2065 2.0268; 1.4891 0.8606];

Mu1 = mean(samples1)';
Mu2 = mean(samples2)';

S1 = getCovariance(samples1);
S2 = getCovariance(samples2);

invSw = inv(S1 + S2);

syms x1 x2;
x = [x1; x2];

lgs = x' * invSw * (Mu1 - Mu2) == 0.5 * ( Mu1' * invSw * Mu1 - Mu2' * invSw * Mu2);

Solve1 = vpasolve(lgs, [-10 -10]);
Solve2 = vpasolve(lgs, [10 10]);

figure(1), plot(samples1(:,1), samples1(:,2), 'x b', samples2(:,1), samples2(:,2), 'x r', [Solve1.x1 Solve2.x1], [Solve1.x2 Solve2.x2]);

%{

samples1:
[1.5643 1.4902]
[1.6956 1.4698]

samples2:
[1.2065 2.0268]

Diese Punkte werden falsch klassifiziert!

%}