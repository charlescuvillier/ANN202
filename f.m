function [z] =f(maillage,x,y)

switch maillage
    case 1
        z = 2*pi^2*sin(pi*x)*sin(pi*y);
    case 2
        z = 0;
end