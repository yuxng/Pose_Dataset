% display CAD model and anchor points
function draw_cad(cad, visibility)

if nargin == 1
    visibility = ones(numel(cad.pnames),1);
end

% display mesh
figure;
trimesh(cad.faces, cad.vertices(:,1), cad.vertices(:,2), cad.vertices(:,3), 'EdgeColor', 'b');
axis equal;
hold on;

% display anchor points
for i = 1:numel(cad.pnames)
    if visibility(i) == 1
        X = cad.(cad.pnames{i});
        if isempty(X) == 0
            plot3(X(1), X(2), X(3), 'ro', 'LineWidth', 5);
        end
    end
end

set(gca, 'Projection', 'perspective');