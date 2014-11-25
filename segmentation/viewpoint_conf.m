function confm = viewpoint_conf(cls, vnum)

imlist = textread('/home/roozbeh/dataset/VOCdevkit/VOC2011/ImageSets/Main/val.txt', '%s\n');
load(['/scr/roozbeh/wacv14_test/dpm_res/' cls '_' vnum '_test_flip.mat']);

confm = zeros(vnum,vnum);

for i = 1:length(imlist)
    display([cls ' ' num2str(i)]);
    fname = char(imlist{i});
            
    try
        load(['/home/roozbeh/dataset/PASCAL+/Annotations/' cls '/' fname '.mat']);
    catch
        continue
    end
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
            bi=[max(bb(1),bbgt(1)) ; max(bb(2),bbgt(2)) ; min(bb(3),bbgt(3)) ; min(bb(4),bbgt(4))];
            iw=bi(3)-bi(1)+1;
            ih=bi(4)-bi(2)+1;
            if iw>0 & ih>0
                % compute overlap as area of intersection / area of union
                ua=(bb(3)-bb(1)+1)*(bb(4)-bb(2)+1)+...
                (bbgt(3)-bbgt(1)+1)*(bbgt(4)-bbgt(2)+1)-...
                iw*ih;
                ov=iw*ih/ua;
                if ov>max_ov && marked(k) == 0
                    max_ov=ov;
                    best_idx=k;
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
                
        vv = imdets(best_idx,5);
        
        if record.objects(j).viewpoint.distance == 0
            az_gt = record.objects(j).viewpoint.azimuth_coarse;
        else
            az_gt = record.objects(j).viewpoint.azimuth;
        end
        
        hf_ang = 360 / vnum / 2;        
        if az_gt < hf_ang || az_gt > (360-hf_ang)
            vv_gt = 1;
        else
            vv_gt = floor(az_gt / (360 / vnum)) + 1;    
        end               
        
        confm(vv_gt,vv) = confm(vv_gt,vv) + 1;
        
    end
    
    
    
end


for i = 1:size(confm,1)
    confm(i,:) = confm(i,:) / sum(confm(i,:));
end

