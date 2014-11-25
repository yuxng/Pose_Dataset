%% Bounding box method with combinded error definition
% error = weight * bbox method error + original method error 
% default weight = 1
% The file name should be changed into 'cad_annotator.m' when you wan to use

function varargout = cad_annotator(varargin)
% cad_annotator M-file for cad_annotator.fig
%      cad_annotator, by itself, creates a new cad_annotator or raises the existing
%      singleton*.
%
%      H = cad_annotator returns the handle to a new cad_annotator or the handle to
%      the existing singleton*.
%
%      cad_annotator('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in cad_annotator.M with the given input arguments.
%
%      cad_annotator('Property','Value',...) creates a new cad_annotator or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cad_annotator_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cad_annotator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cad_annotator

% Last Modified by GUIDE v2.5 05-Feb-2014 19:07:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cad_annotator_OpeningFcn, ...
                   'gui_OutputFcn',  @cad_annotator_OutputFcn, ...
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


% --- Executes just before cad_annotator is made visible.
function cad_annotator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cad_annotator (see VARARGIN)

% Choose default command line output for cad_annotator
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cad_annotator wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = cad_annotator_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% display cad model
function display_cad_model(handles)

cad = handles.cad;
sub_label = handles.sub_label;
name = sprintf('radiobutton%d', sub_label);
set(handles.(name), 'Value', 1);

sub_index = handles.sub_index;
for i = 1:12
    name = sprintf('radiobutton_cad%d', i);
    if i == sub_index
        set(handles.(name), 'Value', 1);
    else
        set(handles.(name), 'Value', 0);
    end
    if i <= numel(cad.model{sub_label})
        strname = sprintf('%s%d', cad.category{sub_label}, i);
        set(handles.(name), 'Enable', 'on');
    else
        strname = '';
        set(handles.(name), 'Enable', 'off');
    end
    set(handles.(name), 'String', strname);
end

set(handles.edit_azimuth, 'String', num2str(handles.azimuth));
set(handles.edit_elevation, 'String', num2str(handles.elevation)); 

model = cad.model{sub_label};
for i = 1:numel(model)
    axes_name = sprintf('axes_cad%d', i);
    set(handles.figure1, 'CurrentAxes', handles.(axes_name));
    cla;
    trimesh(model(i).faces, model(i).vertices(:,1), ...
        model(i).vertices(:,2), model(i).vertices(:,3), 'EdgeColor', 'b');
    axis equal;
    axis off;
    view(handles.azimuth, handles.elevation);
end
for i = numel(model)+1:12
    axes_name = sprintf('axes_cad%d', i);
    set(handles.figure1, 'CurrentAxes', handles.(axes_name));
    cla;
    axis off;
end

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
handles.cls = cls(1:end-12);
handles.cad = cad;
handles.sub_label = 1;
handles.sub_index = 1;

% set radio button names
pnames = cad.category;
for i = 1:10
    id = sprintf('radiobutton%d', i);
    if i <= numel(pnames)
        set(handles.(id), 'String', pnames{i});
    else
        set(handles.(id), 'String', '');
    end
end

handles.azimuth = 0;
handles.elevation = 0;

guidata(hObject, handles);
set(handles.pushbutton_opendir, 'Enable', 'On');

% display cad model
display_cad_model(handles);


% --- Executes on button press in pushbutton_opendir.
function pushbutton_opendir_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_opendir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

directory_name = uigetdir;
set(handles.text_src, 'String', directory_name);
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
            set(handles.pushbutton_dest, 'Enable', 'On');
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
    handles.source_dir = directory_name;
    handles.files = files;
    handles.filepos = i;
    guidata(hObject, handles);
end


% --- Executes on button press in pushbutton_dest.
function pushbutton_dest_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_dest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

directory_name = uigetdir;
set(handles.text_dest, 'String', directory_name);

% load annotation
filename = sprintf('%s/%s.mat', directory_name, handles.name);

if exist(filename) == 0
    errordlg('No annotation available for the image');
else
    object = load(filename);
    record = object.record;
    handles.record = record;

    % show the annotations
    for i = 1:numel(record.objects)
        if strcmp(record.objects(i).class, handles.cls) == 1
            bbox = record.objects(i).bbox;
            bbox_draw = [bbox(1) bbox(2) bbox(3)-bbox(1) bbox(4)-bbox(2)];
            set(handles.figure1, 'CurrentAxes', handles.axes_image);
            cla;
            imshow(handles.image);
            hold on;
            rectangle('Position', bbox_draw, 'EdgeColor', 'g');
            handles.object_index = i;
            % show annotated anchor points
            if isfield(record.objects(i), 'anchors') == 1 && isempty(record.objects(i).anchors) == 0
                names = fieldnames(record.objects(i).anchors);
                for j = 1:numel(names)
                    if record.objects(i).anchors.(names{j}).status == 1
                        if isempty(record.objects(i).anchors.(names{j}).location) == 0
                            x = record.objects(i).anchors.(names{j}).location(1);
                            y = record.objects(i).anchors.(names{j}).location(2);
                            plot(x, y, 'ro');
                        else
                            fprintf('anchor point %s is missing!\n', names{j});
                            set(handles.text_save, 'String', 'Re-annotate!');
                        end
                    end
                end                
            end
            hold off;
            % show the cad model
            if isfield(record.objects(i), 'sub_label') == 1 && isempty(record.objects(i).sub_label) == 0 && ...
                    isfield(record.objects(i), 'sub_index') == 1 && isempty(record.objects(i).sub_index) == 0
                handles.sub_label = record.objects(i).sub_label;
                handles.sub_index = record.objects(i).sub_index;
            else
                handles.sub_label = 1;
                handles.sub_index = 1;
            end
            if isfield(record.objects(i).viewpoint, 'azimuth') == 1
                handles.azimuth = record.objects(i).viewpoint.azimuth;
                handles.elevation = record.objects(i).viewpoint.elevation;
            else
                handles.azimuth = record.objects(i).viewpoint.azimuth_coarse;
                handles.elevation = record.objects(i).viewpoint.elevation_coarse;
            end
            display_cad_model(handles);                          
            break;
        end
    end     

    handles.dest_dir = directory_name;
    guidata(hObject, handles);
    
    set(handles.pushbutton_next, 'Enable', 'On');
    set(handles.pushbutton_prev, 'Enable', 'On');
    set(handles.pushbutton_next_ten, 'Enable', 'On');
    set(handles.pushbutton_left, 'Enable', 'On');
    set(handles.pushbutton_right, 'Enable', 'On');
    set(handles.pushbutton_up, 'Enable', 'On');
    set(handles.pushbutton_down, 'Enable', 'On');
    set(handles.pushbutton_ok, 'Enable', 'On');
    % enable radio button names
    pnames = handles.cad.category;
    for i = 1:10
        id = sprintf('radiobutton%d', i);
        if i <= numel(pnames)
            set(handles.(id), 'Enable', 'On');
        end
    end    
end


% --- Executes on button press in pushbutton_next.
function pushbutton_next_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
% check for next object first
is_next_object = 0;
record = handles.record;
for i = handles.object_index+1:numel(record.objects)
    if strcmp(record.objects(i).class, handles.cls) == 1
        is_next_object = 1;
        bbox = record.objects(i).bbox;
        bbox_draw = [bbox(1) bbox(2) bbox(3)-bbox(1) bbox(4)-bbox(2)];
        set(handles.figure1, 'CurrentAxes', handles.axes_image);
        cla;
        imshow(handles.image);
        hold on;
        rectangle('Position', bbox_draw, 'EdgeColor', 'g');
        % show annotated anchor points
        if isfield(record.objects(i), 'anchors') == 1 && isempty(record.objects(i).anchors) == 0
            names = fieldnames(record.objects(i).anchors);
            for j = 1:numel(names)
                if record.objects(i).anchors.(names{j}).status == 1
                    if isempty(record.objects(i).anchors.(names{j}).location) == 0
                        x = record.objects(i).anchors.(names{j}).location(1);
                        y = record.objects(i).anchors.(names{j}).location(2);
                        plot(x, y, 'ro');
                    else
                        fprintf('anchor point %s is missing!\n', names{j});
                        set(handles.text_save, 'String', 'Re-annotate!');
                    end
                end
            end                
        end        
        hold off;
        handles.object_index = i;
        break;
    end
end

if is_next_object == 0
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
                
                % load annotation
                filename_ann = sprintf('%s/%s.mat', handles.dest_dir, name);
                if exist(filename_ann) == 0
                    errordlg('No annotation available for the image');
                    return;
                else
                    object = load(filename_ann);
                    record = object.record;
                    handles.record = record;

                    % show the bounding box
                    for j = 1:numel(record.objects)
                        if strcmp(record.objects(j).class, handles.cls) == 1
                            bbox = record.objects(j).bbox;
                            bbox_draw = [bbox(1) bbox(2) bbox(3)-bbox(1) bbox(4)-bbox(2)];
                            set(handles.figure1, 'CurrentAxes', handles.axes_image);
                            cla;
                            imshow(I);
                            hold on;
                            rectangle('Position', bbox_draw, 'EdgeColor', 'g');
                            % show annotated anchor points
                            if isfield(record.objects(j), 'anchors') == 1 && isempty(record.objects(j).anchors) == 0
                                names = fieldnames(record.objects(j).anchors);
                                for k = 1:numel(names)
                                    if record.objects(j).anchors.(names{k}).status == 1
                                        if isempty(record.objects(j).anchors.(names{k}).location) == 0
                                            x = record.objects(j).anchors.(names{k}).location(1);
                                            y = record.objects(j).anchors.(names{k}).location(2);
                                            plot(x, y, 'ro');
                                        else
                                            fprintf('anchor point %s is missing!\n', names{k});
                                            set(handles.text_save, 'String', 'Re-annotate!');
                                        end
                                    end
                                end                
                            end                            
                            hold off;
                            handles.object_index = j;
                            break;
                        end
                    end
                end
                
                set(handles.text_filename, 'String',  [filename '(' num2str(size(I,1)) ', ' num2str(size(I,2)) ')']);
                flag = 1;
            end
        end
        i = i + 1;
    end

    if flag == 0
        errordlg('No image file left');
        return;
    else
        handles.image = I;
        handles.name = name;    
        handles.filepos = i;
    end
end

if isfield(handles.record.objects(handles.object_index), 'sub_label') == 1 &&...
        isempty(handles.record.objects(handles.object_index).sub_label) == 0 && ...
    isfield(handles.record.objects(handles.object_index), 'sub_index') == 1 && ...
        isempty(handles.record.objects(handles.object_index).sub_index) == 0
    handles.sub_label = handles.record.objects(handles.object_index).sub_label;
    handles.sub_index = handles.record.objects(handles.object_index).sub_index;  
end

if isfield(handles.record.objects(handles.object_index), 'viewpoint') == 1 &&...
        isempty(handles.record.objects(handles.object_index).viewpoint) == 0
    if isfield(handles.record.objects(handles.object_index).viewpoint, 'azimuth') == 1 && ...
            handles.record.objects(handles.object_index).viewpoint.distance ~= 0
        handles.azimuth = handles.record.objects(handles.object_index).viewpoint.azimuth;
        handles.elevation = handles.record.objects(handles.object_index).viewpoint.elevation; 
    else
        handles.azimuth = handles.record.objects(handles.object_index).viewpoint.azimuth_coarse;
        handles.elevation = handles.record.objects(handles.object_index).viewpoint.elevation_coarse;   
    end
else
    handles.azimuth = 0;
    handles.elevation = 0;   
end

% display cad model
display_cad_model(handles);

set(handles.text_save, 'String', '');
guidata(hObject, handles);


% --- Executes on button press in pushbutton_prev.
function pushbutton_prev_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_prev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clc;
% check for previous object first
is_prev_object = 0;
record = handles.record;
for i = handles.object_index-1:-1:1
    if strcmp(record.objects(i).class, handles.cls) == 1
        is_prev_object = 1;
        bbox = record.objects(i).bbox;
        bbox_draw = [bbox(1) bbox(2) bbox(3)-bbox(1) bbox(4)-bbox(2)];
        set(handles.figure1, 'CurrentAxes', handles.axes_image);
        cla;
        imshow(handles.image);
        hold on;
        rectangle('Position', bbox_draw, 'EdgeColor', 'g');
        % show annotated anchor points
        if isfield(record.objects(i), 'anchors') == 1 && isempty(record.objects(i).anchors) == 0
            names = fieldnames(record.objects(i).anchors);
            for j = 1:numel(names)
                if record.objects(i).anchors.(names{j}).status == 1
                    if isempty(record.objects(i).anchors.(names{j}).location) == 0
                        x = record.objects(i).anchors.(names{j}).location(1);
                        y = record.objects(i).anchors.(names{j}).location(2);
                        plot(x, y, 'ro');
                    else
                        fprintf('anchor point %s is missing!\n', names{j});
                        set(handles.text_save, 'String', 'Re-annotate!');
                    end
                end
            end                
        end        
        hold off;
        handles.object_index = i;
        break;
    end
end

if is_prev_object == 0
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
                
                % load annotation
                filename_ann = sprintf('%s/%s.mat', handles.dest_dir, name);
                if exist(filename_ann) == 0
                    errordlg('No annotation available for the image');
                    return;
                else
                    object = load(filename_ann);
                    record = object.record;
                    handles.record = record;

                    % show the bounding box
                    for j = 1:numel(record.objects)
                        if strcmp(record.objects(j).class, handles.cls) == 1
                            bbox = record.objects(j).bbox;
                            bbox_draw = [bbox(1) bbox(2) bbox(3)-bbox(1) bbox(4)-bbox(2)];
                            set(handles.figure1, 'CurrentAxes', handles.axes_image);
                            cla;
                            imshow(I);
                            hold on;
                            rectangle('Position', bbox_draw, 'EdgeColor', 'g');
                            % show annotated anchor points
                            if isfield(record.objects(j), 'anchors') == 1 && isempty(record.objects(j).anchors) == 0
                                names = fieldnames(record.objects(j).anchors);
                                for k = 1:numel(names)
                                    if record.objects(j).anchors.(names{k}).status == 1
                                        if isempty(record.objects(j).anchors.(names{k}).location) == 0
                                            x = record.objects(j).anchors.(names{k}).location(1);
                                            y = record.objects(j).anchors.(names{k}).location(2);
                                            plot(x, y, 'ro');
                                        else
                                            fprintf('anchor point %s is missing!\n', names{k});
                                            set(handles.text_save, 'String', 'Re-annotate!');
                                        end
                                    end
                                end                
                            end                            
                            hold off;
                            handles.object_index = j;
                            break;
                        end
                    end
                end
                
                set(handles.text_filename, 'String',  [filename '(' num2str(size(I,1)) ', ' num2str(size(I,2)) ')']);
                flag = 1;
            end
        end
        i = i - 1;
    end

    if flag == 0
        errordlg('No previous image');
        return;
    else
        handles.image = I;
        handles.name = name;    
        handles.filepos = i + 2;
    end
end

if isfield(handles.record.objects(handles.object_index), 'sub_label') == 1 &&...
        isempty(handles.record.objects(handles.object_index).sub_label) == 0 && ...
    isfield(handles.record.objects(handles.object_index), 'sub_index') == 1 && ...
        isempty(handles.record.objects(handles.object_index).sub_index) == 0
    handles.sub_label = handles.record.objects(handles.object_index).sub_label;
    handles.sub_index = handles.record.objects(handles.object_index).sub_index;   
end

if isfield(handles.record.objects(handles.object_index), 'viewpoint') == 1 &&...
        isempty(handles.record.objects(handles.object_index).viewpoint) == 0
    if isfield(handles.record.objects(handles.object_index).viewpoint, 'azimuth') == 1 && ...
            handles.record.objects(handles.object_index).viewpoint.distance ~= 0
        handles.azimuth = handles.record.objects(handles.object_index).viewpoint.azimuth;
        handles.elevation = handles.record.objects(handles.object_index).viewpoint.elevation; 
    else
        handles.azimuth = handles.record.objects(handles.object_index).viewpoint.azimuth_coarse;
        handles.elevation = handles.record.objects(handles.object_index).viewpoint.elevation_coarse;   
    end
else
    handles.azimuth = 0;
    handles.elevation = 0;   
end

% display cad model
display_cad_model(handles);
guidata(hObject, handles);


% --- Executes on button press in pushbutton_next_ten.
function pushbutton_next_ten_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_next_ten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clc;
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
            I = imread(fullfile(directory_name, filename));

            % load annotation
            filename_ann = sprintf('%s/%s.mat', handles.dest_dir, name);
            if exist(filename_ann) == 0
                errordlg('No annotation available for the image');
                return;
            else
                object = load(filename_ann);
                record = object.record;
                handles.record = record;

                % show the bounding box
                for j = 1:numel(record.objects)
                    if strcmp(record.objects(j).class, handles.cls) == 1
                        bbox = record.objects(j).bbox;
                        bbox_draw = [bbox(1) bbox(2) bbox(3)-bbox(1) bbox(4)-bbox(2)];
                        set(handles.figure1, 'CurrentAxes', handles.axes_image);
                        cla;
                        imshow(I);
                        hold on;
                        rectangle('Position', bbox_draw, 'EdgeColor', 'g');
                        % show annotated anchor points
                        if isfield(record.objects(j), 'anchors') == 1 && isempty(record.objects(j).anchors) == 0
                            names = fieldnames(record.objects(j).anchors);
                            for k = 1:numel(names)
                                if record.objects(j).anchors.(names{k}).status == 1
                                    if isempty(record.objects(j).anchors.(names{k}).location) == 0
                                        x = record.objects(j).anchors.(names{k}).location(1);
                                        y = record.objects(j).anchors.(names{k}).location(2);
                                        plot(x, y, 'ro');
                                    else
                                        fprintf('anchor point %s is missing!\n', names{k});
                                        set(handles.text_save, 'String', 'Re-annotate!');
                                    end
                                end
                            end                
                        end                        
                        hold off;
                        handles.object_index = j;
                        break;
                    end
                end
            end

            set(handles.text_filename, 'String',  [filename '(' num2str(size(I,1)) ', ' num2str(size(I,2)) ')']);
            flag = 1;
        end
    end
    i = i + 1;
end

if flag == 0
    errordlg('No image file left');
    return;
else
    handles.image = I;
    handles.name = name;    
    handles.filepos = i;
end

if isfield(handles.record.objects(handles.object_index), 'sub_label') == 1 &&...
        isempty(handles.record.objects(handles.object_index).sub_label) == 0 && ...
    isfield(handles.record.objects(handles.object_index), 'sub_index') == 1 && ...
        isempty(handles.record.objects(handles.object_index).sub_index) == 0
    handles.sub_label = handles.record.objects(handles.object_index).sub_label;
    handles.sub_index = handles.record.objects(handles.object_index).sub_index; 
end

if isfield(handles.record.objects(handles.object_index), 'viewpoint') == 1 &&...
        isempty(handles.record.objects(handles.object_index).viewpoint) == 0
    if isfield(handles.record.objects(handles.object_index).viewpoint, 'azimuth') == 1 && ...
            handles.record.objects(handles.object_index).viewpoint.distance ~= 0
        handles.azimuth = handles.record.objects(handles.object_index).viewpoint.azimuth;
        handles.elevation = handles.record.objects(handles.object_index).viewpoint.elevation; 
    else
        handles.azimuth = handles.record.objects(handles.object_index).viewpoint.azimuth_coarse;
        handles.elevation = handles.record.objects(handles.object_index).viewpoint.elevation_coarse;   
    end
else
    handles.azimuth = 0;
    handles.elevation = 0;   
end

% display cad model
display_cad_model(handles);
guidata(hObject, handles);


% --- Executes on button press in pushbutton_left.
function pushbutton_left_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.azimuth = handles.azimuth + 5;
if handles.azimuth >= 360
    handles.azimuth = handles.azimuth - 360;
end
display_cad_model(handles);
guidata(hObject, handles);


% --- Executes on button press in pushbutton_right.
function pushbutton_right_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.azimuth = handles.azimuth - 5;
if handles.azimuth < 0
    handles.azimuth = handles.azimuth + 360;
end
display_cad_model(handles);
guidata(hObject, handles);


% --- Executes on button press in pushbutton_up.
function pushbutton_up_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.elevation = handles.elevation + 2.5;
if handles.elevation > 90
    handles.elevation = 90;
end
display_cad_model(handles);
guidata(hObject, handles);


% --- Executes on button press in pushbutton_down.
function pushbutton_down_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.elevation = handles.elevation - 2.5;
if handles.elevation < -90
    handles.elevation = -90;
end
display_cad_model(handles);
guidata(hObject, handles);



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


% --- Executes on button press in pushbutton_ok.
function pushbutton_ok_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

matfile = sprintf('%s/%s.mat', handles.dest_dir, handles.name);

record = handles.record;
record.objects(handles.object_index).subtype = handles.cad.category{handles.sub_label};
record.objects(handles.object_index).sub_label = handles.sub_label;
record.objects(handles.object_index).sub_index = handles.sub_index;

save(matfile, 'record');
set(handles.text_save, 'String', 'Annotation saved');

handles.record = record;
guidata(hObject, handles);


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1

handles.sub_label = 1;
handles.sub_index = 1;

% display cad model
display_cad_model(handles);

guidata(hObject, handles);


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2

handles.sub_label = 2;
handles.sub_index = 1;

% display cad model
display_cad_model(handles);

guidata(hObject, handles);


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3

handles.sub_label = 3;
handles.sub_index = 1;

% display cad model
display_cad_model(handles);

guidata(hObject, handles);


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4

handles.sub_label = 4;
handles.sub_index = 1;

% display cad model
display_cad_model(handles);

guidata(hObject, handles);


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5

handles.sub_label = 5;
handles.sub_index = 1;

% display cad model
display_cad_model(handles);

guidata(hObject, handles);


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6

handles.sub_label = 6;
handles.sub_index = 1;

% display cad model
display_cad_model(handles);

guidata(hObject, handles);


% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton7


handles.sub_label = 7;
handles.sub_index = 1;

% display cad model
display_cad_model(handles);

guidata(hObject, handles);


% --- Executes on button press in radiobutton8.
function radiobutton8_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton8

handles.sub_label = 8;
handles.sub_index = 1;

% display cad model
display_cad_model(handles);

guidata(hObject, handles);


% --- Executes on button press in radiobutton9.
function radiobutton9_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton9

handles.sub_label = 9;
handles.sub_index = 1;

% display cad model
display_cad_model(handles);

guidata(hObject, handles);


% --- Executes on button press in radiobutton10.
function radiobutton10_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton10

handles.sub_label = 10;
handles.sub_index = 1;

% display cad model
display_cad_model(handles);

guidata(hObject, handles);


% --- Executes on button press in radiobutton_cad1.
function radiobutton_cad1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_cad1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_cad1

handles.sub_index = 1;
for i = 1:12
    name = sprintf('radiobutton_cad%d', i);
    if i == handles.sub_index
        set(handles.(name), 'Value', 1);
    else
        set(handles.(name), 'Value', 0);
    end
end
guidata(hObject, handles);


% --- Executes on button press in radiobutton_cad2.
function radiobutton_cad2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_cad2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_cad2

handles.sub_index = 2;
for i = 1:12
    name = sprintf('radiobutton_cad%d', i);
    if i == handles.sub_index
        set(handles.(name), 'Value', 1);
    else
        set(handles.(name), 'Value', 0);
    end
end
guidata(hObject, handles);

% --- Executes on button press in radiobutton_cad3.
function radiobutton_cad3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_cad3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_cad3

handles.sub_index = 3;
for i = 1:12
    name = sprintf('radiobutton_cad%d', i);
    if i == handles.sub_index
        set(handles.(name), 'Value', 1);
    else
        set(handles.(name), 'Value', 0);
    end
end
guidata(hObject, handles);

% --- Executes on button press in radiobutton_cad4.
function radiobutton_cad4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_cad4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_cad4

handles.sub_index = 4;
for i = 1:12
    name = sprintf('radiobutton_cad%d', i);
    if i == handles.sub_index
        set(handles.(name), 'Value', 1);
    else
        set(handles.(name), 'Value', 0);
    end
end
guidata(hObject, handles);

% --- Executes on button press in radiobutton_cad5.
function radiobutton_cad5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_cad5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_cad5

handles.sub_index = 5;
for i = 1:12
    name = sprintf('radiobutton_cad%d', i);
    if i == handles.sub_index
        set(handles.(name), 'Value', 1);
    else
        set(handles.(name), 'Value', 0);
    end
end
guidata(hObject, handles);

% --- Executes on button press in radiobutton_cad6.
function radiobutton_cad6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_cad6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_cad6

handles.sub_index = 6;
for i = 1:12
    name = sprintf('radiobutton_cad%d', i);
    if i == handles.sub_index
        set(handles.(name), 'Value', 1);
    else
        set(handles.(name), 'Value', 0);
    end
end
guidata(hObject, handles);

% --- Executes on button press in radiobutton_cad7.
function radiobutton_cad7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_cad7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_cad7

handles.sub_index = 7;
for i = 1:12
    name = sprintf('radiobutton_cad%d', i);
    if i == handles.sub_index
        set(handles.(name), 'Value', 1);
    else
        set(handles.(name), 'Value', 0);
    end
end
guidata(hObject, handles);

% --- Executes on button press in radiobutton_cad8.
function radiobutton_cad8_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_cad8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_cad8

handles.sub_index = 8;
for i = 1:12
    name = sprintf('radiobutton_cad%d', i);
    if i == handles.sub_index
        set(handles.(name), 'Value', 1);
    else
        set(handles.(name), 'Value', 0);
    end
end
guidata(hObject, handles);

% --- Executes on button press in radiobutton_cad9.
function radiobutton_cad9_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_cad9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_cad9

handles.sub_index = 9;
for i = 1:12
    name = sprintf('radiobutton_cad%d', i);
    if i == handles.sub_index
        set(handles.(name), 'Value', 1);
    else
        set(handles.(name), 'Value', 0);
    end
end
guidata(hObject, handles);

% --- Executes on button press in radiobutton_cad10.
function radiobutton_cad10_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_cad10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_cad10

handles.sub_index = 10;
for i = 1:12
    name = sprintf('radiobutton_cad%d', i);
    if i == handles.sub_index
        set(handles.(name), 'Value', 1);
    else
        set(handles.(name), 'Value', 0);
    end
end
guidata(hObject, handles);

% --- Executes on button press in radiobutton_cad11.
function radiobutton_cad11_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_cad11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_cad11

handles.sub_index = 11;
for i = 1:12
    name = sprintf('radiobutton_cad%d', i);
    if i == handles.sub_index
        set(handles.(name), 'Value', 1);
    else
        set(handles.(name), 'Value', 0);
    end
end
guidata(hObject, handles);

% --- Executes on button press in radiobutton_cad12.
function radiobutton_cad12_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_cad12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_cad12

handles.sub_index = 12;
for i = 1:12
    name = sprintf('radiobutton_cad%d', i);
    if i == handles.sub_index
        set(handles.(name), 'Value', 1);
    else
        set(handles.(name), 'Value', 0);
    end
end
guidata(hObject, handles);
