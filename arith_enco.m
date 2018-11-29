function seq_bin = arith_enco(seq)

%para codificar deve haver no minimo 2 simbolos diferentes
if (length(unique(seq)) > 1)
    header = dec2bin(0,8);
    
    %soma 1 no bitstream pro codificador aritmetico funcionar (ele não
    %funciona com 0)
    seq = uint8(seq)+1;
    
    %cria o stream codificado
    seq_arith = arithenco(seq,round([sum(seq==1)*100/length(seq) sum(seq==2)*100/length(seq)]));

    %adiciona header necessário para decodificar
    seq_arith = [length(seq) length(seq_arith) round([sum(seq==1)*100/length(seq) sum(seq==2)*100/length(seq)]) seq_arith];

    %transforma em bitstream
    st = dec2bin(seq_arith(1:4),16)';
    seq_bin = reshape(st,[1 16*4]);
    st = dec2bin(seq_arith(5:end),1)';
    seq_bin = [header seq_bin reshape(st,[1 length(seq_arith(5:end))])];

%se há apenas um símbolo, ele vira um bitstream
else
    header = dec2bin(255,8);
    seq_bin = dec2bin(seq,1)';
    seq_bin = [header dec2bin(length(seq),16) seq_bin];
end

