function [ind] = trouve_num_arete(F,Numaretes_int)
%renvoie le numero de l'arete F dans le tableau Numaretes_int
N = size(Numaretes_int); N = N(1);
ind =0;
for i=1:N
    F1 = Numaretes_int(i,:);
    if min(ismember(F,F1))
        ind = i;
    end
end