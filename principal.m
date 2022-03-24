% Donnees du probleme.
nom_maillage = 'geomCarre.msh';
affichage = true; % false; %

% Lecture du maillage et affichage.
[Nbpt, Nbtri, Coorneu, Refneu, Numtri, Reftri,Nbaretes,Numaretes,Refaretes] = lecture_msh(nom_maillage);

%affichemaillage(nom_maillage);

%Numaretes donne le num des deux points definisants une arete du bord
Numaretes_int = aretes_int(Numaretes,Numtri); % contient les aretes interieures
Nbaretes_int = size(Numaretes_int); Nbaretes_int  = Nbaretes_int(1);
%Les coordonnees des barycentres de chaque arete:
Coorbar = Coor_barycentres(Coorneu,Numaretes_int,Numaretes);
%les numeros des barycentres de chaque triangle:
Numtri_bar = Bary_tri(Numtri,Coorneu,Coorbar);

% declarations
% ------------
KK_int = sparse(Nbaretes_int,Nbaretes_int); % matrice de rigidite
LL_int = zeros(Nbaretes_int,1);     % vecteur second membre


%___________ calcul des matrices ___________

%   Matrice KK_int

for i=1:Nbaretes_int
    %on cherche les 2 simplexes qui contiennent l'arete
    F_i = Numaretes_int(i,:);
    KK = trouve_simplexes(F_i,Numtri);
    K1 = KK(1,:); K2 = KK(2,:);
    %premiere face
    F = K1(1:2);
    ind = trouve_num_arete(F',Numaretes_int);
    if ~(ind ==0) %si ind vaut 0 F' est une arete du bord
        KK_int(i,ind)= KK_int(i,ind) + prod_scal_phi_FF2(F_i,F,K1,Coorneu);
    end
    %deuxieme face
    F = [K1(2) K1(3)];
    ind = trouve_num_arete(F',Numaretes_int);
    if ~(ind ==0) %si ind vaut 0 F' est une arete du bord
        KK_int(i,ind)=KK_int(i,ind) + prod_scal_phi_FF2(F_i,F,K1,Coorneu);
    end
    %troisieme face
    F = [K1(3) K1(1)];
    ind = trouve_num_arete(F,Numaretes_int);
    if ~(ind ==0) %si ind vaut 0 F' est une arete du bord
        KK_int(i,ind)=KK_int(i,ind) + prod_scal_phi_FF2(F_i,F,K1,Coorneu);
    end
    %premiere face de K2
    F = [K2(1) K2(2)];
    ind = trouve_num_arete(F,Numaretes_int);
    if ~(ind ==0) %si ind vaut 0 F' est une arete du bord
        KK_int(i,ind)=KK_int(i,ind) + prod_scal_phi_FF2(F_i,F,K2,Coorneu);
    end
    %deuxieme face de K2
    F = [K2(2) K2(3)];
    ind = trouve_num_arete(F,Numaretes_int);
    if ~(ind ==0) %si ind vaut 0 F' est une arete du bord
        KK_int(i,ind)=KK_int(i,ind) + prod_scal_phi_FF2(F_i,F,K2,Coorneu);
    end
    %troisieme face de K2
    F = [K2(3) K2(1)];
    ind = trouve_num_arete(F',Numaretes_int);
    if ~(ind ==0) %si ind vaut 0 F' est une arete du bord
        KK_int(i,ind)=KK_int(i,ind) + prod_scal_phi_FF2(F_i,F,K2,Coorneu);
    end
end



%   matrice LL_int
for i=1:Nbaretes_int
    F_i = Numaretes_int(i,:);
    KK = trouve_simplexes(F_i,Numtri);
    K1 = KK(1,:); K2 = KK(2,:);
    x1 = Coorneu(F_i(1),:);
    x2 = Coorneu(F_i(2),:);
    x_f = (x1 + x2)/2;
    norm_K1 = norme_simplexe(K1,Coorneu);
    norm_K2 = norme_simplexe(K2,Coorneu);
    LL_int(i) = (1/3)*(norm_K1 + norm_K2)*f(x_f(1),x_f(2));
end
%resolution 
UU_bar = KK_int\LL_int;
UU_bar = [UU_bar;zeros(Nbaretes,1)];
[UU_som,Coorneu2] = Bar_to_neu(UU_bar,Coorneu,Coorbar,Numtri);
affiche(UU_som, Numtri, Coorneu2, sprintf('Neumann - %s', nom_maillage));

%solution exacte
UU_sol = zeros(size(Coorbar,[1]),1);
for i=1:Nbaretes_int+Nbaretes
    x=Coorbar(i,1);y=Coorbar(i,2);
    UU_sol(i) = sin(pi*y)*sin(pi*x);
end
[UU_solus,Coorneu3] = Bar_to_neu(UU_sol,Coorneu,Coorbar,Numtri);
affiche(UU_solus, Numtri_bar, Coorneu3, sprintf('Neumann - %s', nom_maillage));

%Calcul de l'erreur
%erreur ||u-uh|| :
erreur_H1= sqrt((UU_sol-UU_som)'*KK_int*(UU_sol-UU_som));




