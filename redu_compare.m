% generate the .mat files that contains the performance of Bounding box
% method and Original(normal) method for a certain viewpoint(azimuth, elevation)
% azi : azimuth, ele : elevation
% Maximum 15 reduction

function redu_compare(azi,ele)

for i = 1:15
    reduction = 1:i;
result_bbox = redu_test_bbox(azi,ele,reduction');
temp = abs(result_bbox(:,1)-result_bbox(:,4));
temp1 = 360*(abs(temp)>180)-temp.*(abs(temp)>180);
temp2 = temp.*(abs(temp)<180);
azi_error_max = max(temp1+temp2);
azi_error_mean = mean(temp1+temp2);
temp = abs(result_bbox(:,2)-result_bbox(:,5));
temp1 = 360*(abs(temp)>180)-temp.*(abs(temp)>180);
temp2 = temp.*(abs(temp)<180);
ele_error_max = max(temp1+temp2);
ele_error_mean = mean(temp1+temp2);
perf_bbox(i,:) = [azi_error_mean ele_error_mean];

result_normal = redu_test_normal(azi,ele,reduction');
temp = abs(result_normal(:,1)-result_normal(:,4));
temp1 = 360*(abs(temp)>180)-temp.*(abs(temp)>180);
temp2 = temp.*(abs(temp)<180);
azi_error_max = max(temp1+temp2);
azi_error_mean = mean(temp1+temp2);
temp = abs(result_normal(:,2)-result_normal(:,5));
temp1 = 360*(abs(temp)>180)-temp.*(abs(temp)>180);
temp2 = temp.*(abs(temp)<180);
ele_error_max = max(temp1+temp2);
ele_error_mean = mean(temp1+temp2);
perf_normal(i,:) = [azi_error_mean ele_error_mean];
end
save(sprintf('comp_%d_%d.mat',azi,ele),'perf_bbox','perf_normal');