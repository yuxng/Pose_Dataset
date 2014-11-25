function dpm2view(cls)

try
    load(['/home/roozbeh/dpm_data/' cls  '_boxes_val_2011.mat']);  
    %fname = [cls  '_boxes_val_2011.mat'];
catch
    load(['/home/roozbeh/dpm_data/' cls  '_boxes_val_6comp.mat']); 
    %fname = [cls  '_boxes_val_6comp.mat'];
end

for i = 1:length(boxes1)
    display(i);
    dets = boxes1{i};
    if size(dets,1) == 0
        continue
    end
    tmpdets = [(dets(:,3) + dets(:,1))/2, (dets(:,4) + dets(:,2))/2, dets(:,3) - dets(:,1), dets(:,4) - dets(:,2)];
    
    dlmwrite(['/home/roozbeh/wacv14_test/classify/' cls '.tmp'], tmpdets, 'delimiter', ' ');
    
    system(['python svmconvert_asp.py /home/roozbeh/wacv14_test/classify/' cls '.tmp pos']);
    system(['/home/roozbeh/utils/svm_light/svm_multiclass_classify /home/roozbeh/wacv14_test/classify/' cls '.tmp-svm /home/roozbeh/wacv14_test/classify/' cls '.model /home/roozbeh/wacv14_test/classify/' cls '.out']);
    
    ind = dlmread(['/home/roozbeh/wacv14_test/classify/' cls '.out']);
    
    ind = ind(:,1);
    
    dets = [dets(:,1:4) ind dets(:,5)];
    boxes1{i} = dets;
    
end

save(['/home/roozbeh/dpm_data/n_' cls  '_boxes_val_2011.mat'], 'boxes1');

