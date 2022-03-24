function [Coorbar] = Coor_barycentres(Coorneu,Numaretes_int,Numaretes)

Coorbar = zeros( size(Numaretes,[1]) + size(Numaretes_int,[1]),2 );

for i=1:size(Numaretes_int,[1])
    Coorbar(i,:) = (Coorneu(Numaretes_int(i,1),:) + Coorneu(Numaretes_int(i,2),:) )/2;
end

for i=1:size(Numaretes,[1])
    Coorbar(size(Numaretes_int,[1]) + i,:) = (Coorneu(Numaretes(i,1),:) + Coorneu(Numaretes(i,2),:) )/2;
end