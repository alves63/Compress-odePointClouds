
%Desenha a Octree com todos os cubos subdivididos
%Possui como argumento a struct da Octree

function PlotOctree(Cube)

%reorganizando coordenadas para melhor entendimento
x_min = Cube.dimensions(1);   x_max = Cube.dimensions(2);
y_min = Cube.dimensions(3);   y_max = Cube.dimensions(4);
z_min = Cube.dimensions(5);   z_max = Cube.dimensions(6);
FaceLength = x_max-x_min;

%Sabemos que este cubo está ocupado
%Então plotamos o cubo
figure(1);
plotcube([FaceLength FaceLength FaceLength],[x_min,y_min,z_min],0,[0 0 0]);

%laço para checar os 8 filhos
for i = 1:8
    if (FaceLength ~= 0) %caso ainda de para dividir o cubo
        if (Cube.child(i).voxel == 1)%caso o voxel é 1
          PlotOctree(Cube.child(i)) %chama a funcao recusivamente
        end

        %caso o cubo seja menor que 1, plotamos apenas o ponto
        %para quando o voxel é 1
    else
        if (Cube.voxel == 1)
            hold on;
            plot3(x_min,y_min,z_min,'.');     
        end
    end
end
