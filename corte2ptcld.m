function ptcld = corte2ptcld(cortes,eixo)

%determina o eixo de recuperação
tab_eixo = ['x','y','z'];
coordenada = find(tab_eixo == eixo);

%Erro se o input for invalido
if (~any(tab_eixo == eixo))
    error('Coordenada invalida');
end

ptcld = [];
%varre todos os cortes
for k=1:size(cortes,3)
    %encontra onde temos pixel
    [linha,coluna] = find(cortes(:,:,k)==1); 
    m = 0;
    m(1:length(linha),1) = k;
    if isempty(linha)
        m = [];
    end
    if eixo == 'x'  ptcld = [ptcld;m-1 coluna-1 linha-1]; end
    if eixo == 'y'  ptcld = [ptcld;linha-1 m-1 coluna-1]; end
    if eixo == 'z'  ptcld = [ptcld;coluna-1 linha-1 m-1]; end
end
            