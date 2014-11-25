function temp_job(cls)

% load cad model for subcategories
% filename = sprintf('CAD/%s_subcategory.mat', cls);
% object = load(filename);
% cad = object.([cls '_subcategory']);

files = dir(sprintf('Annotations/%s_imagenet/*.mat', cls));
ids = cell(length(files),1);
for id = 1:length(files)
   temp = files(id).name;
   temp = temp(1:end-4);
   ids{id} = temp;
end

N = numel(ids);
fprintf('%s, number of images %d\n', cls, N);

for i = 1:N
%     disp(ids{i});
    filename = sprintf('Annotations/%s_imagenet/%s.mat', cls, ids{i});
    object = load(filename);
    record = object.record;
    
%     % load old annotations
%     object = load(sprintf('../Hierarchical_Model/Annotations/%s/%s.mat', cls, ids{i}));
%     record_old = object.record;
    
    ob_index = [];
    for j = 1:numel(record.objects)
        if(strcmp(record.objects(j).class, cls) == 1)
            ob_index(end+1) = j;
        end
    end
    
    for j = 1:length(ob_index)
        if isfield(record.objects(ob_index(j)), 'sub_label') == 0
            fprintf('%s miss subtype label\n', ids{i});
        end
%         record.objects(ob_index(j)).subtype = cad.category{record_old.objects(ob_index(j)).sub_label};
%         record.objects(ob_index(j)).sub_label = record_old.objects(ob_index(j)).sub_label;
%         record.objects(ob_index(j)).sub_index = record_old.objects(ob_index(j)).sub_index;
    end
    
%     save(filename, 'record');
end