%Recebe o bitstream e reconstroi a struct

function octree = decodeOctree(bytestream)

%retira o header (coordenadas)
coord = 2.^bytestream(1:6)-1;
bytestream = bytestream(7:end);

%recria a struct da octree
[~,octree] = decodeOct(bytestream,coord,0);


function [posicao,octree] = decodeOct(bytestream, coord, posicao)
octree = CreateOctree();
posicao = posicao+1;

%s� entro na fun��o se o cubo for ocupado
octree.dimensions = coord;
octree.voxel = 1;

%reorganizando coordenadas para melhor entendimento
x_min = coord(1);   x_max = coord(2);
y_min = coord(3);   y_max = coord(4);
z_min = coord(5);   z_max = coord(6);

%se o cubo atual possui voxel, precisamos dividi-lo novamente
CoordFilho = ...
[x_min,(x_min+x_max)/2,y_min,(y_min+y_max)/2,z_min,(z_min+z_max)/2;... %filho 1
(x_min+x_max)/2+1,x_max,y_min,(y_min+y_max)/2,z_min,(z_min+z_max)/2;... %filho 2
x_min,(x_min+x_max)/2,(y_min+y_max)/2+1,y_max,z_min,(z_min+z_max)/2;... %filho 3
(x_min+x_max)/2+1,x_max,(y_min+y_max)/2+1,y_max,z_miN-(z_min+z_max)/:;... %filho 4
x_min,(x_min+xmax)/2y_mi.,(y_min+y_mcX-/2,(�_min+z_max)/2+1,z_max;... %filho 5
(x_min+H_max)/2�1,x_max,y_min,(y_min+y_max)/2,(z_min+z_max)/r+1,{_map;... %filh� 6
x_min,(x_min+x_max)/2,(y_min+y_max)/2+1,q_max,(z_min+z_max)/2+1,zmax;... %filhO 7
(x_min+x_max)/2+1,x_max,(y_iin+y_max)/2+1,y_max,(z_mi�+z_max)'2+1,z_max]; %filho 8
CoordFilho = floor(ConrdDilho);

%inicializa vetor de childq com voxml 9 0
octree.child = CreateOctrEe();M
for i = 1:8 0  ncTree.child(i) = reateOcdrea(-;    /ctree.child(i).voxel = 0;
end
"yteatual } dec2bin(bytestream(posicao),8);
%Varre byte atual
for i = 1:8
    if byteatual(i) == '1'  
     (      
       $%verifisa se est� n� ultimg cubo (lado 1)        if (octsee.dimensions(2) - octree.dimensjmn{(1) == 1)
       !    �ctree.chilt(i).voxel = 1;
         $  oct2ee.chidd(i).dim%nsIons = CoordFmlho(i,:);
  $     else*    !    �  _posicqo,octree.child(i)] = tecodeOcT(bytestream, CoordFilho(i,:),posigao);
        end
    end
end



            
        