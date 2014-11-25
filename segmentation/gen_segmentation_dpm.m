function gen_segmentation_dpm(cls, vnum)

% check direcotry
name = [cls '_dpm_view_' num2str(vnum)];
if exist(name, 'dir') == 0
    mkdir(name);
end

% load cad model
CADPath = sprintf('../CAD/%s.mat', cls);
object = load(CADPath);
cad = object.(cls);

object = load(['../DPM/data/' cls '_' num2str(vnum) '_test_flip.mat']);
dets = object.dets;

imlist = textread('../PASCAL/VOCdevkit/VOC2012/ImageSets/Main/val.txt', '%s\n');

for i = 1:length(imlist)
    fname = char(imlist{i});
    if exist(['../Annotations/' cls '/' fname '.mat']) ~= 0
        object = load(['../Annotations/' cls '/' fname '.mat']);
        record = object.record;
    else
        continue;
    end
    
    im = imread(['../PASCAL/VOCdevkit/VOC2012/JPEGImages/', fname '.jpg']);
    [h, w, ~] = size(im);
    outim = zeros(h,w);
    
    imdets = dets{i};
    marked  = zeros(size(imdets,1),1);
    for j = 1:length(record.objects)
        objname = record.objects(j).class;
        
        if ~strcmp(objname,cls)
            continue
        end
        bbgt = record.objects(j).bbox;
        
        best_idx = -1;
        max_ov = -inf;
        for k = 1:size(imdets,1)
            bb = imdets(k,1:4);
            bi = [max(bb(1),bbgt(1)) ; max(bb(2),bbgt(2)) ; min(bb(3),bbgt(3)) ; min(bb(4),bbgt(4))];
            iw = bi(3) - bi(1) + 1;
            ih = bi(4) - bi(2) + 1;
            if iw > 0 && ih > 0
                % compute overlap as area of intersection / area of union
                ua = (bb(3)-bb(1)+1)*(bb(4)-bb(2)+1)+...
                (bbgt(3)-bbgt(1)+1)*(bbgt(4)-bbgt(2)+1)-...
                iw*ih;
                ov = iw*ih/ua;
                if ov > max_ov && marked(k) == 0
                    max_ov = ov;
                    best_idx = k;
                end            
            end
            if max_ov >= 0.5 && marked(k) == 0
                marked(k) = 1;
                break;                
            end
        end
        if best_idx == -1 || max_ov < 0.5
            continue
        end
        
        vv = imdets(best_idx, 5);
        az = (vv-1) * (360 / vnum);
        boxcx = (imdets(best_idx,3) + imdets(best_idx,1)) / 2;
        boxcy = (imdets(best_idx,2) + imdets(best_idx,4)) / 2;
        
        v = cad(record.objects(j).cad_index).vertices;
        f = cad(record.objects(j).cad_index).faces;        
        x = generate_part_locations_dpm(v, record.objects(j), [boxcx boxcy], az);
        
        if isempty(x) == 1
            continue;
        end
        
        vertices = [x(f(:,1),2) x(f(:,1),1) ...
                    x(f(:,2),2) x(f(:,2),1) ...
                    x(f(:,3),2) x(f(:,3),1)];

        BW = mesh_test(vertices, h, w);
        outim = outim | BW;     
    end
    save([cls '_dpm_view_' num2str(vnum) '/' fname '.mat'], 'outim');
end