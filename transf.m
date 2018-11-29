function [matriz_y,matriz_y1,matriz_y2,resto] = transf(cortes)

Ncortes = size(cortes,3);
flag_par = not(mod(Ncortes,2));
matriz_y = [];
matriz_y1 = [];
matriz_y2 = [];
resto = [];

if (flag_par)
    for i = 2:2:Ncortes
        [y,y1,y2] = dec(cortes(:,:,i-1),cortes(:,:,i));
        matriz_y = cat(3,matriz_y,y);
        matriz_y1 = cat(3,matriz_y1,y1);
        matriz_y2 = cat(3,matriz_y2,y2);
    end
    
else
    for i = 2:2:Ncortes-1
        [y,y1,y2] = dec(cortes(:,:,i-1),cortes(:,:,i));
        matriz_y = cat(3,matriz_y,y);
        matriz_y1 = cat(3,matriz_y1,y1);
        matriz_y2 = cat(3,matriz_y2,y2);
    end
    resto = cortes(:,:,end);
end