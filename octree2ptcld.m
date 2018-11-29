%Recebe a Octree e devolve a Pointcloud

function ptcld = octree2ptcld(octree)

%Primeiro devemos saber se esse filho est� ocupado
%Caso n�o esteja j� retornamos
if octree.voxel == 0
    ptcld = [];
    return;
end

%A partir daqui j� sabemos que o filho est� ocupado.

%checa se estamos no �ltimo n�vel
if (octree.dimensions(2)-octree.dimensions(1) == 0)
    ptcld = [octree.dimensions(2) octree.dimensions(4) octree.dimensions(6)];
    return;

%caso n�o seja o �ltimo, checamos seus 8 filhos de forma recursiva
else
    ptcld = [];
    for i = 1:8
        ptcld = [ptcld; octree2ptcld(octree.child(i))];
    end
end

        