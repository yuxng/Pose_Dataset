function [vertices, faces] = display_off_file(filename)

[vertices, faces] = load_off_file(filename);

figure;
trimesh(faces, vertices(:,1), vertices(:,2), vertices(:,3), 'EdgeColor', 'b');
view(330, 30);
axis equal;
axis tight;
xlabel('x');
ylabel('y');
zlabel('z');