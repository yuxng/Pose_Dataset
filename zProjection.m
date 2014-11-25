% Project the vertices on the plane with certain azimuth, elevation and
% distance
% part : 2D points that are projected from vertices part(3,:) represent its
% depth
function part = zProjection(vertices, M, a, e ,d)

% projection matrix
R = M * [1 0 0.5; 0 -1 0.5; 0 0 1];
R(3,3) = 1;
P = projection(a, e, d);
P = R*P([1 2 4], :);

% project the vertices
F = vertices;
part = P*[F ones(size(F,1), 1)]';
part(1,:) = part(1,:) ./ part(3,:);
part(2,:) = part(2,:) ./ part(3,:);
part = part';
