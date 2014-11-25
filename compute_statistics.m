% compute the statistics of viewpoints for pascal objects
function [azimuth_all, count, percentage, theta_all] = compute_statistics(cls, vnum)

files = dir(sprintf('Annotations/%s/*.mat', cls));
ids = cell(length(files),1);
for id = 1:length(files)
   temp = files(id).name;
   temp = temp(1:end-4);
   ids{id} = temp;
end

N = numel(ids);
fprintf('%s, number of images %d\n', cls, N);
count = zeros(vnum, 1);
count_total = 0;
count_coarse = 0;
azimuth_all = [];
theta_all = [];

for i = 1:N
    object = load(sprintf('Annotations/%s/%s.mat', cls, ids{i}));
    record = object.record;
    
    ob_index = [];
    for j = 1:numel(record.objects)
        if(strcmp(record.objects(j).class, cls) == 1)
            ob_index(end+1) = j;
        end
    end
    
    for j = 1:length(ob_index)
        count_total = count_total + 1;
        if record.objects(ob_index(j)).viewpoint.distance == 0
            count_coarse = count_coarse + 1;
            azimuth = record.objects(ob_index(j)).viewpoint.azimuth_coarse;
        else
            azimuth = record.objects(ob_index(j)).viewpoint.azimuth;
            theta = record.objects(ob_index(j)).viewpoint.theta;
            theta_all(end+1) = theta;
        end
        azimuth_all(end+1) = azimuth;
        index = find_interval(azimuth, vnum);
        count(index) = count(index) + 1;
    end
end
fprintf('%s, number of objects with coarse viewpoints %d\n', cls, count_coarse);
fprintf('%s, number of objects %d\n', cls, count_total);
azimuth_all = azimuth_all';
percentage = count / count_total;
index = percentage > 0;
names = {'view1 [-22.5,22.5]', 'view2 [22.5,67.5]', 'view3 [67.5,112.5]', 'view4 [112.5,157.5]', ...
    'view5 [157.5,202.5]', 'view6 [202.5,247.5]', 'view7 [247.5,292.5]', 'view8 [292.5,337.5]'};
h = pie(percentage(index));
set(h(2:2:end), 'FontSize', 16);
h = legend(names(index), 'Location','EastOutside');
set(h, 'FontSize', 16);
title_name = sprintf('%s', cls);
h = title(title_name);
set(h, 'FontSize', 24);

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