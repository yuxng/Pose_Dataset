% compute the viewpoints for pascal objects
function compute_viewpoint(cls, issave)

dirname = sprintf('%s_imagenet', cls);
ext = 'JPEG';
use_nonvisible = 1;
clear_nonvisible = 0;
rescale = 1.0;

files = dir(sprintf('Annotations/%s/*.mat', dirname));
ids = cell(length(files),1);
for id = 1:length(files)
   temp = files(id).name;
   temp = temp(1:end-4);
   ids{id} = temp;
end

% load cad model
kernel = load(sprintf('CAD/%s.mat',cls));
cad = kernel.(cls);

for i = 1:length(ids)
    fprintf('%d %s\n', i, ids{i});
    object = load(sprintf('Annotations/%s/%s.mat', dirname, ids{i}));
    record = object.record;
    [azimuth, elevation, azi_co, ele_co, distance, focal, px, py,...
        theta, error, interval_azimuth, interval_elevation, num_anchor, ob_index, tmp]...
        = view_estimator(cls, record, cad, use_nonvisible, clear_nonvisible, rescale);
    record = tmp;
    
    if issave == 0
        I = imread(sprintf('Images/%s/%s.%s', dirname, ids{i}, ext));
    end
    
    for j = 1:length(ob_index)
        record.objects(ob_index(j)).viewpoint.azimuth = azimuth(j);
        record.objects(ob_index(j)).viewpoint.elevation = elevation(j);
        record.objects(ob_index(j)).viewpoint.distance = distance(j);
        record.objects(ob_index(j)).viewpoint.focal = focal(j);
        record.objects(ob_index(j)).viewpoint.px = px(j);
        record.objects(ob_index(j)).viewpoint.py = py(j);
        record.objects(ob_index(j)).viewpoint.theta = theta(j);
        record.objects(ob_index(j)).viewpoint.error = error(j);
        record.objects(ob_index(j)).viewpoint.interval_azimuth = interval_azimuth(j);
        record.objects(ob_index(j)).viewpoint.interval_elevation = interval_elevation(j);
        record.objects(ob_index(j)).viewpoint.num_anchor = num_anchor(j);
        record.objects(ob_index(j)).viewpoint.viewport = 3000;
        if issave == 1
            save(sprintf('Annotations/%s/%s.mat', dirname, ids{i}), 'record');
        else
            imshow(I);
            hold on;
            til = sprintf('a=%f(%d), e=%f(%d), d=%f, f=%f, theta=%f\n', azimuth(j), azi_co(j), elevation(j),...
                ele_co(j), distance(j), focal(j), theta(j));
            title(til);
            plot(px(j), py(j), 'ro');
            bbox = record.objects(ob_index(j)).bbox;
            bbox_draw = [bbox(1) bbox(2) bbox(3)-bbox(1) bbox(4)-bbox(2)];
            rectangle('Position', bbox_draw, 'EdgeColor', 'g');
            pause;
            hold off;
        end
    end
end