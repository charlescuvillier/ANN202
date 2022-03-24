function[bool] = contient_aretes_orientee(F,Numaretes)
%renvoie true si la face F est dans l'ensemble d'aretes Numaretes
bool = 0;

for i=1:size(Numaretes,[1])
    if (F == Numaretes(i,:))
        bool = 1;
    else
        if (F == [Numaretes(i,2) Numaretes(i,1)])
            bool = 2;
        end
    end
end