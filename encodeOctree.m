%Recebe a struct da octree e a codifica em um bitstream de byte a byte,
%Cada byte representa um n�vel da Octree

function bytestream = encodeOctree(octree)

%cria header com coordenadas
coord = log2(octree.dimensions+1);
header = dec2bin(coord,8);
header = reshape(header',[1 length(header)*6]);

bitstream = recursive(octree);
bitstream = [header bitstream];

n = length(bitstream);
%Calcula o n�mero de bytes a escrever.
n8 = ceil(n/8);

%Transforma o bitstream que est� em bits para um array de uint8.
bytestream = zeros(n8,1);
for i = 1:1:length(bytestream)
    bytestream(i) = bin2dec(bitstream((i-1)*8 + 1: i*8));    
end

%------Escreve os dados no arquivo-----
% fid = fopen('Sarah_octree.bin','wb');
% fwrite(fid, bitstream2, 'uint8');
% fclose(fid);

function bitstream = recursive(octree)

%declara o bitstream como array
bitstream = '';

%escreve o byte de acordo com cada child
for i = 1:8
    if octree.child(i).voxel == 1
        bitstream = [bitstream '1'];
    else 
        bitstream = [bitstream '0'];
    end
end
    
    %checa se estamos no �ltimo n�vel, se sim, apenas retornamos
if (octree.dimensions(2)-octree.dimensions(1) == 1)
    return;
end

%se n�o estamos no �ltimo n�vel
%devemos checar os 8 filhos e descer 1 n�vel para cada filho ocupado
for i = 1:8
    if (octree.child(i).voxel == 1)
        bitstream = [bitstream recursive(octree.child(i))];
    end
end