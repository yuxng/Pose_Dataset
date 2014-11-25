cls = 'tvmonitor';
clsno = 20;
imname = '2008_000305';
im = imread(['/home/roozbeh/dataset/PASCAL+/Images/' cls '_pascal/' imname '.jpg']);

load(['/home/roozbeh/wacv14_test/' cls '_bet/' imname]);
%outim = imread('/home/roozbeh/wacv14_test/test2.png');

imshow(im)

[B,L,N,A] = bwboundaries(outim);

hold on;


for k=1:length(B),
    if(~sum(A(k,:)))
       boundary = B{k};
       plot(boundary(:,2),...
           boundary(:,1),'Color', cmap(clsno+1,:),'LineWidth',3);
%        for l=find(A(:,k))'
%            boundary = B{l};
%            plot(boundary(:,2),...
%                boundary(:,1), 'Color', cmap(clsno+1,:) ,'LineWidth',3);
%        end
    end
end


alphamask(logical(outim), cmap(clsno+1,:), 0.5);

set(gca,'units','pixels'); % set the axes units to pixels

x = get(gca,'position'); % get the position of the axes

set(gcf,'units','pixels'); % set the figure units to pixels

y = get(gcf,'position'); % get the figure position

set(gcf,'position',[y(1) y(2) x(3) x(4)]);% set the position of the figure to the length and width of the axes

set(gca,'units','normalized','position',[0 0 1 1]); % set the axes units to pixels


