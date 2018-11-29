function bytestream = arith_deco(bitstream)

%retira o header do tamanho do bitstream
header = bin2dec(bitstream(1:8));
tam = bin2dec(bitstream(9:24));

%verifica se está codificado em arith ou não
if (header == 0)
    bitstream = bitstream(41:end);
    %retira as probabilidades do header
    r1 = bin2dec(bitstream(1:16));
    r2 = bin2dec(bitstream(17:32));
    bitstream = bitstream(33:end);
    
    %transforma bitstream para usar o arithdeco
    bitstream = reshape(bitstream,[length(bitstream) 1]);
    bitstream = bin2dec(bitstream);
    bitstream = reshape(bitstream,[1 length(bitstream)]);
    
    %decodifica
    bytestream = arithdeco(bitstream,[r1 r2],tam);
    
    %volta para stream de 1's e 0's
    bytestream = bytestream-1;
else
    bitstream = reshape(bitstream,[length(bitstream) 1]);
    bitstream = bin2dec(bitstream);
    bitstream = reshape(bitstream,[1 length(bitstream)]);
    bytestream = bitstream;
end
bytestream = logical(bytestream);
    