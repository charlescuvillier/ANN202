function [ind] = trouve_indice_bar(Coorbar, x)

ind =0;
Nbpts = size(Coorbar,[1]);

for i=1:Nbpts
    if min(x == Coorbar(i,:))
        ind = i;
    end
end

