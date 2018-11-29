function bitstream = byte2bitstream(bytestream)

%le o header de quantos 0 existe no final
sobra = bytestream(1);
bytestream = bytestream(2:end);

%transforma em bitstream

for i=1:length(bytestream)
    bitstream((i-1)*8+1:i*8) = dec2bin(bytestream(i),8); %transforma cada byte em 8 bits
end

%retira os 0's do fim
bitstream = bitstream(1:end-sobra);