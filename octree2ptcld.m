%Recebe a Octree e devolve a Pointcloud

function ptcld = octree2ptcld(octree)

%Primeiro devemos saber se esse filho está ocupado
%Caso não esteja já retornamos
if octree.voxel == 0
    ptcld = [];
    return;
end

%A partir daqui já sabemos que o filho está ocupado.

%checa se estamos no último nível
if (octree.dimensions(2)-octree.dimensions(1) == 0)
    ptcld = [octree.dimensions(2) octree.dimensions(4) octree.dimensions(6)];
    return;

%caso não seja o último, checamos seus 8 filhos de forma recursiva
else
    ptcld = [];
    for i = 1:8
        ptcld = [ptcld; octree2ptcld(octree.child(i))];
    end
end

        