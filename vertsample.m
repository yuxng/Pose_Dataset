% Sample the vertices into N amount of vertices
function newvert = vertsample(vertices,N)
num = size(vertices,1);
pick = [];
for i = 1:N
    pick = [pick;1+min([round((i-1)*(num/N)) num])];
end
newvert = vertices(pick,:);