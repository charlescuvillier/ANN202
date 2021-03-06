function [prod] = prod_scal_phi_FF2(F, F1,K,Coorneu)
%renvoie K^{nc}_{FF1}
%on suppose que F et F1 appartiennent au même simplexe

% preliminaires, pour faciliter la lecture:
S1 = Coorneu(F(1),:);
S2 = Coorneu(F(2),:);
S11= Coorneu(F1(1),:);
S21= Coorneu(F1(2),:);

%calcul des normales
N = [S1(2)-S2(2),S2(1)-S1(1)];
N = N/norm(N);
N1 = [S11(2)-S21(2),S21(1)-S11(1)];
N1=N1/norm(N1);


norm_F = norm(S1-S2);
norm_F1 = norm(S11 - S21);

norm_K = norme_simplexe(K,Coorneu);

prod = (norm_F*norm_F1/norm_K^2)*dot(N,N1);











