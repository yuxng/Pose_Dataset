function main

categories={
	'aeroplane';
	'bicycle';
	'boat';
	'bottle';
	'bus';
	'car';
	'chair';
	'diningtable';
	'motorbike';
	'sofa';
	'train';
	'tvmonitor';
};

num_rand = 5;
view_num = [4 8 16 24];
N = numel(view_num);

for i = 1:numel(categories)
    cls = categories{i};
    disp(cls);
    
    % ran ground truth
    fprintf('Ground Truth\n');
    gen_segmentation(cls);
    dirname = sprintf('%s_gt', cls);
    ap_gt = segeval(cls, dirname);
    
    % ran random
    fprintf('Random\n');
    ap_rand = zeros(num_rand, 1);
    for j = 1:num_rand
        gen_segmentation_randcad(cls);
        dirname = sprintf('%s_rand', cls);
        ap_rand(j) = segeval(cls, dirname);
    end
    ap_mean = mean(ap_rand);
    ap_std = std(ap_rand);
    
    % DPM
    fprintf('DPM\n');
    ap_dpm = zeros(numel(view_num), 1);
    if strcmp(cls, 'bottle') == 0
        for j = 1:N
            vnum = view_num(j);
            gen_segmentation_dpm(cls, vnum);
            dirname = sprintf('%s_dpm_view_%d', cls, vnum);
            ap_dpm(j) = segeval(cls, dirname);
        end
    end
    
    fprintf('%s, gt %f \n rand %f(%f) \n', cls, ap_gt, ap_mean, ap_std);
    for j = 1:N
        fprintf('DPM %d view %f\n', view_num(j), ap_dpm(j));
    end
    
    % save result
    filename = sprintf('%s_ap.mat', cls);
    save(filename, 'ap_gt', 'ap_mean', 'ap_std', 'ap_dpm');
end