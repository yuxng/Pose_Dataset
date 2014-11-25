clc;
% This is to plot the performance of Bounding box method and Normal method
% along the reduction of annotation ( maximum 7 reduction )
% Since we use '02_plane_mesh_x_x_x.mat' as test images,
% index is fixed to 02
% X axis' range is using only 7 points to using only 1 points
% numb : number of visible points
clear;
numb = 7;
%First, find the azimuth and elevation that have same visible points
[azi ele] = find_same_anchor('car',02,numb);
colorbb = {'*--b','*--r','*--g','*--c','*--m','*--y','*--k'};
colornor = {'--bo','--ro','--go','--co','--mo','--yo','--ko'};
k = max(0,numb - 8);
for i = 1:min([length(azi) 7])
redu_compare(azi(i+k),ele(i+k));
load(sprintf('comp_%d_%d.mat',azi(i+k),ele(i+k)));
figure(1),plot(1+k:numb-1,perf_bbox(1+k:numb-1,1),sprintf('%s',colorbb{i}));hold on;
figure(1),plot(1+k:numb-1,perf_normal(1+k:numb-1,1),sprintf('%s',colornor{i}));
if(min([length(azi) 7])==7)
h=legend(sprintf('bbox,azi=%d,ele=%d',azi(1+k),ele(1+k)),sprintf('original,azi=%d,ele=%d',azi(1+k),ele(1+k)),sprintf('bbox,azi=%d,ele=%d',azi(2+k),ele(2+k)),sprintf('original,azi=%d,ele=%d',azi(2+k),ele(2+k)),...
    sprintf('bbox,azi=%d,ele=%d',azi(3+k),ele(3+k)),sprintf('original,azi=%d,ele=%d',azi(3+k),ele(3+k)),sprintf('bbox,azi=%d,ele=%d',azi(4+k),ele(4+k)),sprintf('original,azi=%d,ele=%d',azi(4+k),ele(4+k)),...
    sprintf('bbox,azi=%d,ele=%d',azi(5+k),ele(5+k)),sprintf('original,azi=%d,ele=%d',azi(5+k),ele(5+k)),sprintf('bbox,azi=%d,ele=%d',azi(6+k),ele(6+k)),sprintf('original,azi=%d,ele=%d',azi(6+k),ele(6+k)),...
    sprintf('bbox,azi=%d,ele=%d',azi(7+k),ele(7+k)),sprintf('original,azi=%d,ele=%d',azi(7+k),ele(7+k)));
end
if(min([length(azi) 7])==6)
h=legend(sprintf('bbox,azi=%d,ele=%d',azi(1+k),ele(1+k)),sprintf('original,azi=%d,ele=%d',azi(1+k),ele(1+k)),sprintf('bbox,azi=%d,ele=%d',azi(2+k),ele(2+k)),sprintf('original,azi=%d,ele=%d',azi(2+k),ele(2+k)),...
    sprintf('bbox,azi=%d,ele=%d',azi(3+k),ele(3+k)),sprintf('original,azi=%d,ele=%d',azi(3+k),ele(3+k)),sprintf('bbox,azi=%d,ele=%d',azi(4+k),ele(4+k)),sprintf('original,azi=%d,ele=%d',azi(4+k),ele(4+k)),...
    sprintf('bbox,azi=%d,ele=%d',azi(5+k),ele(5+k)),sprintf('original,azi=%d,ele=%d',azi(5+k),ele(5+k)),sprintf('bbox,azi=%d,ele=%d',azi(6+k),ele(6+k)),sprintf('original,azi=%d,ele=%d',azi(6+k),ele(6+k)));
end
if(min([length(azi) 7])==5)
h=legend(sprintf('bbox,azi=%d,ele=%d',azi(1+k),ele(1+k)),sprintf('original,azi=%d,ele=%d',azi(1+k),ele(1+k)),sprintf('bbox,azi=%d,ele=%d',azi(2+k),ele(2+k)),sprintf('original,azi=%d,ele=%d',azi(2+k),ele(2+k)),...
    sprintf('bbox,azi=%d,ele=%d',azi(3+k),ele(3+k)),sprintf('original,azi=%d,ele=%d',azi(3+k),ele(3+k)),sprintf('bbox,azi=%d,ele=%d',azi(4+k),ele(4+k)),sprintf('original,azi=%d,ele=%d',azi(4+k),ele(4+k))...
    ,sprintf('bbox,azi=%d,ele=%d',azi(5+k),ele(5+k)),sprintf('original,azi=%d,ele=%d',azi(5+k),ele(5+k)));
end
if(min([length(azi) 7])==4)
h=legend(sprintf('bbox,azi=%d,ele=%d',azi(1+k),ele(1+k)),sprintf('original,azi=%d,ele=%d',azi(1+k),ele(1+k)),sprintf('bbox,azi=%d,ele=%d',azi(2+k),ele(2+k)),sprintf('original,azi=%d,ele=%d',azi(2+k),ele(2+k)),...
    sprintf('bbox,azi=%d,ele=%d',azi(3+k),ele(3+k)),sprintf('original,azi=%d,ele=%d',azi(3+k),ele(3+k)),sprintf('bbox,azi=%d,ele=%d',azi(4+k),ele(4+k)),sprintf('original,azi=%d,ele=%d',azi(4+k),ele(4+k))...
    );
end
if(min([length(azi) 7])==3)
h=legend(sprintf('bbox,azi=%d,ele=%d',azi(1+k),ele(1+k)),sprintf('original,azi=%d,ele=%d',azi(1+k),ele(1+k)),sprintf('bbox,azi=%d,ele=%d',azi(2+k),ele(2+k)),sprintf('original,azi=%d,ele=%d',azi(2+k),ele(2+k)),...
    sprintf('bbox,azi=%d,ele=%d',azi(3+k),ele(3+k)),sprintf('original,azi=%d,ele=%d',azi(3+k),ele(3+k)));
end
if(min([length(azi) 7])==2)
h=legend(sprintf('bbox,azi=%d,ele=%d',azi(1+k),ele(1+k)),sprintf('original,azi=%d,ele=%d',azi(1+k),ele(1+k)),sprintf('bbox,azi=%d,ele=%d',azi(2+k),ele(2+k)),sprintf('original,azi=%d,ele=%d',azi(2+k),ele(2+k)));
end
if(min([length(azi) 7])==1)
h=legend(sprintf('bbox,azi=%d,ele=%d',azi(1+k),ele(1+k)),sprintf('original,azi=%d,ele=%d',azi(1+k),ele(1+k)));
end
set(h,'Location','NorthWest');
xlabel('number of annotation reduction');
ylabel('degree of Azimuth error');
figure(2),plot(1+k:numb-1,perf_bbox(1+k:numb-1,2),sprintf('%s',colorbb{i}));hold on;
figure(2),plot(1+k:numb-1,perf_normal(1+k:numb-1,2),sprintf('%s',colornor{i}));
if(min([length(azi) 7])==7)
h=legend(sprintf('bbox,azi=%d,ele=%d',azi(1+k),ele(1+k)),sprintf('original,azi=%d,ele=%d',azi(1+k),ele(1+k)),sprintf('bbox,azi=%d,ele=%d',azi(2+k),ele(2+k)),sprintf('original,azi=%d,ele=%d',azi(2+k),ele(2+k)),...
    sprintf('bbox,azi=%d,ele=%d',azi(3+k),ele(3+k)),sprintf('original,azi=%d,ele=%d',azi(3+k),ele(3+k)),sprintf('bbox,azi=%d,ele=%d',azi(4+k),ele(4+k)),sprintf('original,azi=%d,ele=%d',azi(4+k),ele(4+k)),...
    sprintf('bbox,azi=%d,ele=%d',azi(5+k),ele(5+k)),sprintf('original,azi=%d,ele=%d',azi(5+k),ele(5+k)),sprintf('bbox,azi=%d,ele=%d',azi(6+k),ele(6+k)),sprintf('original,azi=%d,ele=%d',azi(6+k),ele(6+k)),...
    sprintf('bbox,azi=%d,ele=%d',azi(7+k),ele(7+k)),sprintf('original,azi=%d,ele=%d',azi(7+k),ele(7+k)));
end
if(min([length(azi) 7])==6)
h=legend(sprintf('bbox,azi=%d,ele=%d',azi(1+k),ele(1+k)),sprintf('original,azi=%d,ele=%d',azi(1+k),ele(1+k)),sprintf('bbox,azi=%d,ele=%d',azi(2+k),ele(2+k)),sprintf('original,azi=%d,ele=%d',azi(2+k),ele(2+k)),...
    sprintf('bbox,azi=%d,ele=%d',azi(3+k),ele(3+k)),sprintf('original,azi=%d,ele=%d',azi(3+k),ele(3+k)),sprintf('bbox,azi=%d,ele=%d',azi(4+k),ele(4+k)),sprintf('original,azi=%d,ele=%d',azi(4+k),ele(4+k)),...
    sprintf('bbox,azi=%d,ele=%d',azi(5+k),ele(5+k)),sprintf('original,azi=%d,ele=%d',azi(5+k),ele(5+k)),sprintf('bbox,azi=%d,ele=%d',azi(6+k),ele(6+k)),sprintf('original,azi=%d,ele=%d',azi(6+k),ele(6+k)));
end
if(min([length(azi) 7])==5)
h=legend(sprintf('bbox,azi=%d,ele=%d',azi(1+k),ele(1+k)),sprintf('original,azi=%d,ele=%d',azi(1+k),ele(1+k)),sprintf('bbox,azi=%d,ele=%d',azi(2+k),ele(2+k)),sprintf('original,azi=%d,ele=%d',azi(2+k),ele(2+k)),...
    sprintf('bbox,azi=%d,ele=%d',azi(3+k),ele(3+k)),sprintf('original,azi=%d,ele=%d',azi(3+k),ele(3+k)),sprintf('bbox,azi=%d,ele=%d',azi(4+k),ele(4+k)),sprintf('original,azi=%d,ele=%d',azi(4+k),ele(4+k))...
    ,sprintf('bbox,azi=%d,ele=%d',azi(5+k),ele(5+k)),sprintf('original,azi=%d,ele=%d',azi(5+k),ele(5+k)));
end
if(min([length(azi) 7])==4)
h=legend(sprintf('bbox,azi=%d,ele=%d',azi(1+k),ele(1+k)),sprintf('original,azi=%d,ele=%d',azi(1+k),ele(1+k)),sprintf('bbox,azi=%d,ele=%d',azi(2+k),ele(2+k)),sprintf('original,azi=%d,ele=%d',azi(2+k),ele(2+k)),...
    sprintf('bbox,azi=%d,ele=%d',azi(3+k),ele(3+k)),sprintf('original,azi=%d,ele=%d',azi(3+k),ele(3+k)),sprintf('bbox,azi=%d,ele=%d',azi(4+k),ele(4+k)),sprintf('original,azi=%d,ele=%d',azi(4+k),ele(4+k))...
    );
end
if(min([length(azi) 7])==3)
h=legend(sprintf('bbox,azi=%d,ele=%d',azi(1+k),ele(1+k)),sprintf('original,azi=%d,ele=%d',azi(1+k),ele(1+k)),sprintf('bbox,azi=%d,ele=%d',azi(2+k),ele(2+k)),sprintf('original,azi=%d,ele=%d',azi(2+k),ele(2+k)),...
    sprintf('bbox,azi=%d,ele=%d',azi(3+k),ele(3+k)),sprintf('original,azi=%d,ele=%d',azi(3+k),ele(3+k)));
end
if(min([length(azi) 7])==2)
h=legend(sprintf('bbox,azi=%d,ele=%d',azi(1+k),ele(1+k)),sprintf('original,azi=%d,ele=%d',azi(1+k),ele(1+k)),sprintf('bbox,azi=%d,ele=%d',azi(2+k),ele(2+k)),sprintf('original,azi=%d,ele=%d',azi(2+k),ele(2+k)));
end
if(min([length(azi) 7])==1)
h=legend(sprintf('bbox,azi=%d,ele=%d',azi(1+k),ele(1+k)),sprintf('original,azi=%d,ele=%d',azi(1+k),ele(1+k)));
end
set(h,'Location','NorthWest');
xlabel('number of annotation reduction');
ylabel('degree of Elevation error');
end