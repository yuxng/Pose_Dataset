function all = aspect2view(cls)
all = [];
imlist = textread('/home/roozbeh/dataset/VOCdevkit/VOC2011/ImageSets/Main/train.txt', '%s\n');
fid = fopen(['/home/roozbeh/wacv14_test/classify/' cls '.inp'], 'w');
for i = 1:length(imlist)
    display([cls ' ' num2str(i)]);
    fname = char(imlist{i});
        
    try
        load(['/home/roozbeh/dataset/PASCAL+/Annotations/' cls '/' fname '.mat']);
    catch
        continue
    end
    
    
    for j = 1:length(record.objects)
        objname = record.objects(j).class;
        
        if ~strcmp(objname,cls)
            continue
        end
        
        bbox = record.objects(j).bbox;        
        %asp_rat = (bbox(3) - bbox(1)) / (bbox(4) - bbox(2));
        
        if record.objects(j).viewpoint.distance == 0
            az = record.objects(j).viewpoint.azimuth_coarse;
        else
            az = record.objects(j).viewpoint.azimuth;
        end
                
        ind = find_interval(az,6);
        
        fprintf(fid, '%d 1:%d 2:%d 3:%d 4:%d \n', ind, (bbox(3) + bbox(1))/2, (bbox(4) + bbox(2))/2, bbox(3) - bbox(1), bbox(4) - bbox(2) );
        %all = [all; (bbox(3) + bbox(1))/2 (bbox(4) + bbox(2))/2  (bbox(3) - bbox(1)) (bbox(4) - bbox(2)) az];
        
    end  
    
    %save(['/home/roozbeh/wacv14_test/classify/' cls '_all.mat'], 'all');
    
end

fclose(fid);

% all = [];
% imlist = textread('/home/roozbeh/dataset/VOCdevkit/VOC2011/ImageSets/Main/train.txt', '%s\n');
% fid = fopen(['/home/roozbeh/wacv14_test/classify/' cls '.inp'], 'w');
% for i = 1:length(imlist)
%     display([cls ' ' num2str(i)]);
%     fname = char(imlist{i});
%         
%     try
%         load(['/home/roozbeh/dataset/PASCAL+/Annotations/' cls '/' fname '.mat']);
%     catch
%         continue
%     end
%     
%     
%     for j = 1:length(record.objects)
%         objname = record.objects(j).class;
%         
%         if ~strcmp(objname,cls)
%             continue
%         end
%         
%         bbox = record.objects(j).bbox;        
%         asp_rat = (bbox(3) - bbox(1)) / (bbox(4) - bbox(2));
%         
%         if record.objects(j).viewpoint.distance == 0
%             az = record.objects(j).viewpoint.azimuth_coarse;
%         else
%             az = record.objects(j).viewpoint.azimuth;
%         end
%         
%         ind = find_interval(az,6);
%         
%         fprintf(fid, '%d 1:%f\n', ind, asp_rat);
%         
%         all = [all; ind asp_rat];
%         
%     end  
%     
%     
% end
% 
% fclose(fid);
% 
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
