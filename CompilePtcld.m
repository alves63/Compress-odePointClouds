
%obtem informações sobre o pointcloud em questão
ptLocation = pointcloud.Location;
boundlimits = [0 1 3 7 15 31 63 127 255 511 1023 2047 4095]; %define os limites possiveis
bound = max([max(pointcloud.XLimits) max(pointcloud.YLimits) max(pointcloud.ZLimits)]); 
limit = boundlimits(bound<boundlimits);
limit = limit(1);

%---------------------PRIMEIRO METODO - Apenas Octree ---------------------
Octree = BuildOctree(ptLocation,[0 limit 0 limit 0 limit]);
bytestream1 = encodeOctree(Octree);
%--------------------------------------------------------------------------


%-----SEGUNDO METODO - Apenas Cortes (Com decisor entre A,B / Y,Y1,Y2)-----
Cortes = ptcld2corte(ptLocation,'y',limit);
bytestream2 = cortes_coder(Cortes);
%--------------------------------------------------------------------------


%---------------TERCEIRO METODO - Octree de 1º nível+Cortes----------------
 Filhos = Octree.child; %temos os 8 primeiros filhos
 bytestream3(1:8) = Octree.child.voxel; %coloca no bytestream o primeiro nivel

for i=1:8
    if ~isempty(Filhos)
        pt1 = octree2ptcld(Filhos(i)); %obtem a pointcloud de cada filho
    if ~isempty(pt1)
        Cortes = ptcld2corte(pt1,'y',floor(limit/2)); %obtem os cortes
        bytestream3 = [bytestream3 cortes_coder(Cortes)]; %cria o bytestream
        end
    end
end
%--------------------------------------------------------------------------


%----------------QUARTO METODO - Octree de 2º nível+Cortes-----------------
%Adiciona ao bytestream os 2 primeiros níveis da octree
bytestream4 = bytestream3; %1º nível
for i = 1:8
    if ~isempty(Filhos(i).child)
        bytestream4 = [bytestream4 Filhos(i).child.voxel]; %2º nível
    end
end

%Aplica Cortes aos 8*8=64 filhos
for i=1:8
    for j = 1:8
        if ~isempty(Filhos(i).child)
            pt2 = octree2ptcld(Filhos(i).child(j)); %obtem a pointcloud de cada filho
        end
        if ~isempty(pt2)
            Cortes = ptcld2corte(pt2,'y',floor(limit/4)); %obtem os cortes
            bytestream4 = [bytestream4 cortes_coder(Cortes)]; %cria o bytestream
            pt2 = [];
        end
    end
end
%--------------------------------------------------------------------------


%---------------QUINTO METODO - Octree de 3º nível+Cortes------------------
%Adiciona ao bytestream os 3 primeiros níveis da octree
bytestream5 = bytestream4; %1º e 2º nível
for i = 1:8
    for j = 1:8
        if ~isempty(Filhos(i).child)
            if ~isempty(Filhos(i).child(j).child)
                bytestream5 = [bytestream5 Filhos(i).child(j).child.voxel]; %3º nível
            end
        end
    end
end

%Aplica Cortes aos 8*8*8=512 filhos
for i=1:8
    for j = 1:8
        for k = 1:8
            if ~isempty(Filhos(i).child)
                if ~isempty(Filhos(i).child(j).child)
                    pt3 = octree2ptcld(Filhos(i).child(j).child(k)); %obtem a pointcloud de cada filho
                end
            end
            if ~isempty(pt3)
                Cortes = ptcld2corte(pt3,'y',floor(limit/8)); %obtem os cortes
                bytestream5 = [bytestream5 cortes_coder(Cortes)]; %cria o bytestream
                pt3 = [];
            end
        end
    end
end
%--------------------------------------------------------------------------