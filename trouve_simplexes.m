function [KK] = trouve_simplexes(F,Numtri)
%trouve les simplexes comportant la face F

Ntri = size(Numtri);Ntri = Ntri(1);

KK = zeros(2,3);
j=1;
for i=1:Ntri
    K = Numtri(i,:);
    if contient(F,K)
        KK(j,:) = K;
        
        j=j+1;
    end
end
