function cortes = inv_transf(y,y1,y2,resto)

%estabelece numero de cortes
Ncortes=size(y,3);
cortes=[];

%varre os cortes recuperando os originais
for i = 1:Ncortes
    [x1,x2] = rec(y(:,:,i),y1(:,:,i),y2(:,:,i));
    cortes = cat(3,cortes,x1);
    cortes = cat(3,cortes,x2);
end

if (size(resto,1) > 1)
    cortes = cat(3,cortes,resto);
end

