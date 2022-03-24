function [z] = u_bord(maillage,x,y)

switch maillage
    case 1
        z = 0;
    case 2
        theta = atan2(y,x); %retourne l'angle entre ]-pi,pi]
        if theta<0
            theta = theta + 2*pi; %angle entre [0,2pi[
        end
        z= (x^2 +y^2)^(1/3)*sin(2*theta/3);
end