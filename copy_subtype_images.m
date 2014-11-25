function copy_subtype_images(cls)

dir_src = sprintf('Images/%s_imagenet_subtype', cls);
dir_dst = sprintf('Images/%s_imagenet', cls);

% get subtypes
files = dir(dir_src);
num = numel(files) - 2;
subtypes = cell(num, 1);
for i = 3:numel(files)
    subtypes{i-2} = files(i).name;
end

disp(subtypes);

% copy images
for i = 1:num
    path = fullfile(dir_src, subtypes{i});
    files = dir(fullfile(path, '*.JPEG'));
    fprintf('%s: %d images\n', subtypes{i}, numel(files));
    for j = 1:numel(files)
        file_src = fullfile(path, files(j).name);
        file_dst = fullfile(dir_dst, files(j).name);
        disp(file_dst);
        copyfile(file_src, file_dst);
    end
end