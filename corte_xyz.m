function corte_xyz(ptcloud,eixo)
%determina o eixo a ser cortado
tab_eixo = ['x','y','z'];
coordenada = find(tab_eixo == eixo);

%Erro se o input for invalido
if (any(tab_eixo ~= eixo))
    error('Coordenada invalida');
end

%organize as coordenadas em ordem crescente de x,y ou z
loc = sortrows(ptcloud.Location,coordenada);
    
for x=(loc(1,coordenada):loc(length(loc),coordenada))
    %estabele as coordenadas para cada ponto fixo da coordenada 
    if (eixo == 'x')     f = loc(find(loc(:,coordenada)==x),2:3);     end
    if (eixo == 'y')     f = loc(find(loc(:,coordenada)==x),1:2:3);   end
    if (eixo == 'z')     f = loc(find(loc(:,coordenada)==x),1:2);     end

    %laço que varre todas as coordenadas de determinado eixo e marca como 1
    %na matriz G=512x512
    g = zeros(512:512);
    for i = 1:size(f,1)
    g(f(i,1)+1,f(i,2)+1) = 1;
    end
    
    %salva as imagens dos cortes transversais
    g = not(g);
    imwrite(g, ['corte_' eixo '=' num2str(x) '.jpeg']);
end