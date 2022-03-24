function [Numaretes_int] = aretes_int(Numaretes,Numtri)

A = size(Numaretes); 
nb_Fext = A(1);  % nb_Fint represente le nombre d'arete sur le bord
A = size(Numtri) ; 
nb_K = A(1); %nb_K represente le nombre de simplexe
nb_Fint = (3*nb_K - nb_Fext)/2; %represente le nombre d'arete interieur

%On veut construire Numaretes_int (definition similaire a Numaretes)
Numaretes_int = zeros(1,2); 


for i=1:nb_K
    %les faces du simplexe :
    F1 = [Numtri(i,1) Numtri(i,2)];
    F2 = [Numtri(i,2) Numtri(i,3)];
    F3 = [Numtri(i,3) Numtri(i,1)];
    if ~contient_aretes(F1,Numaretes_int)* ~contient_aretes(F1,Numaretes)
        Numaretes_int =[Numaretes_int ;F1];        
    end
    if ~contient_aretes(F2,Numaretes_int)* ~contient_aretes(F2,Numaretes)
        Numaretes_int =[Numaretes_int ;F2];
    end
    if ~contient_aretes(F3,Numaretes_int)* ~contient_aretes(F3,Numaretes)
        Numaretes_int =[Numaretes_int ;F3];        
    end
end
Numaretes_int = Numaretes_int(2:end ,1:2);