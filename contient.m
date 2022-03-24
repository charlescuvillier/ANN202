function [bool] = contient (F,K)

%indique si l'arete F appartient au triangle K
%K est compose du 3 entiers donnant la reference au sommet
%F est compose de 2 entiers donnant la reference au sommet

res = ismember(F,K);
bool = (res(1) == 1 & res(1,2)==1 );
        
