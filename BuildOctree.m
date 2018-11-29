
%Função que divide o cubo em oito filhos.
%Recebe como parâmetros:
%                     -Matriz com os tamanhos do cubo max e min de x, y e z
%                     -PointCloud
%
%A matriz do tamanho do cubo segue a forma:
%[x_min,x_max,y_min,y_max,z_min,z_max]

function Cube = BuildOctree(PtCloud,coord)
Cube.voxel = 1; %sabemos que este cubo possui voxel
Cube.dimensions = coord;
%reorganizando coordenadas para melhor entendimento
x_min = coord(1);   x_max = coord(2);
y_min = coord(3);   y_max = coord(4);
z_min = coord(5);   z_max = coord(6);

%declara as subdivisoes desse cubo (pois sabemos que ele tem voxel)
Cube.child = CreateOctree(); %inicializa vetor de filhos
for i = 1:8
    Cube.child(i) = CreateOctree();
end

%Condição de parada (Cubo de lado = 1)
if (x_max-x_min == 0 || y_max-y_min == 0 || z_max-z_min == 0)
    return;
end

%estabele os limites dos 8 filhos
CoordFilho = ...
[x_min,(x_min+x_max)/2,y_min,(y_min+y_max)/2,z_min,(z_min+z_max)/2;... %filho 1
(x_min+x_max)/2+1,x_max,y_min,(y_min+y_max)/2,z_min,(z_min+z_max)/2;... %filho 2
 x_min,(x_min+x_max)/2,(y_min+y_max)/2+1,y_max,z_min,(z_min+z_max)/2;... %filho 3
(x_min+x_max)/2+1,x_max,(y_min+y_max)/2+1,y_max,z_min,(z_min+z_max)/2;... %filho 4
 x_min,(x_min+x_max)/2,y_min,(y_min+y_max)/2,(z_min+z_max)/2+1,z_max;... %filho 5
(x_min+x_max)/2+1,x_max,y_min,(y_min+y_max)/2,(z_min+z_max)/2+1,z_max;... %filho 6
 x_min,(x_min+x_max)/2,(y_min+y_max)/2+1,y_max,(z_min+z_max)/2+1,z_max;... %filho 7
(x_min+x_max)/2+1,x_max,(y_min+y_max)/2+1,y_max,(z_min+z_max)/2+1,z_max]; %filho 8

CoordFilho = floor(CoordFilho);

%Laço para checar quais filhos contem voxels
for i = 1:8
    %condições para coordenada x
    a1 = PtCloud(:,1) >= CoordFilho(i,1);
    b1 = PtCloud(:,1) <= CoordFilho(i,2);
    c1 = a1&b1;
    %condições para coordenada y
    a2 = PtCloud(:,2) >= CoordFilho(i,3);
    b2 = PtCloud(:,2) <= CoordFilho(i,4);
    c2 = a2&b2;
    %condições para coordenada z
    a3 = PtCloud(:,3) >= CoordFilho(i,5);
    b3 = PtCloud(:,3) <= CoordFilho(i,6);
    c3 = a3&b3;
    
    %indice para coordenadas contidas no cubo
    %as três condições devem ser satisfeitas
    idx = logical(c1&c2&c3);
    
    %Se este filho contem voxel, devemos dividi-lo novamente
    if (any(idx) == 1)
        Cube.child(i) = BuildOctree(PtCloud(idx,:),CoordFilho(i,:));
    else 
        Cube.child(i).voxel = 0;
    end
end