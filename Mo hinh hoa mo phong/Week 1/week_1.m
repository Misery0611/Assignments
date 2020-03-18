function varargout = week_1(varargin)
% WEEK_1 MATLAB code for week_1.fig
%      WEEK_1, by itself, creates a new WEEK_1 or raises the existing
%      singleton*.
%
%      H = WEEK_1 returns the handle to a new WEEK_1 or the handle to
%      the existing singleton*.
%
%      WEEK_1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WEEK_1.M with the given input arguments.
%
%      WEEK_1('Property','Value',...) creates a new WEEK_1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before week_1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to week_1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help week_1

% Last Modified by GUIDE v2.5 15-Mar-2020 17:31:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @week_1_OpeningFcn, ...
                   'gui_OutputFcn',  @week_1_OutputFcn, ...
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


% global g_items_text
% global g_display
% global g_handler       % reference to the handles

% --- Executes just before week_1 is made visible.
function week_1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to week_1 (see VARARGIN)

% Global variables
global g_handler g_display g_items_text g_items_form new_equation g_items_text_length g_cursor_pos g_display_width g_cursor_char;

g_cursor_char = "&#9646;";

% Item table
% 0,    1,      2,      3,      4,      5,      6,      7,      8,      9,
% '.',  ???,      euler,  +,      -,      ×,      ÷,      sin,    cos,    tan,
% cot,  sqr,    pow,    loga,   ln,     fact,   abs,    (,      ),

g_items_text = ...
['0',       '1',            '2',        '3',        '4',        '5',        '6',        '7',        '8',        '9',...
 '.',       "&#120587;",    'e',        '+',        '-',        "&#215;",   "&#247;",   "sin(",     "cos(",     "tan(",...
 "cot(",    "sqrt(",        "^",        "Log(",     "Ln(",      "fact(",    "abs(",     '(',        ')'];    % contain text of supported items

g_items_text_length = ...
[ 1,        1,              1,          1,          1,          1,          1,          1,          1,          1,...
  1,        1,              1,          1,          1,          1,          1,          4,          4,          4,...
  4,        5,              1,          4,          3,          5,          4,          1,          1];

g_items_form = ...
['0',       '1',        '2',        '3',        '4',        '5',            '6',        '7',        '8',        '9', ...
 '.',       "pi",       "exp(1)",   '+',        '-',        '*',            '/',        "sin(",     "cos(",     "tan(",...
 "cot(",    "sqrt(",    "^",        "log10(",   "log(",     "factorial(",   "abs(",     '(',        ')'];

g_display = [];        % hold all current codes of entered items
g_handler = handles;   % reference to the handles
new_equation = 1;
g_cursor_pos = 1;
g_display_width = 29;
update_display();

% Choose default command line output for week_1
handles.output = hObject;
set(handles.display, 'fontsize', 18)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes week_1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = week_1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in num1.
function num1_Callback(hObject, eventdata, handles)
% hObject    handle to num1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    insert_display(2);

% --- Executes on button press in num0.
function num0_Callback(hObject, eventdata, handles)
% hObject    handle to num0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    insert_display(1);

% --- Executes on button press in num2.
function num2_Callback(hObject, eventdata, handles)
% hObject    handle to num2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    insert_display(3);

% --- Executes on button press in num3.
function num3_Callback(hObject, eventdata, handles)
% hObject    handle to num3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    insert_display(4);

% --- Executes on button press in num4.
function num4_Callback(hObject, eventdata, handles)
% hObject    handle to num4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    insert_display(5);

% --- Executes on button press in num5.
function num5_Callback(hObject, eventdata, handles)
% hObject    handle to num5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    insert_display(6);

% --- Executes on button press in num6.
function num6_Callback(hObject, eventdata, handles)
% hObject    handle to num6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    insert_display(7);

% --- Executes on button press in num7.
function num7_Callback(hObject, eventdata, handles)
% hObject    handle to num7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    insert_display(8);

% --- Executes on button press in num8.
function num8_Callback(hObject, eventdata, handles)
% hObject    handle to num8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    insert_display(9);

% --- Executes on button press in num9.
function num9_Callback(hObject, eventdata, handles)
% hObject    handle to num9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    insert_display(10);

% --- Executes on button press in del_btn.
function del_btn_Callback(hObject, eventdata, handles)
% hObject    handle to del_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global g_display g_cursor_pos;
    len = size(g_display);
    len = len(2);

    if g_cursor_pos > 1
        temp = [g_display(1, 1 : (g_cursor_pos - 2)) ];
        if g_cursor_pos <= len
            g_display = [temp g_display(1, g_cursor_pos : len)];
        else
            g_display = temp;
        end
        g_cursor_pos = g_cursor_pos - 1;
    end
    update_display();

% --- Executes on button press in ac_btn.
function ac_btn_Callback(hObject, eventdata, handles)
% hObject    handle to ac_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    clear_display();

% --- Executes on button press in mul_btn.
function mul_btn_Callback(hObject, eventdata, handles)
% hObject    handle to mul_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    insert_display(16);

% --- Executes on button press in div_btn.
function div_btn_Callback(hObject, eventdata, handles)
% hObject    handle to div_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    insert_display(17);

% --- Executes on button press in add_btn.
function add_btn_Callback(hObject, eventdata, handles)
% hObject    handle to add_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    insert_display(14);

% --- Executes on button press in sub_btn.
function sub_btn_Callback(hObject, eventdata, handles)
% hObject    handle to sub_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    insert_display(15);

% --- Executes on button press in dot_btn.
function dot_btn_Callback(hObject, eventdata, handles)
% hObject    handle to dot_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    insert_display(11)

% --- Executes on button press in calc_btn.
function calc_btn_Callback(hObject, eventdata, handles)
% hObject    handle to calc_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global g_handler g_display g_items_form new_equation;
    len = size(g_display);
    len = len(2);
    str = "";
    for i = 1 : len
        str = str + g_items_form(g_display(i));
    end
    str
    try
        result = eval(str);
        set(g_handler.result, 'string', num2str(result, 15));
    catch ME
        set(g_handler.result, 'string', "Syntax Error!");
    end

    new_equation = 1;


% --- Executes on button press in pi_const.
function pi_const_Callback(hObject, eventdata, handles)
% hObject    handle to pi_const (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    insert_display(12);

% --- Executes on button press in euler_const.
function euler_const_Callback(hObject, eventdata, handles)
% hObject    handle to euler_const (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    insert_display(13);

% Append to display
function insert_display(item_code)
    global g_display new_equation g_cursor_pos;

    if new_equation == 1
        new_equation = 0;
        clear_display();
    end

    len = size(g_display);
    len = len(2);
    if len == 0
        g_display = [item_code];
    else
        g_display = [g_display(1, 1 : (g_cursor_pos - 1)) item_code g_display(1, g_cursor_pos : len)];
    end
    g_cursor_pos = g_cursor_pos + 1;
    update_display();

% Update the display
function update_display()
    global g_handler g_display g_items_text g_items_text_length g_cursor_pos g_display_width g_cursor_char;

    len = size(g_display);
    len = len(2);
    rear_len = 0;
    if len >= g_cursor_pos
        rear_len = strlength(g_items_text(g_display(g_cursor_pos)));
    end

    len = 0;
    str = "";
    for i = 1 : (g_cursor_pos - 1)
        str = str + g_items_text(g_display(i));
        len = len + g_items_text_length(g_display(i));
    end

    %rear_len
    %len
    if len + 1 + rear_len > g_display_width - 2     % two slots for left, right triangles
        abandoned = 0;
        for i = 1 : (g_cursor_pos - 1)
            abandoned = abandoned + g_items_text_length(g_display(i));
            if len - abandoned + 1 + rear_len <= g_display_width - 2
                str = "";
                for j = (i + 1) : (g_cursor_pos - 1)
                    str = str + g_items_text(g_display(j));
                end
                break;
            end
        end

        str = "<html>&#9664;" + str + g_cursor_char;
        if rear_len > 0
            str = str + g_items_text(g_display(g_cursor_pos));
        end

        len = size(g_display);
        len = len(2);
        if g_cursor_pos < len
            str = str + "&#9654;";
        end

    else
        str = "<html>" + str + g_cursor_char;
        strlen = len + 1;  % 1 space for cursor
        len = size(g_display);
        len = len(2);
        whole = 1;
        for i = g_cursor_pos : len
            if g_items_text_length(g_display(i)) + strlen > g_display_width - 2
                whole = 0;
                break
            else
                str = str + g_items_text(g_display(i));
                strlen = strlen + g_items_text_length(g_display(i));
            end
        end

        len = size(g_display);
        len = len(2);
        if (g_cursor_pos < len) & (whole == 0)
            str = str + "&#9654;";
        end
    end


    set(g_handler.display, 'string', str);

function clear_display()
    global g_handler g_display g_cursor_pos;
    g_display = [];
    g_cursor_pos = 1;
    update_display();


% --- Executes on button press in sin_btn.
function sin_btn_Callback(hObject, eventdata, handles)
% hObject    handle to sin_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    insert_display(18)

% --- Executes on button press in cos_btn.
function cos_btn_Callback(hObject, eventdata, handles)
% hObject    handle to cos_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    insert_display(19)

% --- Executes on button press in tan_btn.
function tan_btn_Callback(hObject, eventdata, handles)
% hObject    handle to tan_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    insert_display(20)

% --- Executes on button press in left_move_btn.
function left_move_btn_Callback(hObject, eventdata, handles)
% hObject    handle to left_move_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global g_cursor_pos g_display new_equation;
    new_equation = 0;
    len = size(g_display);
    len = len(2);
    if g_cursor_pos > 1
        g_cursor_pos = g_cursor_pos - 1;
    else
        g_cursor_pos = len + 1;
    end
    update_display();

% --- Executes on button press in right_move_btn.
function right_move_btn_Callback(hObject, eventdata, handles)
% hObject    handle to right_move_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global g_cursor_pos g_display new_equation;
    new_equation = 0;
    len = size(g_display);
    len = len(2);
    if g_cursor_pos <= len
        g_cursor_pos = g_cursor_pos + 1;
    else
        g_cursor_pos = 1;
    end
    update_display();

% --- Executes on button press in cot_btn.
function cot_btn_Callback(hObject, eventdata, handles)
% hObject    handle to cot_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    insert_display(21)

% --- Executes on button press in abs_btn.
function abs_btn_Callback(hObject, eventdata, handles)
% hObject    handle to abs_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    insert_display(27)

% --- Executes on button press in pow_btn.
function pow_btn_Callback(hObject, eventdata, handles)
% hObject    handle to pow_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    insert_display(23)

% --- Executes on button press in sqr_btn.
function sqr_btn_Callback(hObject, eventdata, handles)
% hObject    handle to sqr_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    insert_display(22)

% --- Executes on button press in loga_btn.
function loga_btn_Callback(hObject, eventdata, handles)
% hObject    handle to loga_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    insert_display(24)

% --- Executes on button press in natural_log_btn.
function natural_log_btn_Callback(hObject, eventdata, handles)
% hObject    handle to natural_log_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    insert_display(25)

% --- Executes on button press in factorial_btn.
function factorial_btn_Callback(hObject, eventdata, handles)
% hObject    handle to factorial_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    insert_display(26)

% --- Executes on button press in open_bracket_btn.
function open_bracket_btn_Callback(hObject, eventdata, handles)
% hObject    handle to open_bracket_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    insert_display(28)

% --- Executes on button press in close_bracket_btn.
function close_bracket_btn_Callback(hObject, eventdata, handles)
% hObject    handle to close_bracket_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    insert_display(29)
