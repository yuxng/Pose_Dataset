function varargout = annotation_tool(varargin)
% ANNOTATION_TOOL M-file for annotation_tool.fig
%      ANNOTATION_TOOL, by itself, creates a new ANNOTATION_TOOL or raises the existing
%      singleton*.
%
%      H = ANNOTATION_TOOL returns the handle to a new ANNOTATION_TOOL or the handle to
%      the existing singleton*.
%
%      ANNOTATION_TOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANNOTATION_TOOL.M with the given input arguments.
%
%      ANNOTATION_TOOL('Property','Value',...) creates a new ANNOTATION_TOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before annotation_tool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to annotation_tool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help annotation_tool

% Last Modified by GUIDE v2.5 04-Feb-2014 13:34:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @annotation_tool_OpeningFcn, ...
                   'gui_OutputFcn',  @annotation_tool_OutputFcn, ...
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


% --- Executes just before annotation_tool is made visible.
function annotation_tool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to annotation_tool (see VARARGIN)

% Choose default command line output for annotation_tool
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes annotation_tool wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = annotation_tool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_opendir.
function pushbutton_opendir_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_opendir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

directory_name = uigetdir;
if isequal(directory_name,0)
   return;
end
set(handles.text_source, 'String', directory_name);
set(handles.text_dest, 'String', pwd);

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
            imshow(I);
            set(handles.text_filename, 'String', [filename '(' num2str(size(I,1)) ', ' num2str(size(I,2)) ')']);
            set(handles.pushbutton_next, 'Enable', 'On');
            set(handles.pushbutton_next_ten, 'Enable', 'On');
            set(handles.pushbutton_prev, 'Enable', 'On');
            set(handles.pushbutton_dst, 'Enable', 'On');
            set(handles.text_save, 'String', '');
            flag = 1;
        end
    end
    i = i + 1;
end
if flag == 0
    errordlg('No image file in the fold');
else
    handles.image = I;
    handles.name = name;
    handles.ext = ext;
    handles.bbox = [];
    handles.source_dir = directory_name;
    handles.dest_dir = '.';
    handles.files = files;
    handles.filepos = i;
    guidata(hObject, handles);
end

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
            set(handles.figure1, 'CurrentAxes', handles.axes_image);
            I = imread(fullfile(directory_name, filename));
            imshow(I);
            set(handles.text_filename, 'String',  [filename '(' num2str(size(I,1)) ', ' num2str(size(I,2)) ')']);
            flag = 1;
            
            % load annotation
            file_ann = sprintf('%s/%s.mat', handles.dest_dir, name);
            if exist(file_ann, 'file')
                object = load(file_ann);
                record = object.record;
                num = numel(record.objects);
                bbox = zeros(num, 4);
                % show the annotations
                set(handles.figure1, 'CurrentAxes', handles.axes_image);
                hold on;
                for j = 1:num
                    bbox(j,:) = record.objects(j).bbox;
                    bbox_draw = [bbox(j,1) bbox(j,2) bbox(j,3)-bbox(j,1) bbox(j,4)-bbox(j,2)];
                    rectangle('Position', bbox_draw, 'EdgeColor', 'g');
                end
                hold off;
                handles.bbox = bbox;
            else
                handles.bbox = [];
            end
        end
    end
    i = i + 1;
end
if flag == 0
    errordlg('No image file left');
else
    handles.image = I;
    handles.name = name;
    handles.ext = ext;
    handles.filepos = i;
    set(handles.text_save, 'String', '');
    guidata(hObject, handles);
end

% --- Executes on button press in pushbutton_prev.
function pushbutton_prev_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_prev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

directory_name = handles.source_dir;
files = handles.files;
i = handles.filepos - 2;
flag = 0;

while i >= 1 && flag == 0
    if files(i).isdir == 0
        filename = files(i).name;
        [pathstr, name, ext] = fileparts(filename);
        if isempty(imformats(ext(2:end))) == 0
            I = imread(fullfile(directory_name, filename));
            imshow(I);
            set(handles.text_filename, 'String',  [filename '(' num2str(size(I,1)) ', ' num2str(size(I,2)) ')']);
            flag = 1;
            
            % load annotation
            file_ann = sprintf('%s/%s.mat', handles.dest_dir, name);
            if exist(file_ann, 'file')
                object = load(file_ann);
                record = object.record;
                num = numel(record.objects);
                bbox = zeros(num, 4);
                % show the annotations
                set(handles.figure1, 'CurrentAxes', handles.axes_image);
                hold on;
                for j = 1:num
                    bbox(j,:) = record.objects(j).bbox;
                    bbox_draw = [bbox(j,1) bbox(j,2) bbox(j,3)-bbox(j,1) bbox(j,4)-bbox(j,2)];
                    rectangle('Position', bbox_draw, 'EdgeColor', 'g');
                end
                hold off;
                handles.bbox = bbox;
            else
                handles.bbox = [];
            end
        end
    end
    i = i - 1;
end
if flag == 0
    errordlg('No previous image');
else
    handles.image = I;
    handles.name = name;
    handles.ext = ext;
    handles.filepos = i + 2;
    set(handles.text_save, 'String', '');
    guidata(hObject, handles);
end

% --- Executes on button press in pushbutton_save_annotation.
function pushbutton_save_annotation_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save_annotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(handles.bbox) == 1
    disp('bounding box is empty.');
    return;
end

matfile = sprintf('%s/%s.mat', handles.dest_dir, handles.name);
if exist(matfile, 'file')
    image = load(matfile);
    record = image.record;
    bbox = handles.bbox;
    for i = 1:size(bbox, 1)
        record.objects(i).class = handles.cls;
        record.objects(i).bbox = bbox(i,:);
    end
else
    record.filename = [handles.name handles.ext];
    bbox = handles.bbox;
    record.objects = [];
    for i = 1:size(bbox, 1)
        record.objects(i).class = handles.cls;
        record.objects(i).bbox = bbox(i,:);
    end
end
save(matfile, 'record');
set(handles.text_save, 'String', 'Annotation saved!');


% --- Executes on button press in pushbutton_clear.
function pushbutton_clear_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

imshow(handles.image);
if isempty(handles.bbox) == 0
    handles.bbox(end,:) = [];
end
for i = 1:size(handles.bbox,1)
    bbox = handles.bbox(i,:);
    bbox_draw = [bbox(1) bbox(2) bbox(3)-bbox(1) bbox(4)-bbox(2)];
    rectangle('Position', bbox_draw, 'EdgeColor', 'g');
end
guidata(hObject, handles);


% --- Executes on button press in pushbutton_bb.
function pushbutton_bb_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_bb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%rect = getrect(handles.axes_image);
[x, y] = ginput(2);
rect = [x(1) y(1) x(2) y(2)];
bbox_draw = [x(1) y(1) x(2)-x(1) y(2)-y(1)];
rectangle('Position', bbox_draw, 'EdgeColor', 'g');
handles.bbox = [handles.bbox; rect];
guidata(hObject, handles);


% --- Executes on button press in pushbutton_dst.
function pushbutton_dst_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_dst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
directory_name = uigetdir;
if isequal(directory_name,0)
   return;
end
set(handles.text_dest, 'String', directory_name);

% load annotation
filename = sprintf('%s/%s.mat', directory_name, handles.name);

if exist(filename, 'file')
    object = load(filename);
    record = object.record;
    num = numel(record.objects);
    bbox = zeros(num, 4);
    % show the annotations
    set(handles.figure1, 'CurrentAxes', handles.axes_image);
    hold on;
    for i = 1:num
        bbox(i,:) = record.objects(i).bbox;
        bbox_draw = [bbox(i,1) bbox(i,2) bbox(i,3)-bbox(i,1) bbox(i,4)-bbox(i,2)];
        rectangle('Position', bbox_draw, 'EdgeColor', 'g');
    end
    hold off;
    handles.bbox = bbox;
end

handles.dest_dir = directory_name;
guidata(hObject, handles);

set(handles.pushbutton_bb, 'Enable', 'On');
set(handles.pushbutton_save_annotation, 'Enable', 'On');
set(handles.pushbutton_clear, 'Enable', 'On');


% --- Executes on button press in pushbutton_next_ten.
function pushbutton_next_ten_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_next_ten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

directory_name = handles.source_dir;
files = handles.files;
i = handles.filepos + 9;
N = numel(files);
flag = 0;

while i <= N && flag == 0
    if files(i).isdir == 0
        filename = files(i).name;
        [pathstr, name, ext] = fileparts(filename);
        if isempty(imformats(ext(2:end))) == 0
            set(handles.figure1, 'CurrentAxes', handles.axes_image);
            I = imread(fullfile(directory_name, filename));
            imshow(I);
            set(handles.text_filename, 'String',  [filename '(' num2str(size(I,1)) ', ' num2str(size(I,2)) ')']);
            flag = 1;
            
            % load annotation
            file_ann = sprintf('%s/%s.mat', handles.dest_dir, name);
            if exist(file_ann, 'file')
                object = load(file_ann);
                record = object.record;
                num = numel(record.objects);
                bbox = zeros(num, 4);
                % show the annotations
                set(handles.figure1, 'CurrentAxes', handles.axes_image);
                hold on;
                for j = 1:num
                    bbox(j,:) = record.objects(j).bbox;
                    bbox_draw = [bbox(j,1) bbox(j,2) bbox(j,3)-bbox(j,1) bbox(j,4)-bbox(j,2)];
                    rectangle('Position', bbox_draw, 'EdgeColor', 'g');
                end
                hold off;
                handles.bbox = bbox;
            else
                handles.bbox = [];
            end
        end
    end
    i = i + 1;
end
if flag == 0
    errordlg('No image file left');
else
    handles.image = I;
    handles.name = name;
    handles.ext = ext;
    handles.filepos = i;
    set(handles.text_save, 'String', '');
    guidata(hObject, handles);
end



function edit_cls_Callback(hObject, eventdata, handles)
% hObject    handle to edit_cls (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_cls as text
%        str2double(get(hObject,'String')) returns contents of edit_cls as a double
cls = get(hObject,'String');
handles.cls = cls{1};
guidata(hObject, handles);
set(handles.pushbutton_opendir, 'Enable', 'On');


% --- Executes during object creation, after setting all properties.
function edit_cls_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_cls (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end