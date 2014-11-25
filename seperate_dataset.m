% seperate data set into training and testing
% N: number of images in the data set
% cls: class name
function [index_train, index_test] = seperate_dataset(cls)

root_dir = 'PASCAL3D+_release1.1';
per = 0.5;

switch cls
    case 'aeroplane'
        subtype = {'airliner', 'fighter', 'propeller', 'others'};
    case 'bicycle'
        subtype = {'mountain', 'race', 'tandem', 'others'};
    case 'boat'
        subtype = {'cabin', 'cargo', 'cruise', 'rowing', 'sailing', 'others'};
    case 'bottle'
        subtype = {'beer', 'ketchup', 'pop', 'water', 'wine', 'others'};
    case 'bus'
        subtype = {'double', 'long', 'school', 'others'};
    case 'car'
        subtype = {'hatchback', 'mini', 'minivan', 'race', 'sedan', 'SUV', 'truck', 'wagon', 'others'};
    case 'chair'
        subtype = {'folding', 'lounge', 'straight', 'swivel', 'others'};
    case 'diningtable'
        subtype = {'ellipse', 'rectangle', 'round', 'square', 'others'};
    case 'motorbike'
        subtype = {'cruiser', 'scooter', 'sport', 'trail', 'others'};
    case 'sofa'
        subtype = {'one', 'two', 'three', 'more', 'others'};
    case 'train'
        subtype = {'body', 'bullet', 'steam', 'others'};
    case 'tvmonitor'
        subtype = {'crtmonitor', 'hdtv', 'lcdmonitor', 'tv', 'others'};
end
sub_num = numel(subtype);
view_num = 8;

files = dir(sprintf('%s/Annotations/%s_imagenet/*.mat', root_dir, cls));
N = numel(files);
index = randperm(N);

nv = zeros(sub_num, view_num);
count = zeros(sub_num, view_num);
index_train = [];
index_test = [];

for i = 1:N
    file_ann = sprintf('%s/Annotations/%s_imagenet/%s', root_dir, cls, files(index(i)).name);
    object = load(file_ann);
    record = object.record;
    
    for j = 1:numel(record.objects)
        if strcmp(record.objects(j).class, cls) == 1
            index_sub = find(strcmp(record.objects(j).subtype, subtype) == 1);
            if record.objects(j).viewpoint.distance == 0
                azimuth = record.objects(j).viewpoint.azimuth_coarse;
            else
                azimuth = record.objects(j).viewpoint.azimuth;
            end
            index_view = find_interval(azimuth, view_num);
            nv(index_sub, index_view) = nv(index_sub, index_view) + 1;
        end
    end
end

for i = 1:sub_num
    for j = 1:view_num
        nv(i,j) = round(nv(i,j) * per);
        if nv(i,j) < 1
            nv(i,j) = 1;
        end
    end
end

for i = 1:N
    file_ann = sprintf('%s/Annotations/%s_imagenet/%s', root_dir, cls, files(index(i)).name);
    object = load(file_ann);
    record = object.record;
    
    flag = 0;
    for j = 1:numel(record.objects)
        if strcmp(record.objects(j).class, cls) == 1
            index_sub = find(strcmp(record.objects(j).subtype, subtype) == 1);
            if record.objects(j).viewpoint.distance == 0
                azimuth = record.objects(j).viewpoint.azimuth_coarse;
            else
                azimuth = record.objects(j).viewpoint.azimuth;
            end
            index_view = find_interval(azimuth, view_num);
            if count(index_sub, index_view) < nv(index_sub, index_view)
                flag = 1;
                break;
            end
        end        
    end
    
    if flag == 0
        index_test = [index_test index(i)];
    else
        index_train = [index_train index(i)];
        for j = 1:numel(record.objects)
            if strcmp(record.objects(j).class, cls) == 1
                index_sub = find(strcmp(record.objects(j).subtype, subtype) == 1);
                if record.objects(j).viewpoint.distance == 0
                    azimuth = record.objects(j).viewpoint.azimuth_coarse;
                else
                    azimuth = record.objects(j).viewpoint.azimuth;
                end
                index_view = find_interval(azimuth, view_num);
                count(index_sub, index_view) = count(index_sub, index_view) + 1;
            end        
        end
    end
end

index_train = sort(index_train);
index_test = sort(index_test);

% write files
filename = sprintf('%s/Image_sets/%s_imagenet_train.txt', root_dir, cls);
fid = fopen(filename, 'w');
for i = 1:numel(index_train)
    fprintf(fid, '%s\n', files(index_train(i)).name(1:end-4));
end
fclose(fid);

filename = sprintf('%s/Image_sets/%s_imagenet_val.txt', root_dir, cls);
fid = fopen(filename, 'w');
for i = 1:numel(index_test)
    fprintf(fid, '%s\n', files(index_test(i)).name(1:end-4));
end
fclose(fid);

filename = sprintf('%s/Image_sets/%s_imagenet_subtype.txt', root_dir, cls);
fid = fopen(filename, 'w');
for i = 1:numel(subtype)
    fprintf(fid, '%s\n', subtype{i});
end
fclose(fid);

function ind = find_interval(azimuth, num)

a = (360/(num*2)):(360/num):360-(360/(num*2));

for i = 1:numel(a)
    if azimuth < a(i)
        break;
    end
end
ind = i;
if azimuth > a(end)
    ind = 1;
end