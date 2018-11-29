function cortes = cortes_deco(bytestream)
bytestream = double(bytestream);

%remove o primeiro header (lado do corte)
lado = 2^bytestream(1);
inicio1 = bytestream(2);
inicio2 = bytestream(3);
inicio = bin2dec(strcat(dec2bin(inicio1,8),dec2bin(inicio2,8)));
fim1 = bytestream(4);
fim2 = bytestream(5);
fim = bin2dec(strcat(dec2bin(fim1,8),dec2bin(fim2,8)));
bytestream = bytestream(6:end);

%transforma em bitstream para manipulações
bitstream = byte2bitstream(bytestream);

%Retira primeiro header(numero de cortes)
Ncortes = fim-inicio+1;
flag_par = mod(Ncortes,2);

cortes = zeros(lado,lado,lado);
%laço para recuperar cortes
for corte_n = inicio:2:fim-flag_par 
    
    %checa o metodo utilizado (AB ou Y,Y1,Y2)
    flag_metodo = str2num(bitstream(1));
    bitstream = bitstream(2:end);
    
    %Método AB
    if flag_metodo == 1
        len = bin2dec(bitstream(1:11))*8;
        bitstream = bitstream(12:end);
        stream = bit2bytestream(bitstream(1:len));
        %remove o header
        stream = stream(2:end);
        bitstream = bitstream(len+1:end);
        
        %recupera corte A
        fid = fopen('tmp.jbg','wb');
        fwrite(fid,stream);
        fclose(fid);
        !jbgtopbm.exe tmp.jbg tmp.pbm
        cortes(:,:,corte_n) = imread('tmp.pbm');
        
        len = bin2dec(bitstream(1:11))*8;
        bitstream = bitstream(12:end);
        stream = bit2bytestream(bitstream(1:len));
        %remove o header
        stream = stream(2:end);
        bitstream = bitstream(len+1:end);
        
        %recupera corte B
        fid = fopen('tmp.jbg','wb');
        fwrite(fid,stream);
        fclose(fid);
        !jbgtopbm.exe tmp.jbg tmp.pbm
        cortes(:,:,corte_n+1) = imread('tmp.pbm');
    end
    
    %Método Y,Y1,Y2
    if flag_metodo == 0
        len = bin2dec(bitstream(1:11))*8;
        bitstream = bitstream(12:end);
        stream = bit2bytestream(bitstream(1:len));
        %remove o header
        stream = stream(2:end);
        bitstream = bitstream(len+1:end);
        
        %recupera Y
        fid = fopen('tmp.jbg','wb');
        fwrite(fid,stream);
        fclose(fid);
        !jbgtopbm.exe tmp.jbg tmp.pbm
        Y = imread('tmp.pbm');
        
        %recupera N1
        N1_len = bin2dec(bitstream(1:16));
        bitstream = bitstream(17:end);
        N1 = bitstream(1:N1_len);
        bitstream = bitstream(N1_len+1:end);
        N1 = bin2dec(N1(:))';
        
        %recupera N2
        N2_len = bin2dec(bitstream(1:16));
        bitstream = bitstream(17:end);
        N2 = bitstream(1:N2_len);
        bitstream = bitstream(N2_len+1:end);
        N2 = bin2dec(N2(:))';
        
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
        
        %Reformula a matriz de Y1 e Y2
        cont = 1;
        Y1 = zeros(size(Y));
        Y2 = zeros(size(Y));
        for i = 1:size(P,1)
            Y1(P(i,1),P(i,2)) = N1(i);
            if N1(i) == 0;
                Y2(P(i,1),P(i,2)) = N2(cont);
                cont = cont+1;
            end
        end
        
        %recupera cortes
        [cortes(:,:,corte_n),cortes(:,:,corte_n+1)] = rec(Y,Y1,Y2);
    end
end

%caso tenha sobrado um corte
if (flag_par == 1)
        len = bin2dec(bitstream(1:11))*8;
        bitstream = bitstream(12:end);
        stream = bit2bytestream(bitstream(1:len));
        %remove o header
        stream = stream(2:end);
        
        %recupera corte
        fid = fopen('tmp.jbg','wb');
        fwrite(fid,stream);
        fclose(fid);
        !jbgtopbm.exe tmp.jbg tmp.pbm
        cortes(:,:,fim) = imread('tmp.pbm'); 
end