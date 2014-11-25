function ap = segeval(cls, dirname)

categories={
	'aeroplane'; %1
	'bicycle'; %2
	'bird'; %3
	'boat'; %4
	'bottle'; %5
	'bus'; %6
	'car'; %7
	'cat'; %8
	'chair'; %9
	'cow'; %10
	'diningtable';%11
	'dog';%12
	'horse';%13
	'motorbike';%14
	'person';%15
	'pottedplant'; %16
	'sheep'; %17
	'sofa'; %18
	'train'; %19
	'tvmonitor'; %20
};
index = strcmp(cls, categories);
clsno = find(index == 1);

allint = 0;
alluni = 0;

imlist = textread('../PASCAL/VOCdevkit/VOC2012/ImageSets/Main/val.txt', '%s\n');

count = 0;
for i = 1:length(imlist)
    fname = char(imlist{i});
    if exist(['../Annotations/' cls '/' fname '.mat']) == 0
        continue;
    end
    
    if exist(['berk_contours/dataset/cls/' fname '.mat']) == 0
        continue;
    end
    object = load(['berk_contours/dataset/cls/' fname '.mat']);
    GTcls = object.GTcls;
    
    load([dirname '/' fname]);

    idx = find(GTcls.Segmentation==clsno);
    idx2 = find(outim==1);

    alluni = alluni + length(union(idx,idx2));
    allint = allint + length(intersect(idx,idx2));
    count = count + 1;
end

ap = allint / alluni;