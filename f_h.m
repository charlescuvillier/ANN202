function [z] = f_h(maillage, i, x, Numtri_bar, Coorbar)
% i = numéro du triangle dans Numtri_bar
x1 = Coorbar(Numtri_bar(i,1),:);
x2 = Coorbar(Numtri_bar(i,2),:);
x3 = Coorbar(Numtri_bar(i,3),:);
x_bar = (x1 + x2 + x3)/3;  %barycentre des centres des faces=barycentre des sommets
f_moy = (f(maillage,x1(1),x1(2)) + f(maillage,x2(1),x2(2)) + f(maillage,x3(1),x3(2)))/3;

z = f_moy/4 * (x - x_bar);