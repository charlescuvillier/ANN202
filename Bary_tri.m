function[Numtri_bar] = Bary_tri(Numtri,Coorneu, Coorbar)

%renvoie un tableau similaire a Numtri sauf que les points retournes
%sont les barycentres des aretes

Nbtri = size(Numtri,[1]);

Numtri_bar = zeros(Nbtri,3);

for i=1:Nbtri
    S1 = Coorneu(Numtri(i,1),:);
    S2 = Coorneu(Numtri(i,2),:);
    S3 = Coorneu(Numtri(i,3),:);
    x1= (S2+S1)/2;
    x2= (S3+S2)/2;
    x3= (S3+S1)/2;
    ind1 = trouve_indice_bar(Coorbar,x1);
    ind2 = trouve_indice_bar(Coorbar,x2);
    ind3 = trouve_indice_bar(Coorbar,x3);
    Numtri_bar(i,1)=ind1;
    Numtri_bar(i,2)=ind2;
    Numtri_bar(i,3)=ind3;
end