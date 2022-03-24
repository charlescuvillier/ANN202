function [K1, K2] = trouve_simplexes(F,Numtri)
%trouve les simplexes comportant la face F

Ntri = size(Numtri);Ntri = Ntri(1);

K1 = zeros(1,3);
K2 = zeros(1,3);


test = true;
for i=1:Ntri
    K = Numtri(i,:);
    if contient(F,K) 
        if test 
            K1 = K;
            test = false;
        else 
            K2 = K;
        end
    end
end
