x = '000';

for i = 177:207
    
    %decide o frame
    x = str2num(x);
    x = x+i-1;
    if x<10
        x = ['000' num2str(x)];
    else if x <100
             x = ['00' num2str(x)];
        else
             x = ['0' num2str(x)];
        end
    end
    
    %carrega a pointcloud
    ptcloud = pcread(['..\PLYs para testes\sarah9\ply\frame' x '.ply']);

    frames{i,1} = i-1;
    frames{i,2} = ptcloud.Count;
    
    x = '000';
end