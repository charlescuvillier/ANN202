function [prod] = prod_scal_phi_FF'(F, F',K,Coorneu)

%renvoie K^{nc}_{FF'}
%on suppose que F et F' appartiennent au même simplexe

% preliminaires, pour faciliter la lecture:
S1 = F(1,:);
S2 = F(2,:);
S1'= F'(1,:);
S2' = F'(2,:);
%calcul des normales
N = [S1(2)-S2(2),S2(1)-S1(1)];
N' = [S1'(2)-S2'(2),S2'(1)-S1'(1)];

norm_F = sqrt( (S1(1)-S2(1))^2 + (S1(2)-S2(2))^2 );
norm_F' = sqrt( (S1'(1)-S2'(1))^2 + (S1'(2)-S2'(2))^2 );

norm_K = norme_simplexe(K,Coorneu);

prod = (norm_F*norm_F'/norm_K)*dot(N,N');











