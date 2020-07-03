function varargout = threshold(varargin)
% THRESHOLD MATLAB code for threshold.fig
%      THRESHOLD, by itself, creates a new THRESHOLD or raises the existing
%      singleton*.
%
%      H = THRESHOLD returns the handle to a new THRESHOLD or the handle to
%      the existing singleton*.
%
%      THRESHOLD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in THRESHOLD.M with the given input arguments.
%
%      THRESHOLD('Property','Value',...) creates a new THRESHOLD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before threshold_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to threshold_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help threshold

% Last Modified by GUIDE v2.5 03-Jul-2020 01:04:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @threshold_OpeningFcn, ...
                   'gui_OutputFcn',  @threshold_OutputFcn, ...
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


% --- Executes just before threshold is made visible.
function threshold_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to threshold (see VARARGIN)

% Initialization
global gMode gOrigin gFullPath gNumOfFrames;
gMode = -1;
gOrigin = 0;
gNumOfFrames = 0;

% Choose default command line output for threshold
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes threshold wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = threshold_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in img_open.
function img_open_Callback(hObject, eventdata, handles)
% hObject    handle to img_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gMode gOrigin gFullPath gNumOfFrames;

gMode = 0;
gOrigin = 0;
gNumOfFrames = 0;
[fileName, pathName] = uigetfile({'*.jpg;*.png;*.jpeg;*.bmp', 'Image (*.jpg,*.png,*.jpeg)';
                                  '*.*', 'All Files (*.*)'},...
                                  'Select an Image');
gFullPath = strcat(pathName, fileName);
try
    gOrigin = imread(gFullPath);
catch
    disp('Unable to open file!');
end
originShowFrame(handles, gOrigin);

resetState(handles);

% --- Executes on button press in video_open.
function video_open_Callback(hObject, eventdata, handles)
% hObject    handle to video_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gMode gOrigin gFullPath gNumOfFrames;

gMode = 1;
gOrigin = 0;
[fileName, pathName] = uigetfile({'*.mp4;*.avi;*.mkv', 'Video (*.mp4,*.avi,*.mkv)';
                                  '*.*', 'All Files (*.*)'},...
                                  'Select a Video');
gFullPath = strcat(pathName, fileName);
try
    gOrigin = VideoReader(gFullPath);
    gNumOfFrames = gOrigin.NumberOfFrames;
    clear gOrigin;
    gOrigin = VideoReader(gFullPath);
    firstFrame = readFrame(gOrigin);
    originShowFrame(handles, firstFrame);
catch
    disp('Unable to open file!');
end

resetState(handles);

% --- Executes on button press in global_proc_btn.
function global_proc_btn_Callback(hObject, eventdata, handles)
% hObject    handle to global_proc_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gMode gOrigin globalRes globalDone gNumOfFrames gFullPath;

if globalDone == 0
    handles.global_proc_btn.String = 'Processing';
    if gMode == 0
        tic
        globalRes = OtsuBin(gOrigin);
        globalShowFrame(handles, globalRes);
        eTime = toc;
        fprintf('Global elapsed time: %.2f\n', eTime);
    elseif gMode == 1
        clear gOrigin;
        gOrigin = VideoReader(gFullPath);
        globalRes = zeros(gOrigin.Height, gOrigin.Width, gNumOfFrames, 'uint8');
        i = 1;
        tic
        while hasFrame(gOrigin)
            curFrame = readFrame(gOrigin);
            globalRes(:, :, i) = OtsuBin(curFrame);
            i = i + 1;
            % if i == 30
            %     break;
            % end
        end
        eTime = toc;
        globalShowFrame(handles, globalRes(:, :, 1));
        fprintf('Global Done! FPS = %.2f\n', gNumOfFrames / eTime);
    end
    globalDone = 1;
    handles.global_proc_btn.String = 'Done';
end

% --- Executes on button press in global_play_btn.
function global_play_btn_Callback(hObject, eventdata, handles)
% hObject    handle to global_play_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gNumOfFrames globalRes gOrigin gMode globalDone;

if gMode == 1
    if globalDone == 1
        handles.global_play_btn.String = 'Playing';
        for i = 1 : gNumOfFrames
            globalShowFrame(handles, globalRes(:, :, i));
            pause(1 / (gOrigin.FrameRate + 100));
        end
        handles.global_play_btn.String = 'Play';
    end
end

% --- Executes on button press in int_proc_btn.
function int_proc_btn_Callback(hObject, eventdata, handles)
% hObject    handle to int_proc_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gMode gOrigin intRes intDone gNumOfFrames gFullPath;

if intDone == 0
    handles.int_proc_btn.String = 'Processing';
    if gMode == 0
        tic
        intRes = bradley(img2grayT(gOrigin), [15 15], 8);
        % gray = rgb2gray(gOrigin);
        % T = adaptthresh(gray, 0.9);
        % intRes = imbinarize(gray, T);
        intShowFrame(handles, intRes);
        eTime = toc;
        fprintf('Integral elapsed time: %.2f\n', eTime);
    elseif gMode == 1
        clear gOrigin;
        gOrigin = VideoReader(gFullPath);
        intRes = zeros(gOrigin.Height, gOrigin.Width, gNumOfFrames, 'uint8');
        i = 1;
        tic
        while hasFrame(gOrigin)
            curFrame = readFrame(gOrigin);
            intRes(:, :, i) = bradley(img2grayT(curFrame), [15 15], 8);
            i = i + 1;
            % if i == 30
            %     break;
            % end
        end
        eTime = toc;
        fprintf('Integral Done! FPS = %.2f\n', gNumOfFrames / eTime);
        intShowFrame(handles, intRes(:, :, 1));
    end
    intDone = 1;
    handles.int_proc_btn.String = 'Done';
end

% --- Executes on button press in int_play_btn.
function int_play_btn_Callback(hObject, eventdata, handles)
% hObject    handle to int_play_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gNumOfFrames intRes gOrigin gMode intDone;

if gMode == 1
    if intDone == 1
        handles.int_play_btn.String = 'Playing';
        for i = 1 : gNumOfFrames
            intShowFrame(handles, intRes(:, :, i));
            pause(1 / (gOrigin.FrameRate + 100));
        end
        handles.int_play_btn.String = 'Play';
    end
end

% --- Executes on button press in gauss_proc_btn.
function gauss_proc_btn_Callback(hObject, eventdata, handles)
% hObject    handle to gauss_proc_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gMode gOrigin gaussRes gaussDone gNumOfFrames gFullPath;

if gaussDone == 0
    handles.gauss_proc_btn.String = 'Processing';
    if gMode == 0
        tic
        gaussRes = adaptivethreshold(gOrigin, 15, 0.025);
        gaussShowFrame(handles, gaussRes);
        eTime = toc;
        fprintf('Gauss elapsed time: %.2f\n', eTime);
    elseif gMode == 1
        clear gOrigin;
        gOrigin = VideoReader(gFullPath);
        gaussRes = zeros(gOrigin.Height, gOrigin.Width, gNumOfFrames, 'uint8');
        i = 1;
        tic
        while hasFrame(gOrigin)
            curFrame = readFrame(gOrigin);
            gaussRes(:, :, i) = adaptivethreshold(curFrame, 15, 0.025);
            i = i + 1;
            % if i == 30
            %     break;
            % end
        end
        eTime = toc;
        gaussShowFrame(handles, gaussRes(:, :, 1));
        fprintf('Gauss Done! FPS = %.2f\n', gNumOfFrames / eTime);
    end
    gaussDone = 1;
    handles.gauss_proc_btn.String = 'Done';
end

% --- Executes on button press in gauss_play_btn.
function gauss_play_btn_Callback(hObject, eventdata, handles)
% hObject    handle to gauss_play_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gNumOfFrames gaussRes gOrigin gMode gaussDone;

if gMode == 1
    if gaussDone == 1
        handles.gauss_play_btn.String = 'Playing';
        for i = 1 : gNumOfFrames
            gaussShowFrame(handles, gaussRes(:, :, i));
            pause(1 / (gOrigin.FrameRate + 100));
        end
        handles.gauss_play_btn.String = 'Play';
    end
end

function originShowFrame(handles, frame)

axes(handles.original);
imshow(frame);

function gaussShowFrame(handles, frame)
axes(handles.adap_mean);
imshow(logical(frame));

function intShowFrame(handles, frame)
axes(handles.adap_int);
imshow(logical(frame));

function globalShowFrame(handles, frame)
axes(handles.global_th);
imshow(logical(frame));

function bw=adaptivethreshold(IM,ws,C,tm)
% ADAPTIVETHRESHOLD An adaptive thresholding algorithm that seperates the
% foreground from the background with nonuniform illumination.
% bw=adaptivethreshold(IM,ws,C) outputs a binary image bw with the local 
% threshold mean-C or median-C to the image IM.
% ws is the local window size.
% tm is 0 or 1, a switch between mean and median. tm=0 mean(default); tm=1 median.
 
if (nargin < 3)
    error('You must provide the image IM, the window size ws, and C.');
elseif (nargin == 3)
    tm = 0;
elseif (tm ~= 0 && tm ~= 1)
    error('tm must be 0 or 1.');
end
 
IM = mat2gray(IM);
 
if tm == 0
    mIM = imfilter(IM,fspecial('average', ws), 'replicate');
else
    mIM = medfilt2(IM, [ws ws]);
end
sIM = mIM - IM - C;
bw = im2bw(sIM, 0);
bw = imcomplement(bw);
% bw = bw * 255;
% bw = uint8(bw);

% --- Executes on button press in int_save.
function int_save_Callback(hObject, eventdata, handles)
% hObject    handle to int_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gMode intRes intDone gNumOfFrames;

if intDone == 0
    return;
end

if gMode == 0
    name = getSaveNameImg();
    if ~isempty(name)
        imwrite(intRes, name, 'jpg');
        disp('Integral write done!');
    end

elseif gMode == 1
    name = getSaveNameVid();
    if ~isempty(name)
        output = VideoWriter(name);
        open(output);
        for i = 1 : gNumOfFrames
            writeVideo(output, single(intRes(:, :, i)));
        end
        close(output);
        disp('Integral saved!');
    end
end

% --- Executes on button press in gauss_save.
function gauss_save_Callback(hObject, eventdata, handles)
% hObject    handle to gauss_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gMode gaussRes gaussDone gNumOfFrames;

if gaussDone == 0
    return;
end

if gMode == 0
    name = getSaveNameImg();
    if ~isempty(name)
        imwrite(gaussRes, name, 'jpg');
        disp('Gauss write done!');
    end

elseif gMode == 1
    name = getSaveNameVid();
    if ~isempty(name)
        output = VideoWriter(name);
        open(output);
        for i = 1 : gNumOfFrames
            writeVideo(output, single(gaussRes(:, :, i)));
        end
        close(output);
        disp('Gauss saved!');
    end
end

% --- Executes on button press in global_save.
function global_save_Callback(hObject, eventdata, handles)
% hObject    handle to global_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gMode globalRes globalDone gNumOfFrames;

if globalDone == 0
    return;
end

if gMode == 0
    name = getSaveNameImg();
    if ~isempty(name)
        imwrite(globalRes, name, 'jpg');
        disp('Global write done!');
    end

elseif gMode == 1
    name = getSaveNameVid();
    if ~isempty(name)
        output = VideoWriter(name);
        open(output);
        for i = 1 : gNumOfFrames
            writeVideo(output, single(globalRes(:, :, i)));
        end
        close(output);
        disp('Global saved!');
    end
end

function resetState(handles)
global gaussDone globalDone intDone;
    gaussDone = 0;
    globalDone = 0;
    intDone = 0;

    handles.gauss_proc_btn.String = 'Process';
    handles.global_proc_btn.String = 'Process';
    handles.int_proc_btn.String = 'Process';

function name = getSaveNameImg()
    filter = {'*.jpg', 'Image (*.jpg)'; '*.*', 'All Files (*.*)'};
    [file, path] = uiputfile(filter, 'Save File');
    name = strcat(path, file);

function name = getSaveNameVid()
    filter = {'*.avi', 'Video (*.avi)'};
    [file, path] = uiputfile(filter, 'Save File');
    name = strcat(path, file);

function res = img2grayT(img)
    res = img;
    try
        res = rgb2gray(img);
    catch
        disp('Not RGB');
    end

function res = OtsuBin(img)
    img = img2grayT(img);
    level = graythresh(img);
    res = imbinarize(img, level);
