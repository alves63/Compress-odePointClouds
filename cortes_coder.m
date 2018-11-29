function bytestream = cortes_coder(cortes)
bitstream = '';

%VARIAVEIS PARA CONTROLE E DEBUG----------------------------------------
metodo_AB = 0; %para contar quantas vezes escolhi o metodo A e B
metodo_Y = 0;  %para contar quantas vezes escolhi o metodo Y

%----------------------------------------------------------------------

%descobre a partir de qual corte tem pixel
lado = size(cortes,1);
inicio = 1;
fim = lado;
for i = 1:lado
    if sum(sum(cortes(:,:,i))) ~= 0
        inicio = i;
        break;
    end
end
for i = lado:-1:1
    if sum(sum(cortes(:,:,i))) ~= 0
        fim = i;
        break;
    end
end

%estabelece os cortes e matrizes de transferencia Y,Y1,Y2
Ncortes = fim-inicio+1;
flag_par = mod(Ncortes,2);

for corte_n = inicio:2:fim-flag_par    
    A = cortes(:,:,corte_n);
    B = cortes(:,:,corte_n+1);
    [Y,Y1,Y2] = dec(A,B);
    
    %varre o Y para encontrar os valores onde Y=1;
    cont = 1;
    P = zeros(sum(Y(:)==1),2);
    for i = 1:size(Y,1)
        for j = 1:size(Y,2)
            if Y(i,j) == 1;
                P(cont,:) = [i j];
                cont = cont+1;
            end
        end
    end

    %cria o bitstream dos bits em Y1 e Y2
    cont = 1;
    N1 = zeros(1,size(P,1));
    N2 = zeros(1);
    for i = 1:size(P,1)
        N1(i) = Y1(P(i,1),P(i,2));
        if N1(i) == 0;
            N2(cont) = Y2(P(i,1),P(i,2));
            cont = cont+1;
        end
    end
   
    %cria o header de tamanho para N1 e N2
    len_N1 = dec2bin(length(N1),16);
    len_N2 = dec2bin(length(N2),16);
    N1 = [len_N1 dec2bin(N1,1)'];
    N2 = [len_N2 dec2bin(N2,1)'];

    %codifica o corte A
    imwrite(A, 'tmp.pbm');
    !pbmtojbg tmp.pbm -q tmp.jbg
    fid = fopen('tmp.jbg');
    [stream,sz] = fread(fid);
    a{1,1} = sz;
    a{1,2} = stream;
    fclose(fid);

    %codifica o corte B
    imwrite(B, 'tmp.pbm');
    !pbmtojbg tmp.pbm -q tmp.jbg
    fid = fopen('tmp.jbg');
    [stream,sz] = fread(fid);
    a{2,1} = sz;
    a{2,2} = stream;
    fclose(fid);

    %codifica o corte Y
    imwrite(Y, 'tmp.pbm');
    !pbmtojbg tmp.pbm -q tmp.jbg
    fid = fopen('tmp.jbg');
    [stream,sz] = fread(fid);
    a{3,1} = sz;
    a{3,2} = stream;
    fclose(fid);

    %armazena os pesos totais
    peso_total_YY1Y2 = a{3,1}*8+length(N1)+length(N2);
    peso_total_AB = a{1,1}*8+a{2,1}*8;

    %checa qual metodo obteve melhor compressão e o utiliza
    %caso A e B ocupem menos:
    if peso_total_AB <= peso_total_YY1Y2
        %------------------------------------------------------------
        metodo_AB = metodo_AB+1; %para fins de analise
        %------------------------------------------------------------
        
        st = dec2bin(a{1,2})';
        st = reshape(st,[1 8*length(st)]);
        bitstream = [bitstream '1' dec2bin(a{1,1},11) st];
        st = dec2bin(a{2,2})';
        st = reshape(st,[1 8*length(st)]);
        bitstream = [bitstream dec2bin(a{2,1},11) st];
    end

    %caso Y,Y1 e Y2 ocupem menos:
    if peso_total_AB > peso_total_YY1Y2
        %------------------------------------------------------------
        metodo_Y = metodo_Y+1; %para fins de analise
        %------------------------------------------------------------
        
        st = dec2bin(a{3,2})';
        st = reshape(st,[1 8*length(st)]);
        bitstream = [bitstream '0' dec2bin(a{3,1},11) st];
        bitstream = [bitstream N1];
        bitstream = [bitstream N2];
    end
end

%caso exista um número ímpar de frames, apenas passa jbig no ultimo
if (flag_par == 1)
     A = cortes(:,:,fim);
     imwrite(A, 'tmp.pbm');
    !pbmtojbg tmp.pbm -q tmp.jbg
    fid = fopen('tmp.jbg');
    [stream,sz] = fread(fid);
    st = dec2bin(stream)';
    st = reshape(st,[1 8*length(st)]);
    bitstream = [bitstream dec2bin(sz,11) st];
end

%Cria o bytestream final a ser enviado
bytestream = bit2bytestream(bitstream);
%coloca o size/inicio/fim do corte como primeiro header
inicio = dec2bin(inicio,16);
inicio1 = bin2dec(inicio(1:8));
inicio2 = bin2dec(inicio(9:16));
fim = dec2bin(fim,16);
fim1 = bin2dec(fim(1:8));
fim2 = bin2dec(fim(9:16));
bytestream = [log2(lado) inicio1 inicio2 fim1 fim2 bytestream];
bytestream = uint8(bytestream);
