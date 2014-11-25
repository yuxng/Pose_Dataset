%Warning!! mat files can be changed by the 'save'function!!
% Draw the histogram about use of CAD model
% make the result about the performance of 
% Bounding box method and Normal method
% hist_bbox : row vector showing the use of CAD model
% perf_bbox : contains the information of mean azimuth and elevation error
% azi_error_mean : mean azimuth error
% ele_error_mean : mean elevation error
% azi_error_max : transient maximum azimuth error
% ele_error_max : transient maximum elevation error

load('result12345_bbox_recent.mat')
%Characteristic of 'result12345_bbox_recent.mat' is following
%[a e 11 azimuth elevation distance focal px py theta error index]
result_bbox = result;
load('result12345_normal_recent.mat')
result_normal = result;

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
figure(1),hist(result_bbox(:,12),[1 2 3 4]);hold on;
hist_bbox = hist(result_bbox(:,12),[1 2 3 4]);
perf_bbox = [azi_error_mean ele_error_mean azi_error_max ele_error_max];

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
figure(2),hist(result_normal(:,12),[1 2 3 4]);hold on;
hist_normal = hist(result_normal(:,12),[1 2 3 4]);
perf_normal = [azi_error_mean ele_error_mean azi_error_max ele_error_max];

save('perf12345_recent.mat','hist_bbox','perf_bbox','hist_normal','perf_normal');