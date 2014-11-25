function add_subtype_annotations(cls)

dir_src = sprintf('Annotations/%s_imagenet_subtype', cls);

% get subtypes
files = dir(dir_src);
num = numel(files) - 2;
subtypes = cell(num, 1);
for i = 3:numel(files)
    subtypes{i-2} = files(i).name;
end

disp(subtypes);

% add subtype
for i = 1:num
    path = fullfile(dir_src, subtypes{i});
    files = dir(fullfile(path, '*.mat'));
    fprintf('%s: %d annotations\n', subtypes{i}, numel(files));
    for j = 1:numel(files)
        file_src = fullfile(path, files(j).name);
        disp(file_src);
        object = load(file_src);
        record = object.record;
        
        for k = 1:numel(record.objects)
            record.objects(k).subtype = subtypes{i};
        end
        
        save(file_src, 'record');
    end
end