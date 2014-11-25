function x = render(cad, a, e, d)

a = a*pi/180;
e = e*pi/180;

%camera center
C = zeros(3,1);
C(1) = d*cos(e)*sin(a);
C(2) = -d*cos(e)*cos(a);
C(3) = d*sin(e);

a = -a;
e = -(pi/2-e);

%rotation matrix
Rz = [cos(a) -sin(a) 0; sin(a) cos(a) 0; 0 0 1];   %rotate by a
Rx = [1 0 0; 0 cos(e) -sin(e); 0 sin(e) cos(e)];   %rotate by e
R = Rx*Rz;

%perspective project matrix
M = 3000;
P = [M 0 0; 0 M 0; 0 0 -1] * [R -R*C];

pnames = cad.pnames;
part_num = numel(pnames);
x3d = zeros(part_num, 3);
for i = 1:part_num
    x3d(i,:) = cad.(pnames{i});
end

% project
x = P*[x3d ones(size(x3d,1), 1)]';
x(1,:) = x(1,:) ./ x(3,:);
x(2,:) = x(2,:) ./ x(3,:);
x = x(1:2,:)';

figure;
plot(x(:,1), x(:,2), 'o');