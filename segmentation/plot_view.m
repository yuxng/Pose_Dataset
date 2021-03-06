function all_el = plot_view(cls)

imlist = textread('/home/roozbeh/dataset/VOCdevkit/VOC2011/ImageSets/Main/trainval.txt', '%s\n');

all_az = [];
all_el = [];

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
        
        
        if record.objects(j).viewpoint.distance == 0
            az = record.objects(j).viewpoint.azimuth_coarse;
        else
            az = record.objects(j).viewpoint.azimuth;
        end
        
        el = record.objects(j).viewpoint.elevation;
                
        all_az = [all_az;az];
        all_el = [all_el;el];
    end  
    
    
end


all_az = all_az * pi / 180.0;
all_el = all_el * pi / 180.0;

%h2 = rose(all_el,0:9:359);
%hold on;
%h1 = rose(all_az,0:15:359);
%title(cls, 'FontSize', 28);

%set(h2,'LineWidth',2.0,'Color',[1.0,0,0]);
%set(h1,'LineWidth',2.0,'Color',[0,0,1.0]);


% 
% set(gca,'units','pixels'); % set the axes units to pixels
% 
% x = get(gca,'position'); % get the position of the axes
% 
% set(gcf,'units','pixels'); % set the figure units to pixels
% 
% y = get(gcf,'position'); % get the figure position
% 
% set(gcf,'position',[y(1) y(2) x(3) x(4)]);% set the position of the figure to the length and width of the axes
% 
% set(gca,'units','normalized','position',[0 0 1 1]); % set the axes units to pixels

