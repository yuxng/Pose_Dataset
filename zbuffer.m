% Z-buffer algorithm for rendering
% Input 
% M : viewport size
% a : azimuth
% e : elevation
% d : distance
function [plane, plane_mesh] = zbuffer(cls, index, M, a, e, d)

% load CAD model
filename = sprintf('Anchor/%s/%02d.off', cls, index);
[vertices, faces] = load_off_file(filename);

% project the vertices
part = zProjection(vertices, M, a, e ,d);

% part(1,:) is x-axis coordinate
% part(2,:) is y-axis coordinate
% part(3,:) is the z-value

x = 4*(part(:,1) - min(part(:,1))) + 1;
y = 4*(part(:,2) - min(part(:,2))) + 1;
z = part(:,3);
z = 150*(z-mean(z));
z = z + abs(min(z)) + 1;

mx = ceil(max(x));
my = ceil(max(y));
plane = zeros(mx,my);
plane_mesh = zeros(mx,my);

% for each triangle
for i = 1:size(faces,1)
    tri = triangle(x(faces(i,:)), y(faces(i,:)), z(faces(i,:)));
    [row, col, vec] = find(tri);
    for j = 1:length(col)
        if( plane(row(j),col(j)) == 0 || ( plane(row(j),col(j)) >= vec(j)))
            plane(row(j),col(j)) = vec(j);
        end
    end
end

for i = 1:size(faces,1)
    tri_line = triangle_line(x(faces(i,:)),y(faces(i,:)),z(faces(i,:)));
    [row_line, col_line, vec_line] = find(tri_line);
    for j = 1:length(row_line)
        if(plane(row_line(j),col_line(j)) >= vec_line(j))
            plane_mesh(row_line(j),col_line(j)) = vec_line(j);
        end
    end
end

% save('plane5.mat','plane');
% save('plane5_mesh.mat','plane_mesh');