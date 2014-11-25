% compute the statistics of viewpoints for pascal objects
function compute_azimuth_difference(cls, vnum)

files = dir(sprintf('Annotations/%s/*.mat', cls));
ids = cell(length(files),1);
for id = 1:length(files)
   temp = files(id).name;
   temp = temp(1:end-4);
   ids{id} = temp;
end

N = numel(ids);
fprintf('%s, number of images %d\n', cls, N);

count_total = 0;
azimuth_diff = 0;
count_diff = 0;
for i = 1:N
    object = load(sprintf('Annotations/%s/%s.mat', cls, ids{i}));
    record = object.record;
    
    % load old annotations
    object = load(sprintf('Annotations/Annotations_01022014/%s/%s.mat', cls, ids{i}));
    record_old = object.record;    
    
    ob_index = [];
    for j = 1:numel(record.objects)
        if(strcmp(record.objects(j).class, cls) == 1)
            ob_index(end+1) = j;
        end
    end
    
    for j = 1:length(ob_index)
        count_total = count_total + 1;
        if record.objects(ob_index(j)).viewpoint.distance == 0
            azimuth = record.objects(ob_index(j)).viewpoint.azimuth_coarse;
        else
            azimuth = record.objects(ob_index(j)).viewpoint.azimuth;
        end
        
        if record_old.objects(ob_index(j)).viewpoint.distance == 0
            azimuth_old = record_old.objects(ob_index(j)).viewpoint.azimuth_coarse;
        else
            azimuth_old = record_old.objects(ob_index(j)).viewpoint.azimuth;
        end        
        
        azimuth_diff = azimuth_diff + abs(azimuth - azimuth_old);
        index = find_interval(azimuth, vnum);
        index_old = find_interval(azimuth_old, vnum);
        if index ~= index_old
            count_diff = count_diff + 1;
        end
    end
end
fprintf('%s, number of objects %d\n', cls, count_total);
fprintf('sum of azimuth difference %.2f, average %.2f\n', azimuth_diff, azimuth_diff / count_total);
fprintf('sum of azimuth difference count %d, average %.2f\n', count_diff, count_diff / count_total);

function ind = find_interval(azimuth, num)

if num == 8
    a = 22.5:45:337.5;
elseif num == 24
    a = 7.5:15:352.5;
end

for i = 1:numel(a)
    if azimuth < a(i)
        break;
    end
end
ind = i;
if azimuth > a(end)
    ind = 1;
end