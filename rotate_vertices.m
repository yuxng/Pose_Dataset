function vertices_new = rotate_vertices(vertices, theta)

% rotate theta degree around z-axis
R = [cosd(theta) -sind(theta) 0; sind(theta) cosd(theta) 0; 0 0 1];

% theta = -90;
% Rx = [1 0 0; 0 cosd(theta) -sind(theta); 0 sind(theta) cosd(theta)];
% R = Rx*R;

vertices_new = R * vertices';
vertices_new = vertices_new';