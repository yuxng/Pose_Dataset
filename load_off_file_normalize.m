% load off file and normalize the vertices to the unit sphere
function [vertices, faces] = load_off_file_normalize(filename)

vertices = [];
faces = [];

fid = fopen(filename, 'r');
line = fgetl(fid);
if strcmp(line, 'OFF') == 0
    printf('Wrong format .off file!\n');
    return;
end

line = fgetl(fid);
num = sscanf(line, '%f', 3);
nv = num(1);
nf = num(2);
vertices = zeros(nv, 3);
faces = zeros(nf, 3);

for i = 1:nv
    line = fgetl(fid);
    vertices(i,:) = sscanf(line, '%f', 3);
end

% center the object to the origin (bounding box center)
center = (max(vertices) + min(vertices)) / 2;
for i = 1:nv
    vertices(i,:) = vertices(i,:) - center;
end

% normalize coordinates of vertices to [-1, +1]
% maxv = max(max(vertices));
% minv = min(min(vertices));
% vertices = (2*vertices - maxv - minv) / (maxv - minv);

% normalize coordinates of vertices to the unit sphere
maxv = max(vertices);
minv = min(vertices);
r = norm(maxv-minv);
vertices = vertices/r;

for i = 1:nf
    line = fgetl(fid);
    fsize = sscanf(line, '%f', 1);
    if fsize ~= 3
        printf('Face contains more than 3 vertices!');
    end
    temp = sscanf(line, '%f', 4);
    faces(i,:) = temp(2:4);
end
faces = faces + 1;

fclose(fid);