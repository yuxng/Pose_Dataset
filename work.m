function work

filename = 'Anchor/bicycle/CAD/tandem.off';
filename_new = 'Anchor/bicycle/06.off';
theta = 90;

[vertices, faces] = load_off_file_normalize(filename);
vertices_new = rotate_vertices(vertices, theta);
write_off_file(vertices_new, faces, filename_new);