function modify_annotations(cls)

root_dir = 'PASCAL3D+_release1.1';

files = dir(sprintf('%s/Annotations/%s_imagenet/*.mat', root_dir, cls));

N = numel(files);
fprintf('%s: number of annotations %d\n', cls, N);

for i = 1:N
    disp(files(i).name);
    % read annotation
    filename_ann = sprintf('%s/Annotations/%s_imagenet/%s', root_dir, cls, files(i).name);
    object = load(filename_ann);
    record = object.record;
    
    % read image
    filename_img = sprintf('%s/Images/%s_imagenet/%s', root_dir, cls, [files(i).name(1:end-3), 'JPEG']);
    I = imread(filename_img);
    
    width = size(I,2);
    height = size(I,1);
    depth = size(I,3);
    
    record.size.width = width;
    record.size.height = height;
    record.size.depth = depth;
    record.imgsize = [width height depth];
    record.database = 'ImageNet';
    
    ob_index = [];
    for j = 1:numel(record.objects)
        if(strcmp(record.objects(j).class, cls) == 1)
            ob_index(end+1) = j;
        else
            display(record.objects(j).class);
            pause;
        end
    end
    
    for j = 1:length(ob_index)      
        % get anchor names
        names = fieldnames(record.objects(ob_index(j)).anchors);
        occluded = 0;
        truncated = 0;
        for k = 1:numel(names)
            if record.objects(ob_index(j)).anchors.(names{k}).status == 3
                occluded = 1;
            end
            if record.objects(ob_index(j)).anchors.(names{k}).status == 4
                truncated = 1;
            end
        end
        record.objects(ob_index(j)).truncated = truncated;        
        record.objects(ob_index(j)).occluded = occluded;
        record.objects(ob_index(j)).difficult = 0;
    end
    
    save(filename_ann, 'record');
end
fprintf('%s: number of annotations %d modified\n', cls, N);