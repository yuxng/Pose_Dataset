function result = redu_test_normal(azi,ele,reduction)
load('dar12345.mat');
load('./datamatrix/car_02.mat');
cad = dar(1,3);
cad_num = numel(cad);
weight = 1;
numb = 0;
for a_num = 1:length(azi)
    for e_num = 1:length(ele)
        viscad = [];
viscad = data(1,ele(e_num)/15+(azi(a_num)/15)*7+1);
vertices = cell(cad_num,1);
for i = 1:cad_num
    if(isempty(cad(i).newvert))
        vertices{i} = cad(i).vertices;
    else
        vertices{i} = cad(i).newvert;
    end
end
numb = numb + 1;
part_num = 20;
pnames = cad(1).pnames;
%xmax & ymax is maximum boundary of x axis and y axis
 
x2d = [];
x3d = cell(cad_num, 1);
aextent = [0, 2*pi];
eextent = [0, pi/2];
dextent = [0, 25];

load(sprintf('./mesh_images/02_plane_mesh_%d_%d_11',azi(a_num),ele(e_num)));
maxrow = size(plane_mesh,1);
maxcol = size(plane_mesh,2);
bbox(1) = 0;
bbox(2) = 0;
bbox(3) = maxrow;
bbox(4) = maxcol;
principal_point = [bbox(1)+bbox(3)/2 bbox(2)+bbox(4)/2];
cnt = 0;
for j = 1:part_num
    if(viscad.vis(j))
        cnt = cnt + 1;
        p = viscad.p(cnt,:);    %The point clicked on picture (2D)
        x2d = [x2d; p];
        for k = 1:cad_num
            x3d{k} = [x3d{k}; cad(k).(pnames{j})];
        end
    end
end
if(sum(reduction(:,numb)))
    x2d = remove(x2d,reduction(:,numb));
    for k = 1:cad_num
        x3d{k} = remove(x3d{k},reduction(:,numb));
    end
end
% inialization
v0 = zeros(7,1);
% azimuth
v0(1) = (aextent(1) + aextent(2))/2;
% elevation
v0(2) = (eextent(1) + eextent(2))/2;
% distance
v0(3) = (dextent(1) + dextent(2))/2;
% focal length
v0(4) = 1;
% principal point x
v0(5) = principal_point(1);
% principal point y
v0(6) = principal_point(2);
% in-plane rotation
v0(7) = 0;
% lower bound
lb = [aextent(1); eextent(1); dextent(1); 0.01; bbox(1)+2*bbox(3)/5; bbox(2)+2*bbox(4)/5; -pi/50];
% upper bound
ub = [aextent(2); eextent(2); dextent(2); 3; bbox(1)+3*bbox(3)/5; bbox(2)+3*bbox(4)/5; pi/50];
% optimization
[azimuth, elevation, distance, focal, px, py, theta, error, interval_azimuth, interval_elevation, index]...
    = compute_viewpoint_one(v0, lb, ub, x2d, x3d, vertices, bbox, weight);

% set results
result(numb,:) = [azi(a_num) ele(e_num) 11 azimuth elevation distance focal px py theta error index];
    end
end

function [azimuth, elevation, distance, focal, px, py, theta, error, interval_azimuth, interval_elevation, index]...
    = compute_viewpoint_one(v0, lb, ub, x2d, x3d, vertices, bbox, weight)
options=optimset('Algorithm','interior-point');
cad_num = numel(x3d);
vp = cell(cad_num, 1);
fval = zeros(cad_num, 1);
for i = 1:cad_num
    [vp{i}, fval(i)] = fmincon(@(v)compute_error(v, x2d, x3d{i}, vertices{i}, bbox, 0, weight), v0, [], [], [], [], lb, ub,[],options);
end
[~, index] = min(fval);
viewpoint = vp{index};
error = fval(index);

azimuth = viewpoint(1)*180/pi;
if azimuth < 0
    azimuth = azimuth + 360;
end
elevation = viewpoint(2)*180/pi;
distance = viewpoint(3);
focal = viewpoint(4);
px = viewpoint(5);
py = viewpoint(6);
theta = viewpoint(7)*180/pi;

% estimate confidence inteval
v = viewpoint;
v(7) = 0;
x = project(v, x3d{index});
% azimuth
v = viewpoint;
v(1) = v(1) + pi/180;
xprim = project(v, x3d{index});
error_azimuth = sum(diag((x-xprim) * (x-xprim)'));
interval_azimuth = error / error_azimuth;
% elevation
v = viewpoint;
v(2) = v(2) + pi/180;
xprim = project(v, x3d{index});
error_elevation = sum(diag((x-xprim) * (x-xprim)'));
interval_elevation = error / error_elevation;

function error = compute_error(v, x2d, x3d, vertices, bbox, index, weight)

a = v(1);
e = v(2);
d = v(3);
f = v(4);
principal_point = [v(5) v(6)];
theta = v(7);

% camera center
C = zeros(3,1);
C(1) = d*cos(e)*sin(a);
C(2) = -d*cos(e)*cos(a);
C(3) = d*sin(e);

a = -a;
e = -(pi/2-e);

% rotation matrix
Rz = [cos(a) -sin(a) 0; sin(a) cos(a) 0; 0 0 1];   %rotate by a
Rx = [1 0 0; 0 cos(e) -sin(e); 0 sin(e) cos(e)];   %rotate by e
R = Rx*Rz;

% perspective project matrix
M = 3000;
P = [M*f 0 0; 0 M*f 0; 0 0 -1] * [R -R*C];

% project
x = P*[x3d ones(size(x3d,1), 1)]';
x(1,:) = x(1,:) ./ x(3,:);
x(2,:) = x(2,:) ./ x(3,:);
x = x(1:2,:);

% rotation matrix 2D
R2d = [cos(theta) -sin(theta); sin(theta) cos(theta)];
x = (R2d * x)';
% compute error
if(index == 0) %if index = 0 then compute viewpoint minimizes error with normal error definition
    error = normal_dist(x,x2d,principal_point);
    error;
else %if index = 1 then compute viewpoint minimizes error with bounding box method
    error = normal_dist(x, x2d, principal_point) + weight*relative_dist(v, vertices, bbox, x, x2d, x3d);
    error;
    if(error<3000)
    end
end

function error = normal_dist(x, x2d, p_pnt)
error = 0;
for i = 1:size(x2d, 1)
     point = x2d(i,:) - p_pnt;
     point(2) = -1 * point(2);
     error = error + (point-x(i,:))*(point-x(i,:))';
end

function error = relative_dist(v, vertices, bbox, x, x2d, x3d)
% projected 3D vertices
vert2d = project(v, vertices);
% figure(3),plot(vert2d(:,1),vert2d(:,2),'.'); hold on;
xmax = max(vert2d(:,1));
xmin = min(vert2d(:,1));
ymax = max(vert2d(:,2));
ymin = min(vert2d(:,2));

a_vert2d = zeros(size(x3d,1),2);
b_vert2d = zeros(size(x3d,1),2);
a_x2d = zeros(size(x2d,1),2);
b_x2d = zeros(size(x2d,1),2);

for i = 1:size(x3d,1)
    a_vert2d(i,:) = x(i,:) - [xmin ymin];
    b_vert2d(i,:) = [xmax ymax] - x(i,:);
end

for i = 1:size(x2d,1)
    a_x2d(i,:) = x2d(i,:) - [bbox(1) bbox(2)+bbox(4)];
    b_x2d(i,:) = [bbox(1)+bbox(3) bbox(2)] - x2d(i,:);
    a_x2d(i,2) = -a_x2d(i,2); 
    b_x2d(i,2) = -b_x2d(i,2);
end
%     figure(3),line([xmax xmax], [ymax ymin],'Color',[1 0 1]);hold on;
%     figure(3),line([xmin xmax], [ymin ymin],'Color',[1 0 1]);
%     figure(3),line([xmin xmin], [ymin ymax],'Color',[1 0 1]);
%     figure(3),line([xmax xmin], [ymax ymax],'Color',[1 0 1]);
%     figure(3),plot(a_vert2d(:,1),a_vert2d(:,2),'ro');
%     figure(3),plot(a_x2d(:,1),a_x2d(:,2),'bo');

% compute error
error = 0;
for i = 1:size(x2d, 1)
    error = error + 0.5*((a_vert2d(i,:)-a_x2d(i,:))*(a_vert2d(i,:)-a_x2d(i,:))'...
            + (b_vert2d(i,:)-b_x2d(i,:))*(b_vert2d(i,:)-b_x2d(i,:))')/size(x2d, 1);
end
if(error<1000)
end

function x = project(v, x3d)

a = v(1);
e = v(2);
d = v(3);
f = v(4);
theta = v(7);

% camera center
C = zeros(3,1);
C(1) = d*cos(e)*sin(a);
C(2) = -d*cos(e)*cos(a);
C(3) = d*sin(e);

a = -a;
e = -(pi/2-e);

% rotation matrix
Rz = [cos(a) -sin(a) 0; sin(a) cos(a) 0; 0 0 1];   %rotate by a
Rx = [1 0 0; 0 cos(e) -sin(e); 0 sin(e) cos(e)];   %rotate by e
R = Rx*Rz;

% perspective project matrix
M = 3000;
P = [M*f 0 0; 0 M*f 0; 0 0 -1] * [R -R*C];

% project
x = P*[x3d ones(size(x3d,1), 1)]';
x(1,:) = x(1,:) ./ x(3,:);
x(2,:) = x(2,:) ./ x(3,:);
x = x(1:2,:);

% rotation matrix 2D
R2d = [cos(theta) -sin(theta); sin(theta) cos(theta)];
x = (R2d * x)';