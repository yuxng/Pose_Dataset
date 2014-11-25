% draw all the CAD models
function draw_all(cls)

% check the number of CAD models
count = 1;
while 1
    filename = sprintf('Anchor/%s/%02d.off', cls, count);
    if exist(filename) ~= 0
        count = count + 1;
    else
        break;
    end
end
N = count - 1;

for i = 1:N
    disp(i);
    % subplot(ceil(N/3),3,i);
    hf = figure(1);
    cla;
    draw(cls, i);
    filename = sprintf('results/CAD/%s_%02d.png', cls, i);
    saveas(hf, filename);    
%     pause;
end