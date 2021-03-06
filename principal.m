close();

% Donnees du probleme.
maillage = 2; % 1 = carré ; 2 = Dirichlet non homogène

switch maillage
    case 1
        nom_maillage = 'geomCarre.msh';
    case 2
        nom_maillage = 'geom.msh';
end
affichage = true;

% Lecture du maillage et affichage.
[Nbpt, Nbtri, Coorneu, Refneu, Numtri, Reftri,Nbaretes,Numaretes,Refaretes] = lecture_msh(nom_maillage);

%affichemaillage(nom_maillage);

%Numaretes donne le num des deux points definisants une arete du bord
Numaretes_int = aretes_int(Numaretes,Numtri); % contient les aretes interieures
Nbaretes_int = size(Numaretes_int,[1]);
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
    [K1,K2] = trouve_simplexes(F_i,Numtri);
    %premiere face
    F = K1(1:2);
    ind = trouve_num_arete(F,Numaretes_int);
    if (ind ~=0) %si ind vaut 0 F' est une arete du bord
        KK_int(i,ind)= KK_int(i,ind) + prod_scal_phi_FF(F_i,F,K1,Coorneu);
    end
    %deuxieme face
    F = [K1(2) K1(3)];
    ind = trouve_num_arete(F,Numaretes_int);
    if (ind ~=0) %si ind vaut 0 F' est une arete du bord
        KK_int(i,ind)=KK_int(i,ind) + prod_scal_phi_FF(F_i,F,K1,Coorneu);
    end
    %troisieme face
    F = [K1(3) K1(1)];
    ind = trouve_num_arete(F,Numaretes_int);
    if (ind ~=0) %si ind vaut 0 F' est une arete du bord
        KK_int(i,ind)=KK_int(i,ind) + prod_scal_phi_FF(F_i,F,K1,Coorneu);
    end
    %premiere face de K2
    F = [K2(1) K2(2)];
    ind = trouve_num_arete(F,Numaretes_int);
    if (ind ~=0) %si ind vaut 0 F' est une arete du bord
        KK_int(i,ind)=KK_int(i,ind) + prod_scal_phi_FF(F_i,F,K2,Coorneu);
    end
    %deuxieme face de K2
    F = [K2(2) K2(3)];
    ind = trouve_num_arete(F,Numaretes_int);
    if (ind ~=0) %si ind vaut 0 F' est une arete du bord
        KK_int(i,ind)=KK_int(i,ind) + prod_scal_phi_FF(F_i,F,K2,Coorneu);
    end
    %troisieme face de K2
    F = [K2(3) K2(1)];
    ind = trouve_num_arete(F,Numaretes_int);
    if (ind ~=0) %si ind vaut 0 F' est une arete du bord
        KK_int(i,ind)=KK_int(i,ind) + prod_scal_phi_FF(F_i,F,K2,Coorneu);
    end
    
end

%   Matrice KK_int_ext

if maillage == 2
    KK_int_ext = sparse(Nbaretes_int,Nbaretes);
    for i=1:Nbaretes
        F_i = Numaretes(i,:);
        [K1,K2] = trouve_simplexes(F_i,Numtri);
        %premiere face
        F = K1(1:2);
        ind = trouve_num_arete(F,Numaretes_int);
        if (ind ~=0) %ind vaut 0 si F est une arete du bord ie F = F_i
            KK_int_ext(ind,i) = prod_scal_phi_FF(F_i,F,K1,Coorneu);
        end
        %deuxieme face
        F = [K1(2) K1(3)];
        ind = trouve_num_arete(F,Numaretes_int);
        if (ind ~=0) %ind vaut 0 si F est une arete du bord ie F = F_i
            KK_int_ext(ind,i) = prod_scal_phi_FF(F_i,F,K1,Coorneu);
        end
        %troisieme face
        F = [K1(3) K1(1)];
        ind = trouve_num_arete(F,Numaretes_int);
        if (ind ~=0) %ind vaut 0 si F est une arete du bord ie F = F_i
            KK_int_ext(ind,i) = prod_scal_phi_FF(F_i,F,K1,Coorneu);
        end
    end
end

%   matrice LL_int
switch maillage
    case 1
        for i=1:Nbaretes_int
            F_i = Numaretes_int(i,:);
            [K1, K2] = trouve_simplexes(F_i,Numtri);
            x1 = Coorneu(F_i(1),:);
            x2 = Coorneu(F_i(2),:);
            x_f = (x1 + x2)/2;
            norm_K1 = norme_simplexe(K1,Coorneu);
            norm_K2 = norme_simplexe(K2,Coorneu);
            LL_int(i) = (1/3)*(norm_K1 + norm_K2)*f(maillage,x_f(1),x_f(2));
        end
    case 2
        UU_bord = zeros(Nbaretes,1);
        for i=1:Nbaretes
            x=Coorbar(Nbaretes_int+i,1);y=Coorbar(Nbaretes_int+i,2);
            UU_bord(i) = u_bord(maillage,x,y);
        end
        LL_int = - KK_int_ext * UU_bord;
end
       
%resolution 
UU_int = KK_int\LL_int;

%on calcule la solution approchée sur le bord
UU_ext = zeros(Nbaretes,1);
for i=1:Nbaretes
    x=Coorbar(Nbaretes_int+i,1);y=Coorbar(Nbaretes_int+i,2);
    UU_ext(i) = u_bord(maillage,x,y);
end

 UU_bar = [UU_int;UU_ext];
[UU_som,Coorneu2,Numtri2] = Bar_to_neu(UU_bar,Coorneu,Coorbar,Numtri);
affiche(UU_som, Numtri2, Coorneu2, sprintf('Solution approchée - %s', nom_maillage));

%solution exacte pour le calcul de l'erreur
UU_ex_bar = zeros(size(Coorbar,[1]),1);
for i=1:Nbaretes_int+Nbaretes
    x=Coorbar(i,1);y=Coorbar(i,2);
     UU_ex_bar(i) = u_exact(maillage,x,y);
end
%solution exacte pour l'affichage
UU_ex_som = zeros(Nbpt,1);
for i=1:Nbpt
    x=Coorneu(i,1);y=Coorneu(i,2);
     UU_ex_som(i) = u_exact(maillage,x,y);
end

affiche(UU_ex_som, Numtri, Coorneu, sprintf('Solution exacte - %s', nom_maillage));

%Calcul de l'erreur
%erreur ||u-uh|| :

erreur_H1= sqrt((UU_ex_bar(1:Nbaretes_int)-UU_bar(1:Nbaretes_int))'*KK_int*(UU_ex_bar(1:Nbaretes_int)-UU_bar(1:Nbaretes_int)));
%cardinal de V^nc_h1 :
Nbaretes_int
erreur_H1

%reconstruction du potentiel
%Sh pour l'affichage
Sh = zeros(Nbpt,1);
Card_Tx = zeros(Nbpt,1); %nombre de triangles contenant le sommet x

for i=1:size(Numtri,[1])
    for j=1:3
        if Refneu(Numtri(i,j)) == 0  %points intérieurs
            Sh(Numtri(i,j)) = Sh(Numtri(i,j)) + UU_som(3*(i-1)+j);
            Card_Tx(Numtri(i,j)) = Card_Tx(Numtri(i,j)) + 1;
        end
    end
end
for i=1:Nbpt 
    if Sh(i) ~= 0   %Sh(i)~=0 implique Card_Tx ~= 0   
        Sh(i) = Sh(i)/Card_Tx(i);
    else        %sur le bord, le potentiel est égal à la condition de Dirichlet
        Sh(i) = u_bord(maillage,Coorneu(i,1),Coorneu(i,2));
    end
end

affiche(Sh, Numtri, Coorneu, sprintf('Reconstruction du potentiel - %s', nom_maillage));

%Sh pour le calcul de l'erreur
Sh_bar = zeros(Nbaretes_int,1); 
for i=1:Nbaretes_int
    Sh_bar(i) = (Sh(Numaretes_int(i,1))+Sh(Numaretes_int(i,2)))/2;
end

%erreur du potentiel reconstruit
err_pot = sqrt((Sh_bar-UU_bar(1:Nbaretes_int))'*KK_int*(Sh_bar-UU_bar(1:Nbaretes_int)));


%reconstruction du flux équilibré
sigma = zeros(3*Nbtri,2);
for i=1:Nbtri
    x1 = Coorneu(Numtri(i,1));
    x2 = Coorneu(Numtri(i,2));
    x3 = Coorneu(Numtri(i,3));
    x_bar = (x1 + x2 + x3)/3;
    for j=1:3

    end
end


%estimations d'erreurs à posteriori
%erreur flux
err_flux_tri = zeros(Nbtri,1);
for i=1:Nbtri
    x1 = Coorbar(Numtri_bar(i,1),:);
    x2 = Coorbar(Numtri_bar(i,2),:);
    x3 = Coorbar(Numtri_bar(i,3),:);
    x_bar = (x1 + x2 + x3)/3;  %barycentre des centres des faces=barycentre des sommets
    f_moy = (f(maillage,x1(1),x1(2)) + f(maillage,x2(1),x2(2)) + f(maillage,x3(1),x3(2)))/3;
    err_flux_tri(i) = sqrt( f_moy/12 *(dot(x1-x_bar,x1-x_bar) + dot(x2-x_bar,x2-x_bar) + dot(x3-x_bar,x3-x_bar)));
end

err_flux = norm(err_flux_tri);
%erreur du potentiel
err_pot_tri = zeros(Nbtri,1);

for i=1:Nbtri
    K = Numtri_bar(i,:);
    KK = [KK_int zeros(Nbaretes_int,Nbaretes) ; zeros(Nbaretes,Nbaretes_int) zeros(Nbaretes,Nbaretes)];
    Sh_U = [Sh_bar; zeros(Nbaretes,1)] - UU_bar;
    Sh_U_K = Sh_U([K(1),K(2),K(3)]);
    KK_K = KK([K(1),K(2),K(3)],[K(1),K(2),K(3)]);
    err_pot_tri(i) = sqrt( (Sh_U_K)'*KK_K*Sh_U_K );
end


%erreur H1
err_H1 = zeros(Nbtri,1);

for i=1:Nbtri
    K = Numtri_bar(i,:);
    KK = [KK_int zeros(Nbaretes_int,Nbaretes) ; zeros(Nbaretes,Nbaretes_int) zeros(Nbaretes,Nbaretes)];
    U_Uh_K = UU_ex_bar([K(1),K(2),K(3)])-UU_bar([K(1),K(2),K(3)]);
    KK_K = KK([K(1),K(2),K(3)],[K(1),K(2),K(3)]);
    err_H1(i) = sqrt( (U_Uh_K)'*KK_K*U_Uh_K );
end
%err_flux

eta_tri = (err_pot_tri.^2 + err_flux_tri.^2).^(0.5);
eta = norm(eta_tri);

[eta_tri2,Numtri2,Coorneu2] = affichage_exo_4(eta_tri,Coorneu,Numtri);

affiche(eta_tri2, Numtri2, Coorneu2, sprintf('Eta par triangle - %s',  nom_maillage));

[err_H1_2,Numtri2,Coorneu2] = affichage_exo_4(err_H1,Coorneu,Numtri);

affiche(err_H1_2, Numtri2, Coorneu2, sprintf('Erreur H1 par triangle - %s',  nom_maillage));