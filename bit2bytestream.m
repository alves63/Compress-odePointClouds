function bytestream = bit2bytestream(bitstream)

%calcula quantos 0's deve-se preencher no inicio
sobra = 8-mod(length(bitstream),8);

%preenche os 0's no final do bitstream e inclui no inicio esse valor
if (sobra == 8)
    bitstream = [dec2bin(0,8) bitstream];
else
    bitstream = [dec2bin(sobra,8) bitstream dec2bin(0,sobra)];
end

len = length(bitstream)/8;
bytestream = zeros(1,len);
for (i = 1:len)
    bytestream(i) = bin2dec(bitstream((i-1)*8+1:i*8)); %transforma cada 8 bits em seu byte
end
    