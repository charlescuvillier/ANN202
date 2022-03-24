function [prod] = prod_scal_phi_FF(F, F1,K,Coorneu)

%renvoie K^{nc}_{FF1}
%on suppose que F et F1 appartiennent au même simplexe K

%calcul des orientations des faces dans K
or_F = 1;
if (min(F == [K(1) K(3)])) | (min(F == [K(3) K(2)])) | (min(F == [K(2) K(1)]))
        or_F = -1;
end
or_F1 = 1;
if (min(F1 == [K(1) K(3)])) | (min(F1 == [K(3) K(2)])) | (min(F1 == [K(2) K(1)]))
        or_F1 = -1;
end

%on s'assure que les faces aient la même orientation 
%pour que le produit scalaire des normales soit du même
%signe que le produit scalaire des faces

if or_F * or_F1 == -1
    F = [F(2) F(1)]
end

S1 = Coorneu(F(1),:);
S2 = Coorneu(F(2),:);
S11= Coorneu(F1(1),:);
S21= Coorneu(F1(2),:);

norm_K = norme_simplexe(K,Coorneu);

prod = (1/norm_K)*dot(S2-S1,S21-S11);











