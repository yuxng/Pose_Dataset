% compute the viewpoints for pascal objects
function compute_viewpoint_one(cls, id, issave)

% load cad model
kernel = load(sprintf('CAD/%s.mat',cls));
cad = kernel.(cls);

fprintf('%s\n', id);
object = load(sprintf('Annotations/%s/%s.mat', cls, id));
record = object.record;
[azimuth, elevation, azi_co, ele_co, distance, focal, px, py,...
    theta, error, interval_azimuth, interval_elevation, num_anchor, ob_index]...
    = view_estimator(cls, record, cad);

if issave == 0
    I = imread(sprintf('Images/%s_pascal/%s.jpg', cls, id));
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
        save(sprintf('Annotations/%s/%s.mat', cls, id), 'record');
    else
        imshow(I);
        hold on;
        til = sprintf('a=%.2f(%.2f), e=%.2f(%.2f), d=%.2f, f=%.2f, theta=%.2f\n', azimuth(j), azi_co(j), elevation(j),...
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