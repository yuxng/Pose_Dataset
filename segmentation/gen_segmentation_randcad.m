function gen_segmentation_randcad(cls)

% check direcotry
name = [cls '_rand'];
if exist(name, 'dir') == 0
    mkdir(name);
end

% projection test
annotationPath = sprintf('../Annotations/%s/', cls);
imagePath = sprintf('../Images/%s_pascal/', cls);

% load cad model
CADPath = sprintf('../CAD/%s.mat', cls);
object = load(CADPath);
cad = object.(cls);
cad_num = numel(cad);

listing = dir(annotationPath);
recordSet = {listing.name};

for recordElement = recordSet
    [~, ~, ext] = fileparts(recordElement{1});
    if ~strcmp(ext, '.mat')
        continue;
    end
    record = load([annotationPath recordElement{1}],'record');
    record = record.record;
    
    im = imread([imagePath, record.filename]);
    [h, w, ~] = size(im);
    outim = zeros(h,w);
    
    for j = 1:length(record.objects)
        objname = record.objects(j).class;
        if ~strcmp(objname, cls)
            continue;
        end
        
        cad_index = randi(cad_num, 1);
        v = cad(cad_index).vertices;
        f = cad(cad_index).faces;
        x = project_3d(v, record.objects(j));
        
        if isempty(x) == 1
            continue;
        end

        vertices = [x(f(:,1),2) x(f(:,1),1) ...
                    x(f(:,2),2) x(f(:,2),1) ...
                    x(f(:,3),2) x(f(:,3),1)];

        BW = mesh_test(vertices, h, w);
        outim = outim | BW;

%         tic;
%         for dd = 1:size(f,1)
%             idx = f(dd,:);
%             hh = x(idx,:);
%             BW = poly2mask(hh(:,1), hh(:,2), h, w);
%             outim = outim | BW;
%         end
%         toc;
    end
    
    save([cls '_rand/' recordElement{1}], 'outim');
end