function result = getInverseProjectiveMatrix(s1, s2, s3, s4, t1, t2, t3, t4)

syms a11 a12 a13 a21 a22 a23 a31 a32;
matrix =[a11 a12 a13; a21 a22 a23; a31 a32 1];

vector_1 = [s1(1); s1(2); 1];
gleichung_1 = matrix*vector_1;
vectorHut_1 = [gleichung_1(1)/gleichung_1(3) == t1(1); gleichung_1(2)/gleichung_1(3) == t1(2)];

vector_2 = [s2(1); s2(2); 1];
gleichung_2 = matrix*vector_2;
vectorHut_2 = [gleichung_2(1)/gleichung_2(3) == t2(1); gleichung_2(2)/gleichung_2(3) == t2(2)];

vector_3 = [s3(1); s3(2); 1];
gleichung_3 = matrix*vector_3;
vectorHut_3 = [gleichung_3(1)/gleichung_3(3) == t3(1); gleichung_3(2)/gleichung_3(3) == t3(2)];

vector_4 = [s4(1); s4(2); 1];
gleichung_4 = matrix*vector_4;
vectorHut_4 = [gleichung_4(1)/gleichung_4(3) == t4(1); gleichung_4(2)/gleichung_4(3) == t4(2)];


lgs =[vectorHut_1; vectorHut_2; vectorHut_3; vectorHut_4];
[a11 a12 a13 a21 a22 a23 a31 a32] = solve(lgs, [a11 a12 a13 a21 a22 a23 a31 a32]);

matrix =[a11 a12 a13; a21 a22 a23; a31 a32 1];
result = inv(matrix);