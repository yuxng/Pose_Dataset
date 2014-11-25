function copy_subtype_annotations(cls)

dir_src = sprintf('Annotations/%s_imagenet_subtype', cls);
dir_dst = sprintf('Annotations/%s_imagenet', cls);
dir_img = sprintf('Images/%s_imagenet', cls);

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
        image_name = [files(j).name(1:end-3) 'JPEG'];
        image_path = fullfile(dir_img, image_name);
        if exist(image_path)
            file_src = fullfile(path, files(j).name);
            file_dst = fullfile(dir_dst, files(j).name);
            copyfile(file_src, file_dst);
            disp(file_src);
        end
    end
end