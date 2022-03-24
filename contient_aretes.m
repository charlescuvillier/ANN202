function[bool] = contient_aretes(F,Numaretes)
%renvoie true si la face F est dans l'ensemble d'aretes Numaretes
N = size(Numaretes);
bool = 1;
for i=1:N(1)
    bool = bool * max(~ismember(F,Numaretes(i,:)));
end
bool = ~bool;
