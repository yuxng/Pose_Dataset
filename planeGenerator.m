%Make Z-buffer planes for a certain azimuth and elevation
%azi_part : number of azimuth partition  ex) if azi_part equals to 24, then
%           azimuth partition = 15
%ele_part : number of elevation partition ex) if ele_part equals to 6, then
%           elevation partition = 15

function planeGenerator(cls, index, azi_part, ele_part, dist)

filename = sprintf('Anchor/%s/%02d.off', cls, index);
[vertices, faces] = load_off_file(filename);
for i = 1:azi_part + 1
    for j = 1:ele_part + 1
        [plane, plane_mesh] = zbuffer(cls, index, 3000,(i-1)*(360/azi_part), (j-1)*(90/ele_part), 11);
        save(sprintf('02_plane_%d_%d_%d',(i-1)*(360/azi_part),(j-1)*(90/ele_part),11),'plane');
        save(sprintf('02_plane_mesh_%d_%d_%d',(i-1)*(360/azi_part),(j-1)*(90/ele_part),11),'plane_mesh');
    end
end