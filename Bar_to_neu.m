function [UU_som,Coorneu2,Numtri2] = Bar_to_neu(UU_bar,Coorneu,Coorbar,Numtri)

UU_som = zeros(3*size(Numtri,[1]),1);
Coorneu2 = zeros(3*size(Numtri,[1]),2);
Numtri2 = zeros(size(Numtri));

for i=1:size(Numtri,(1))
    for j=1:3
        Coorneu2(3*(i-1)+j,:) = Coorneu(Numtri(i,j),:);
        Numtri2(i,j) = 3*(i-1)+j;
    end 
    b1 = (Coorneu(Numtri(i,1),:) + Coorneu(Numtri(i,2),:))/2;
    b2 = (Coorneu(Numtri(i,2),:) + Coorneu(Numtri(i,3),:))/2;
    b3 = (Coorneu(Numtri(i,3),:) + Coorneu(Numtri(i,1),:))/2;
    i1 = trouve_indice_bar(Coorbar,b1);
    i2 = trouve_indice_bar(Coorbar,b2);
    i3 = trouve_indice_bar(Coorbar,b3);
    UU_som(3*(i-1)+1) = UU_bar(i1) - UU_bar(i2) + UU_bar(i3);
    UU_som(3*(i-1)+2) = UU_bar(i1) + UU_bar(i2) - UU_bar(i3);
    UU_som(3*(i-1)+3) =-UU_bar(i1) + UU_bar(i2) + UU_bar(i3);
end