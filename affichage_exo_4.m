function [err_tri2,Numtri2,Coorneu2] = affichage_exo_4(err_tri,Coorneu,Numtri)

N = size(Numtri,[1]);

Coorneu2 = zeros(3*N,2);
Numtri2 = zeros(size(Numtri));
err_tri2 = zeros(3*N,1);

for i=1:N
    for j=1:3
        Coorneu2(3*(i-1)+j,:) = Coorneu(Numtri(i,j),:);
        Numtri2(i,j) = 3*(i-1)+j;
        err_tri2(3*(i-1) +j) = err_tri(i);
    end
end


