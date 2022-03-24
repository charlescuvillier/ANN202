function [Kel] = matK_elem_FF'(K, K')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mat_elem :
% calcul la matrices de raideur elementaire entre deux simplexes K et K'
%
% 
%          
% INPUT * F1, F2 : l'indice de 2 faces (une face est un ensemble de 2 points)
%
% OUTPUT - un scalaire
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% preliminaires, pour faciliter la lecture:
S1 = F(1,:);
S2 = F(2,:);
S1'= F'(1,:);
S2' = F'(2,:);
%calcul des normales
N = [S1(2)-S2(2),S2(1)-S1(1)];
N' = [S1'(2)-S2'(2),S2'(1)-S1'(1)];

%calcul de l'aire des simplexes

%calcul de la longueur de chaque arete

% les 3 normales a l'arete opposees (de la longueur de l'arete)
norm = zeros(3, 2);
norm(1, :) = [y2-y3, x3-x2];
norm(2, :) = [y3-y1, x1-x3];
norm(3, :) = [y1-y2, x2-x1];

% D est, au signe pres, deux fois l'aire du triangle
D = ((x2-x1)*(y3-y1) - (y2-y1)*(x3-x1));
if (abs(D) <= eps) 
  error('l aire d un triangle est nulle!!!'); 
end;


% calcul de la matrice de raideur
% -------------------------------
Kel = zeros(3,3);
for i=1:3
  for j=1:3
	% A COMPLETER
    Kel(i,j) = 
  end; % j
end; % i

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        fin de la routine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%2021
