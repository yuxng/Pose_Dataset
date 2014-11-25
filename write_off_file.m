% write an off file
function write_off_file(vertices, faces, filename)

nv = size(vertices, 1);
nf = size(faces, 1);

fid = fopen(filename, 'w');
fprintf(fid, 'OFF\n');
fprintf(fid, '%d %d %d\n', nv, nf, 0);

% write vertices
for i = 1:nv
    fprintf(fid, '%.5f %.5f %.5f\n', vertices(i,1), vertices(i,2), vertices(i,3));
end

% write faces
for i = 1:nf
    fprintf(fid, '3 %d %d %d\n', faces(i,1)-1, faces(i,2)-1, faces(i,3)-1);
end

fclose(fid);