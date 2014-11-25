% Draw aspect parts on 2d images
function draw_aspect_parts
 
cls = 'car';
subtype = {'hatchback', 'minivan', 'sedan', 'SUV', 'truck', 'wagon'};

% path of annotation files
anno_path = 'Annotations/car_imagenet/';
img_path = 'Images/car_imagenet/';
files = dir([anno_path '*.mat']);

for i = 1:10:numel(files),

    % load annotation files
    object = load([anno_path files(i).name]);
    record = object.record;
    
    filename = [img_path record.filename];
    imshow(filename);
    hold on;

    for j = 1:numel(record.objects)
        object = record.objects(j);
        if strcmp(cls, object.class) == 0
            continue;
        end
        index = strcmp(object.subtype, subtype);
        if isempty(find(index == 1, 1)) == 1
            continue;
        end
        % load aspect layout model
        alm = load(sprintf('ALM/car_%02d.mat', object.cad_index));
        alm = alm.cad;

        for k = 1:numel(alm.parts),
            color = hsv(numel(alm.parts));
            x = project_3d(alm.parts(k).vertices, object);
            patch(x(:,1), x(:,2), color(k,:), 'FaceAlpha', 0.5);
        end
    end

    hold off;
    pause;

end