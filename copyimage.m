function varargout = copyimage(varargin)
% COPYIMAGE M-file for copyimage.fig
%      COPYIMAGE, by itself, creates a new COPYIMAGE or raises the existing
%      singleton*.
%
%      H = COPYIMAGE returns the handle to a new COPYIMAGE or the handle to
%      the existing singleton*.
%
%      COPYIMAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COPYIMAGE.M with the given input arguments.
%
%      COPYIMAGE('Property','Value',...) creates a new COPYIMAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before copyimage_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to copyimage_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help copyimage

% Last Modified by GUIDE v2.5 19-Aug-2013 20:14:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @copyimage_OpeningFcn, ...
                   'gui_OutputFcn',  @copyimage_OutputFcn, ...
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


% --- Executes just before copyimage is made visible.
function copyimage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to copyimage (see VARARGIN)

% Choose default command line output for copyimage
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes copyimage wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = copyimage_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_source.
function pushbutton_source_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_source (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
directory_name = uigetdir;
if isequal(directory_name,0)
   return;
end
set(handles.text_source, 'String', directory_name);
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
            set(handles.pushbutton_dest, 'Enable', 'On');
            set(handles.pushbutton_prev, 'Enable', 'On');
            set(handles.pushbutton_next, 'Enable', 'On');
            set(handles.pushbutton_nextten, 'Enable', 'On');
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
    handles.filename = filename;
    handles.source_dir = directory_name;
    handles.dest_dir = directory_name;
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
if isequal(directory_name,0)
   return;
end
set(handles.text_dest, 'String', directory_name);
% parse the directory name
index = strfind(directory_name, '/');
s = index(length(index)-1)+1;
e = index(length(index))-1;
sub_name = directory_name(s:e);
index = strfind(sub_name, '_');
cls = sub_name(1:index(1)-1);

% set radio button names
switch cls
    case 'aeroplane'
        pnames = {'airliner', 'fighter', 'propeller', 'others'};
    case 'bicycle'
        pnames = {'mountain', 'race', 'tandem', 'others'}; 
    case 'boat'
        pnames = {'cabin', 'cargo', 'cruise', 'rowing', 'sailing', 'others'}; 
    case 'bottle'
        pnames = {'beer', 'ketchup', 'pop', 'water', 'wine', 'others'};
    case 'bus'
        pnames = {'double', 'long', 'school', 'others'};
    case 'car'
        pnames = {'hatchback', 'mini', 'minivan', 'race', 'sedan', 'SUV', 'truck', 'wagon', 'others'};
    case 'chair'
        pnames = {'folding', 'lounge', 'straight', 'swivel', 'others'};
    case 'diningtable'
        pnames = {'ellipse', 'rectangle', 'round', 'square', 'others'};
    case 'motorbike'
        pnames = {'cruiser', 'scooter', 'sport', 'trail', 'others'};  
    case 'sofa'
        pnames = {'one', 'two', 'three', 'more', 'others'}; 
    case 'train'
        pnames = {'bullet', 'steam', 'body', 'others'}; 
    case 'tvmonitor'
        pnames = {'tv', 'hdtv', 'crtmonitor', 'lcdmonitor', 'others'};         
    otherwise
        errordlg('subcategory not define!');
end

for i = 1:10
    id = sprintf('radiobutton%d', i);
    if i <= numel(pnames)
        set(handles.(id), 'String', pnames{i});
        set(handles.(id), 'Enable', 'On');
    else
        set(handles.(id), 'String', '');
    end
end
set(handles.radiobutton10, 'Value', 1.0);
handles.dest_dir = directory_name;
handles.pnames = pnames;
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
    handles.name = name;
    handles.filename = filename;
    handles.filepos = i;
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
        end
    end
    i = i - 1;
end
if flag == 0
    errordlg('No previous image');
else
    handles.image = I;
    handles.name = name;
    handles.filename = filename;
    handles.filepos = i + 2;
    guidata(hObject, handles);
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
pnames = handles.pnames;
if numel(pnames) >= 1
    src_path = fullfile(handles.source_dir, handles.filename);
    dest_path = fullfile(handles.dest_dir, pnames{1}, handles.filename);
    copyfile(src_path, dest_path);
    pushbutton_next_Callback(hObject, eventdata, handles);
    set(handles.radiobutton10, 'Value', 1.0);
end


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
pnames = handles.pnames;
if numel(pnames) >= 2
    src_path = fullfile(handles.source_dir, handles.filename);
    dest_path = fullfile(handles.dest_dir, pnames{2}, handles.filename);
    copyfile(src_path, dest_path);
    pushbutton_next_Callback(hObject, eventdata, handles);
    set(handles.radiobutton10, 'Value', 1.0);
end


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3
pnames = handles.pnames;
if numel(pnames) >= 3
    src_path = fullfile(handles.source_dir, handles.filename);
    dest_path = fullfile(handles.dest_dir, pnames{3}, handles.filename);
    copyfile(src_path, dest_path);
    pushbutton_next_Callback(hObject, eventdata, handles);
    set(handles.radiobutton10, 'Value', 1.0);
end


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4
pnames = handles.pnames;
if numel(pnames) >= 4
    src_path = fullfile(handles.source_dir, handles.filename);
    dest_path = fullfile(handles.dest_dir, pnames{4}, handles.filename);
    copyfile(src_path, dest_path);
    pushbutton_next_Callback(hObject, eventdata, handles);
    set(handles.radiobutton10, 'Value', 1.0);
end


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5
pnames = handles.pnames;
if numel(pnames) >= 5
    src_path = fullfile(handles.source_dir, handles.filename);
    dest_path = fullfile(handles.dest_dir, pnames{5}, handles.filename);
    copyfile(src_path, dest_path);
    pushbutton_next_Callback(hObject, eventdata, handles);
    set(handles.radiobutton10, 'Value', 1.0);
end


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6
pnames = handles.pnames;
if numel(pnames) >= 6
    src_path = fullfile(handles.source_dir, handles.filename);
    dest_path = fullfile(handles.dest_dir, pnames{6}, handles.filename);
    copyfile(src_path, dest_path);
    pushbutton_next_Callback(hObject, eventdata, handles);
    set(handles.radiobutton10, 'Value', 1.0);
end


% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton7
pnames = handles.pnames;
if numel(pnames) >= 7
    src_path = fullfile(handles.source_dir, handles.filename);
    dest_path = fullfile(handles.dest_dir, pnames{7}, handles.filename);
    copyfile(src_path, dest_path);
    pushbutton_next_Callback(hObject, eventdata, handles);
    set(handles.radiobutton10, 'Value', 1.0);
end


% --- Executes on button press in radiobutton8.
function radiobutton8_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton8
pnames = handles.pnames;
if numel(pnames) >= 8
    src_path = fullfile(handles.source_dir, handles.filename);
    dest_path = fullfile(handles.dest_dir, pnames{8}, handles.filename);
    copyfile(src_path, dest_path);
    pushbutton_next_Callback(hObject, eventdata, handles);
    set(handles.radiobutton10, 'Value', 1.0);
end


% --- Executes on button press in radiobutton9.
function radiobutton9_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton9
pnames = handles.pnames;
if numel(pnames) >= 9
    src_path = fullfile(handles.source_dir, handles.filename);
    dest_path = fullfile(handles.dest_dir, pnames{9}, handles.filename);
    copyfile(src_path, dest_path);
    pushbutton_next_Callback(hObject, eventdata, handles);
    set(handles.radiobutton10, 'Value', 1.0);
end


% --- Executes on button press in pushbutton_nextten.
function pushbutton_nextten_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_nextten (see GCBO)
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
            I = imread(fullfile(directory_name, filename));
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
    handles.name = name;
    handles.filename = filename;
    handles.filepos = i;
    guidata(hObject, handles);
end