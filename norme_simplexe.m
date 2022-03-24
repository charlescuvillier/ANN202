function [normeK] = norme_simplexe(K,Coorneu)

%D est, au signe pres, deux fois l'aire du triangle
%D = ((x2-x1)*(y3-y1) - (y2-y1)*(x3-x1));

S1 = Coorneu(K(1),:);
S2 = Coorneu(K(2),:);
S3 = Coorneu(K(3),:);

x1=S1(1); y1=S1(2);
x2=S2(1); y2=S2(2);
x3=S3(1); y3=S3(2);

D = ((x2-x1)*(y3-y1) - (y2-y1)*(x3-x1));

normeK = abs(D)/2;
