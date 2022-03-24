% =====================================================
%
% principal_chaleur;
%
% une routine pour la mise en oeuvre des EF P1 Lagrange
% pour 
% 1) l'equation de la chaleur suivante stationnaire, avec condition de
% Dirichlet non homogene
%
% | \alpha T - div(\sigma \grad T)= S,   dans \Omega=\Omega_1 U \Omega_2
% |         T = T_\Gamma,   sur le bord
%
% ou S est la source de chaleur, T_\Gamma la temperature exterieure
% \alpha > 0 et
% \sigma = | \sigma_1 dans \Omega_1
%          | \sigma_2 dans \Omega_2
%
% 2) l'equation de la chaleur dependant du temps avec condition de 
% Dirichlet non homogene
%
% | dT/dt - div(\sigma \grad T)= S,   dans \Omega=\Omega_1 U \Omega_2 et pour tout t< t_max
% |         T = T_\Gamma,   sur le bord et pour tout t< t_max
% |         T = T_0       dans \Omega et pour t=0  
%
% ou S est la source de chaleur, T_\Gamma la temperature exterieure,
% T_0 est la valeur initiale de la température
% \alpha > 0 et
% \sigma = | \sigma_1 dans \Omega_1
%          | \sigma_2 dans \Omega_2
% =====================================================
% Donnees du probleme
% ---------------------------------
%h = 0.05;
%system(['gmsh -2 -clmax ' num2str(h) ' -clmin ' num2str(h) ' geomRectangle.geo']);
%nom_maillage = 'geomRectangle.msh' ;

validation = 'non';
pb_stationnaire = 'non';
pb_temporel = 'oui';


if strcmp(validation,'oui')
    alpha = 1;
    T_Gamma = 0;
end

if strcmp(pb_stationnaire,'oui')
    alpha = 1;
    T_Gamma = 290;
end

if strcmp(pb_temporel,'oui')
    Tps_initial = 0;
    Tps_final = 1;
    delta_t = 0.01;
    alpha = 1/delta_t;
    N_t = (Tps_final-Tps_initial)/delta_t; % le nombre d'iterations necessaires
    T_Gamma = 280;
end

% lecture du maillage et affichage
% ---------------------------------
%[Nbpt,Nbtri,Coorneu,Refneu,Numtri,Reftri]=lecture_msh("geomRectangle.msh");

[Nbpt,Nbtri,Coorneu,Refneu,Numtri,Reftri,Nbare,Numare,Refare]=lecture_msh("domaine.msh");

% ----------------------
% calcul des matrices EF
% ----------------------

% declarations
% ------------
KK = sparse(Nbpt,Nbpt); % matrice de rigidite
MM = sparse(Nbpt,Nbpt); % matrice de masse
LL = zeros(Nbpt,1);     % vecteur second membre

% boucle sur les triangles
% ------------------------
for l=1:Nbtri
  
  % calcul des matrices elementaires du triangle l 
  
   [Kel]=matK_elem(Coorneu(Numtri(l,1),:),Coorneu(Numtri(l,2),:),...
		       Coorneu(Numtri(l,3),:),Reftri(l));

   [Mel]=matM_elem(Coorneu(Numtri(l,1),:),Coorneu(Numtri(l,2),:),...
		       Coorneu(Numtri(l,3),:));
               
    % On fait l'assemblage de la matrice globale

    for i=1:3
      I=Numtri(l,i);
      for j=1:3
        J=Numtri(l,j);
        MM(I,J)=MM(I,J)+Mel(i,j);
        KK(I,J)=KK(I,J)+Kel(i,j);
      end
      
    end
end % for l


% Matrice EF
% -------------------------
AA = alpha*MM+KK; 

% =====================================================
% =====================================================
% Pour le probleme stationnaire et la validation
% ---------------------------------

% Calcul du second membre F
% -------------------------
FF =zeros(Nbpt,1); 
for i = 1:Nbpt
  FF(i)=f(Coorneu(i,1),Coorneu(i,2),alpha,T_Gamma);
end
LL = MM*FF;

[tilde_AA, tilde_LL] = elimine(AA, LL, Refneu);

% inversion
% ----------
UU = tilde_AA\tilde_LL;
TT = UU+T_Gamma;

% validation
% ----------
if strcmp(validation,'oui')
    UU_exact = sin(pi*Coorneu(:,1)).*sin(pi*Coorneu(:,2));
	% Calcul de l erreur L2
	err_L2 = sqrt ((UU-UU_exact)'*MM*(UU-UU_exact));
	% Calcul de l erreur H1
	err_Gr = sqrt ((UU-UU_exact)'*KK*(UU-UU_exact));
    err_H1 = norm([err_L2; err_Gr]);
end

% visualisation
% -------------
if ( strcmp(validation,'oui') || strcmp(pb_stationnaire,'oui'))
    affiche(TT, Numtri, Coorneu);
    max(TT)
end



% =====================================================
% =====================================================
% Pour le probleme temporel
% ---------------------------------
if strcmp(pb_temporel,'oui')

    % on initialise la condition initiale
    % -----------------------------------
    T_initial = zeros(Nbpt,1);
    for i=1:Nbpt
        T_initial(i) = condition_initiale(Coorneu(i,1),Coorneu(i,2));
    end
	% solution a t=0
	% --------------
    UU = T_initial -T_Gamma;
    TT = T_initial;

    % visualisation
    % -------------
    figure;
    hold on;
    affiche(TT, Numtri, Coorneu, ['Temps = ', num2str(0)]);
    axis([min(Coorneu(:,1)),max(Coorneu(:,1)),min(Coorneu(:,2)),max(Coorneu(:,2)),...
        280,345,280,345]);
    view(-76,30);
    hold off;
    pause(10)
	% Boucle sur les pas de temps
	% ---------------------------
     for k = 1:N_t
        LL_k = zeros(Nbpt,1);
        
        % Calcul du second membre F a l instant k*delta t
        FF_k=zeros(Nbpt,1);
        for i= 1: Nbpt
          FF_k(i)=f_t(Coorneu(i,1),Coorneu(i,2),k*delta_t);
        end
        % -----------------------------------------------
		% A COMPLETER EN UTILISANT LA ROUTINE f_t.m et le terme precedent (donne par UU)
		LL_k = alpha*MM*UU + MM*FF_k;

		% inversion
		% ----------
		% tilde_AA ET tilde_LL_k SONT LA MATRICE EF ET LE VECTEUR SECOND MEMBRE
		% APRES PSEUDO_ELIMINATION 
        [tilde_AA,tilde_LL_k]=elimine(AA,LL_k,Refneu);
		% ECRIRE LA ROUTINE elimine.m ET INSERER L APPEL A CETTE ROUTINE
		% A UN ENDROIT APPROPRIE
        UU = tilde_AA\tilde_LL_k;
        TT = T_Gamma+UU;

        % visualisation 
        pause(0.05)
        affiche(TT, Numtri, Coorneu, ['Temps = ', num2str(k*delta_t)]);
        axis([min(Coorneu(:,1)),max(Coorneu(:,1)),min(Coorneu(:,2)),max(Coorneu(:,2)),...
            280,345,280,345]);
        view(-77+100*k/N_t,30-24*k/N_t);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        fin de la routine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%2021