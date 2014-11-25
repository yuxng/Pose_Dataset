function visibility = zbuffer_cad(cad, M, a, e, d)

vertices = cad.vertices;
faces = cad.faces;

% project the vertices
part = zProjection(vertices, M, a, e ,d);
min_x = min(part(:,1));
min_y = min(part(:,2));

% part(1,:) is x-axis coordinate
% part(2,:) is y-axis coordinate
% part(3,:) is the z-value

x = 4*(part(:,1) - min_x) + 1;
y = 4*(part(:,2) - min_y) + 1;
z = part(:,3);
z = 150*(z-mean(z));
z = z + abs(min(z)) + 1;

mx = ceil(max(x));
my = ceil(max(y));
plane = inf(mx,my);

% for each triangle
for i = 1:size(faces,1)
    temp = diag(plane(round(x(faces(i,:))), round(y(faces(i,:)))));
    if temp(1) > z(faces(i,1)) || temp(2) > z(faces(i,2)) || temp(3) > z(faces(i,3))
        tri = triangle(x(faces(i,:)), y(faces(i,:)), z(faces(i,:)));
        [row, col, vec] = find(tri);
        for j = 1:length(col)
            if plane(row(j),col(j)) > vec(j)
                plane(row(j),col(j)) = vec(j);
            end
        end
    end
end

% for each anchor point
num = numel(cad.pnames);
visibility = zeros(num,1);
anchor_point = zeros(num,3);
for i = 1:numel(cad.pnames)
    X = cad.(cad.pnames{i});
    temp = zProjection(X, M, a, e ,d);
    anchor_point(i,1) = round(4*(temp(1) - min_x) + 1);
    anchor_point(i,2) = round(4*(temp(2) - min_y) + 1);
    anchor_point(i,3) = temp(3);
end
z = anchor_point(:,3);
z = 150*(z - mean(part(:,3)));
anchor_point(:,3) = z + abs(min(z)) + 1;

for i = 1:numel(cad.pnames)
    if(plane(anchor_point(i,1),anchor_point(i,2)) >= anchor_point(i,3))
        visibility(i) = 1;
    end
end