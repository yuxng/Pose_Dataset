%% Bounding box method with combinded error definition
% error = weight * bbox method error + original method error 
% default weight = 1
% The file name should be changed into 'view_annotator.m' when you wan to use

function varargout = view_annotator(varargin)
% VIEW_ANNOTATOR M-file for view_annotator.fig
%      VIEW_ANNOTATOR, by itself, creates a new VIEW_ANNOTATOR or raises the existing
%      singleton*.
%
%      H = VIEW_ANNOTATOR returns the handle to a new VIEW_ANNOTATOR or the handle to
%      the existing singleton*.
%
%      VIEW_ANNOTATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIEW_ANNOTATOR.M with the given input arguments.
%
%      VIEW_ANNOTATOR('Property','Value',...) creates a new VIEW_ANNOTATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before view_annotator_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to view_annotator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help view_annotator

% Last Modified by GUIDE v2.5 21-Aug-2012 17:43:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @view_annotator_OpeningFcn, ...
                   'gui_OutputFcn',  @view_annotator_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before view_annotator is made visible.
function view_annotator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to view_annotator (see VARARGIN)

% Choose default command line output for view_annotator
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes view_annotator wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = view_annotator_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_cad.
function pushbutton_cad_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_cad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% load cad model
[FileName, PathName] = uigetfile('*.mat');
if isequal(FileName,0)
   return;
end
cad = load(fullfile(PathName, FileName));
cls = FileName(1:end-4);
cad = cad.(cls);
handles.cad = cad;
handles.part_num = numel(cad(1).pnames);

% compute azimuth extent for each part
handles.azimuth_extent = cad(1).azimuth_extent;

% display cad model
set(handles.figure1, 'CurrentAxes', handles.axes_cad);
cla;
trimesh(cad(1).faces, cad(1).vertices(:,1), cad(1).vertices(:,2), cad(1).vertices(:,3), 'EdgeColor', 'b');
axis equal;
hold on;

% display anchor points
for i = 1:numel(cad(1).pnames)
    X = cad(1).(cad(1).pnames{i});
    plot3(X(1), X(2), X(3), 'ro', 'LineWidth', 5);
end

view(315, 45);

% set radio button names
pnames = cad(1).pnames;
for i = 1:20
    id = sprintf('radiobutton%d', i);
    if i <= handles.part_num
        set(handles.(id), 'String', pnames{i});
    else
        set(handles.(id), 'String', '');
    end
end

guidata(hObject, handles);
set(handles.pushbutton_opendir, 'Enable', 'On');


% --- Executes on button press in pushbutton_opendir.
function pushbutton_opendir_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_opendir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

directory_name = uigetdir;
if isequal(directory_name,0)
   return;
end
files = dir(directory_name);
N = numel(files);
i = 1;
flag = 0;
while i <= N && flag == 0
    if files(i).isdir == 0
        filename = files(i).name;
        [pathstr, name, ext] = fileparts(filename);
        if isempty(imformats(ext(2:end))) == 0
            I = imread(fullfile(directory_name, filename));
            set(handles.figure1, 'CurrentAxes', handles.axes_image);
            imshow(I);
            set(handles.text_filename, 'String', [filename '(' num2str(size(I,1)) ', ' num2str(size(I,2)) ')']);
            set(handles.pushbutton_next, 'Enable', 'On');
            set(handles.pushbutton_part, 'Enable', 'On');
            set(handles.pushbutton_clear, 'Enable', 'On');
            set(handles.pushbutton_view, 'Enable', 'On');
            set(handles.pushbutton_bbox, 'Enable', 'On');
            set(handles.radiobutton1, 'Value', 1.0);
            flag = 1;
        end
    end
    i = i + 1;
end
if flag == 0
    errordlg('No image file in the fold');
else
    handles.image = I;
    handles.source_dir = directory_name;
    handles.files = files;
    handles.filepos = i;
    for i = 1:handles.part_num
        handles.(handles.cad(1).pnames{i}) = [];
    end
    handles.bbox = [];
    handles.partname = handles.cad(1).pnames{1};
    guidata(hObject, handles);
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
handles.partname = handles.cad(1).pnames{1};
guidata(hObject, handles);

% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
handles.partname = handles.cad(1).pnames{2};
guidata(hObject, handles);

% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3
handles.partname = handles.cad(1).pnames{3};
guidata(hObject, handles);

% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4
handles.partname = handles.cad(1).pnames{4};
guidata(hObject, handles);

% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5
handles.partname = handles.cad(1).pnames{5};
guidata(hObject, handles);

% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6
handles.partname = handles.cad(1).pnames{6};
guidata(hObject, handles);

% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton7
handles.partname = handles.cad(1).pnames{7};
guidata(hObject, handles);

% --- Executes on button press in radiobutton8.
function radiobutton8_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton8
handles.partname = handles.cad(1).pnames{8};
guidata(hObject, handles);


% --- Executes on button press in radiobutton9.
function radiobutton9_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton9
handles.partname = handles.cad(1).pnames{9};
guidata(hObject, handles);


% --- Executes on button press in radiobutton10.
function radiobutton10_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton10
handles.partname = handles.cad(1).pnames{10};
guidata(hObject, handles);

% --- Executes on button press in pushbutton_next.
function pushbutton_next_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

directory_name = handles.source_dir;
files = handles.files;
i = handles.filepos;
N = numel(files);
flag = 0;

while i <= N && flag == 0
    if files(i).isdir == 0
        filename = files(i).name;
        [pathstr, name, ext] = fileparts(filename);
        if isempty(imformats(ext(2:end))) == 0
            I = imread(fullfile(directory_name, filename));
            set(handles.figure1,'CurrentAxes',handles.axes_image);
            imshow(I);
            set(handles.text_filename, 'String',  [filename '(' num2str(size(I,1)) ', ' num2str(size(I,2)) ')']);
            flag = 1;
        end
    end
    i = i + 1;
end
if flag == 0
    errordlg('No image file left');
else
    handles.image = I;
    handles.filepos = i;
    for i = 1:handles.part_num
        handles.(handles.cad(1).pnames{i}) = [];
    end
    handles.bbox = [];
    guidata(hObject, handles);
end


% --- Executes on button press in pushbutton_part.
function pushbutton_part_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_part (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.figure1, 'CurrentAxes', handles.axes_image);
[x, y] = ginput(1);
hold on;
plot(x, y, 'ro');
hold off;
set(handles.edit1, 'String', num2str(x));
set(handles.edit2, 'String', num2str(y));
handles.(handles.partname) = [x y];
guidata(hObject, handles);


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_clear.
function pushbutton_clear_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.figure1,'CurrentAxes',handles.axes_image);
imshow(handles.image);
for i = 1:handles.part_num
    handles.(handles.cad(1).pnames{i}) = [];
end
handles.bbox = [];
guidata(hObject, handles);

% --- Executes on button press in pushbutton_bbox.
function pushbutton_bbox_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_bbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.figure1,'CurrentAxes',handles.axes_image);
rect = getrect(handles.axes_image);
rectangle('Position', rect, 'EdgeColor', 'g');
handles.bbox = rect;
guidata(hObject, handles);

% --- Executes on button press in pushbutton_view.
function pushbutton_view_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_view (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cad = handles.cad;
cad_num = numel(cad);
% cad_num = 1;
weight = 1;
vertices = cell(cad_num,1);
for i = 1:cad_num
    if(isempty(cad(i).newvert))
        vertices{i} = cad(i).vertices;
    else
        vertices{i} = cad(i).newvert;
    end
end
azimuth_extent = handles.azimuth_extent;
part_num = handles.part_num;
pnames = cad(1).pnames;
bbox = handles.bbox;
principal_point = [bbox(1)+bbox(3)/2 bbox(2)+bbox(4)/2];

x2d = [];
x3d = cell(cad_num, 1);
% aextent = [-inf, inf];
aextent = [0, 2*pi];
eextent = [0, pi/2];
% dextent = [1.5 25];
dextent = [0, 25];
for j = 1:part_num
    if isempty(handles.(pnames{j})) == 0  %Filters the point not clicked on the picture (2D)
        p = handles.(pnames{j});     %The point clicked on picture (2D)
        x2d = [x2d; p];
        for k = 1:cad_num
            x3d{k} = [x3d{k}; cad(k).(pnames{j})];
        end
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
s = sprintf('%.2f+-%.2f', azimuth, interval_azimuth);
set(handles.edit_azimuth, 'String', s);
s = sprintf('%.2f+-%.2f', elevation, interval_elevation);
set(handles.edit_elevation, 'String', s);
set(handles.edit_distance, 'String', num2str(distance));
set(handles.edit_focal, 'String', num2str(focal));
set(handles.edit_px, 'String', num2str(px));
set(handles.edit_py, 'String', num2str(py));
set(handles.edit_rotation, 'String', num2str(theta));
set(handles.edit_error, 'String', num2str(error));

% re-draw the 3D model
set(handles.figure1, 'CurrentAxes', handles.axes_cad);
cla;
trimesh(handles.cad(index).faces, handles.cad(index).vertices(:,1),...
    handles.cad(index).vertices(:,2), handles.cad(index).vertices(:,3), 'EdgeColor', 'b');
axis equal;
hold on;
for i = 1:numel(handles.cad(index).pnames)
    X = cad(index).(pnames{i});
    plot3(X(1), X(2), X(3), 'ro', 'LineWidth', 5);
end
view(azimuth, elevation);
set(gca, 'Projection', 'perspective');
hold off;

% draw the principal point
set(handles.figure1, 'CurrentAxes', handles.axes_image);
hold on;
plot(px, py, 'go', 'LineWidth', 3);
hold off;

% compute viewpoint angle from 2D-3D correspondences
function [azimuth, elevation, distance, focal, px, py, theta, error, interval_azimuth, interval_elevation, index]...
    = compute_viewpoint_one(v0, lb, ub, x2d, x3d, vertices, bbox, weight)
options=optimset('Algorithm','interior-point');
cad_num = numel(x3d);
vp = cell(cad_num, 1);
fval = zeros(cad_num, 1);
for i = 1:cad_num
    [vp{i}, fval(i)] = fmincon(@(v)compute_error(v, x2d, x3d{i}, vertices{i}, bbox, 0, weight), v0, [], [], [], [], lb, ub,[],options);
    temp = vp{i};
    new_lb = [temp(1)-(pi*10/180); max(0,temp(2)-(pi*20/180)); lb(3); lb(4); lb(5); lb(6); lb(7)];
    new_ub = [temp(1)+(pi*10/180); min(pi/2,temp(2)+(pi*20/180)); ub(3); ub(4); ub(5); ub(6); ub(7)];
    [vp{i},fval(i),exitflag(i)] = fmincon(@(v)compute_error(v, x2d, x3d{i}, vertices{i}, bbox, 1, weight), vp{i}, [], [], [], [], new_lb, new_ub, [], options);
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
else %if index = 1 then compute viewpoint minimizes error with bounding box method
    error = normal_dist(x, x2d, principal_point) + weight*relative_dist(v, vertices, bbox, x, x2d, x3d);
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

function edit_azimuth_Callback(hObject, eventdata, handles)
% hObject    handle to edit_azimuth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_azimuth as text
%        str2double(get(hObject,'String')) returns contents of edit_azimuth as a double


% --- Executes during object creation, after setting all properties.
function edit_azimuth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_azimuth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_elevation_Callback(hObject, eventdata, handles)
% hObject    handle to edit_elevation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_elevation as text
%        str2double(get(hObject,'String')) returns contents of edit_elevation as a double


% --- Executes during object creation, after setting all properties.
function edit_elevation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_elevation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_distance_Callback(hObject, eventdata, handles)
% hObject    handle to edit_distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_distance as text
%        str2double(get(hObject,'String')) returns contents of edit_distance as a double


% --- Executes during object creation, after setting all properties.
function edit_distance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton11.
function radiobutton11_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton11
handles.partname = handles.cad(1).pnames{11};
guidata(hObject, handles);


% --- Executes on button press in radiobutton12.
function radiobutton12_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton12
handles.partname = handles.cad(1).pnames{12};
guidata(hObject, handles);


% --- Executes on button press in radiobutton13.
function radiobutton13_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton13
handles.partname = handles.cad(1).pnames{13};
guidata(hObject, handles);


% --- Executes on button press in radiobutton14.
function radiobutton14_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton14
handles.partname = handles.cad(1).pnames{14};
guidata(hObject, handles);


% --- Executes on button press in radiobutton15.
function radiobutton15_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton15
handles.partname = handles.cad(1).pnames{15};
guidata(hObject, handles);


% --- Executes on button press in radiobutton16.
function radiobutton16_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton16
handles.partname = handles.cad(1).pnames{16};
guidata(hObject, handles);



function edit_focal_Callback(hObject, eventdata, handles)
% hObject    handle to edit_focal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_focal as text
%        str2double(get(hObject,'String')) returns contents of edit_focal as a double


% --- Executes during object creation, after setting all properties.
function edit_focal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_focal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_px_Callback(hObject, eventdata, handles)
% hObject    handle to edit_px (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_px as text
%        str2double(get(hObject,'String')) returns contents of edit_px as a double


% --- Executes during object creation, after setting all properties.
function edit_px_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_px (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_py_Callback(hObject, eventdata, handles)
% hObject    handle to edit_py (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_py as text
%        str2double(get(hObject,'String')) returns contents of edit_py as a double


% --- Executes during object creation, after setting all properties.
function edit_py_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_py (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton17.
function radiobutton17_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton17
handles.partname = handles.cad(1).pnames{17};
guidata(hObject, handles);


% --- Executes on button press in radiobutton18.
function radiobutton18_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton18
handles.partname = handles.cad(1).pnames{18};
guidata(hObject, handles);


% --- Executes on button press in radiobutton19.
function radiobutton19_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton19
handles.partname = handles.cad(1).pnames{19};
guidata(hObject, handles);


% --- Executes on button press in radiobutton20.
function radiobutton20_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton20
handles.partname = handles.cad(1).pnames{20};
guidata(hObject, handles);



function edit_rotation_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rotation as text
%        str2double(get(hObject,'String')) returns contents of edit_rotation as a double


% --- Executes during object creation, after setting all properties.
function edit_rotation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_error_Callback(hObject, eventdata, handles)
% hObject    handle to edit_error (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_error as text
%        str2double(get(hObject,'String')) returns contents of edit_error as a double


% --- Executes during object creation, after setting all properties.
function edit_error_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_error (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
