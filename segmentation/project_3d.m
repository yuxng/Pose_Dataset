% project the CAD model to generate aspect part locations
function x = project_3d(x3d, object)

if isfield(object, 'viewpoint') == 1
    % project the 3D points
    viewpoint = object.viewpoint;
    a = viewpoint.azimuth*pi/180;
    e = viewpoint.elevation*pi/180;
    d = viewpoint.distance;
    f = viewpoint.focal;
    theta = viewpoint.theta*pi/180;
    principal = [viewpoint.px viewpoint.py];
    viewport = viewpoint.viewport;
else
    x = [];
    return;
end

if d == 0
    x = [];
    return;
end

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
M = viewport;
P = [M*f 0 0; 0 M*f 0; 0 0 -1] * [R -R*C];

% project
x = P*[x3d ones(size(x3d,1), 1)]';
x(1,:) = x(1,:) ./ x(3,:);
x(2,:) = x(2,:) ./ x(3,:);
x = x(1:2,:);

% rotation matrix 2D
R2d = [cos(theta) -sin(theta); sin(theta) cos(theta)];
x = (R2d * x)';
% x = x';

% transform to image coordinates
x(:,2) = -1 * x(:,2);
x = x + repmat(principal, size(x,1), 1);