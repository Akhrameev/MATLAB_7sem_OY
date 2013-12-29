function varargout = res(varargin)
%RES M-file for res.fig
%      RES, by itself, creates a new RES or raises the existing
%      singleton*.
%
%      H = RES returns the handle to a new RES or the handle to
%      the existing singleton*.
%
%      RES('Property','Value',...) creates a new RES using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to res_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      RES('CALLBACK') and RES('CALLBACK',hObject,...) call the
%      local function named CALLBACK in RES.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help res

% Last Modified by GUIDE v2.5 26-Dec-2013 13:59:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @res_OpeningFcn, ...
                   'gui_OutputFcn',  @res_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before res is made visible.
function res_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for res
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes res wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global X T U;

global lineStyleControl lineWidthControl lineColorControl;
global lineStyle lineWidth lineColor;
global trajectoryDimension managementDimension;

global html_first html_th_open html_th_close html_table_first;
global html_horiz html_vertic_alt html_vertic html_last;
global statisticsShown;
fid = fopen('Settings/fin.txt','r');
JV = fscanf(fid,'%f');
set(handles.Zname,'String',fscanf(fid,'%c'));
fclose(fid);		  
html_first = 'Settings/resultTableHtml_first.txt';
html_th_open = 'Settings/resultTableHtml_th_open.txt';
html_th_close = 'Settings/resultTableHtml_th_close.txt';
html_table_first = 'Settings/resultTableHtml_table_start.txt';
html_horiz = 'Settings/resultTableHtml_horiz.txt';
html_vertic_alt = 'Settings/resultTableHtml_vertic_alt.txt';
html_vertic = 'Settings/resultTableHtml_vertic.txt';
html_last = 'Settings/resultTableHtml_last.txt';
html_first = ['file:///' fullfile(pwd,html_first)];
html_th_open = ['file:///' fullfile(pwd,html_th_open)];
html_th_close = ['file:///' fullfile(pwd,html_th_close)];
html_table_first = ['file:///' fullfile(pwd,html_table_first)];
html_horiz = ['file:///' fullfile(pwd,html_horiz)];
html_vertic_alt = ['file:///' fullfile(pwd,html_vertic_alt)];
html_vertic = ['file:///' fullfile(pwd,html_vertic)];
html_last = ['file:///' fullfile(pwd,html_last)];
try
    html_first = urlread(html_first);
    html_th_open = urlread(html_th_open);
    html_th_close = urlread(html_th_close);
    html_table_first = urlread(html_table_first);
    html_horiz = urlread(html_horiz);
    html_vertic_alt = urlread(html_vertic_alt);
    html_vertic = urlread(html_vertic);
    html_last = urlread(html_last);
    
    html = strcat(html_first,html_th_open,'Статистика',html_th_close,html_table_first);
    html = strcat(html, 'Функционал J(u)',html_horiz,num2str(JV(1)),html_vertic_alt);
    html = strcat(html,'Количество итераций',html_horiz,num2str(JV(2)),html_vertic);
    html = strcat(html,'Достигнутая точность',html_horiz,num2str(JV(3)));
    html = strcat(html,html_vertic_alt,'Время вычислений',html_horiz,num2str(JV(4)),html_last);
    hfig = handles.figres;
    jLabel = javaObjectEDT('javax.swing.JLabel',html);
    [hcomponent, hcontainer] = javacomponent(jLabel, [], hfig);
    position = get (hcontainer, 'Position');
    position(1)=15;
    position(2)=6;
    position(3)=401;
    position(4)=134;
    set(hcontainer,  'Position', position);
    statisticsShown = true;
catch e
    
end


try
    m = floor(0.5*length(T));
    tr = get(handles.track,'Data');
    for i = 1:trajectoryDimension
        if tr{i,1} == 1
            plot(handles.plotter,T,X(:,i),strcat(lineStyle,lineColor),'LineWidth',lineWidth); 
            text(T(m),X(m,i),sprintf('x%d(t)',i));
        end
    end
catch e
    
end

try
    tr = get(handles.uctrl,'Data');
    for i = 1:managementDimension
        if tr{i,1} == 1
            plot(handles.plotc,T,U(:,i),strcat(lineStyleControl,lineColorControl),'LineWidth',lineWidthControl); 
            text(T(m),U(m,i),sprintf('u%d(t)',i));
        end
    end
catch e
    
end

addpath ('JavaWaitbar/');
createWaitbar (handles.figres, waitbarTag());
makeWaitbarContinious (waitbarTag());
correctWaitbarPosition (handles);

set (hObject, 'Name', 'Результат расчета задачи оптимального управления');

function tag = waitbarTag ()
tag = 'res';

% --- Outputs from this function are returned to the command line.
function varargout = res_OutputFcn(hObject, eventdata, handles)

global X T U;
global trajectoryDimension managementDimension;

global html_first html_th_open html_th_close html_table_first;
global html_horiz html_vertic_alt html_vertic html_last;

% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
try
    showWaitbar (waitbarTag());
    TrName = cell(1,trajectoryDimension+1); 
    CName = cell(1,managementDimension+1);
    Tr = [T X];
    C = [T U];
    TrName{1} = 'T';
    CName{1} = 'T';
    for i = 2:trajectoryDimension+1
        TrName{i} = sprintf('x%d',i-1);
    end
    for i = 2:managementDimension+1
        CName{i} = sprintf('u%d',i-1);
    end
    
    %заполнение первой таблицы
    html = html_first;
    for i = 1:trajectoryDimension+2
        if i==1
            html = strcat(html, html_th_open,'№', html_th_close);
        else
            html = strcat(html, html_th_open,TrName{i-1}, html_th_close);
        end
    end
    html = strcat(html, html_table_first);
    sizeT = size(T);
    for i = 1:sizeT(1)
        for j = 1:trajectoryDimension+2
           if j == 1
               html = strcat(html, num2str(j));
           else
               html = strcat(html, num2str(Tr(i,j-1)));
           end
           if j < trajectoryDimension+2
               html = strcat(html,html_horiz);
           end
        end
        if mod(i,2) == 0
            html = strcat(html,html_vertic);
        else
            html = strcat(html,html_vertic_alt);
        end
    end
    html = strcat(html,html_last);
    hfig = handles.figres;
    jLabel = javaObjectEDT('javax.swing.JLabel',html);
    jp = javax.swing.JScrollPane(jLabel)
    [hcomponent, hcontainer] = javacomponent(jp, [], hfig);
    position = get (hcontainer, 'Position');
    position(1)=410;
    position(2)=6;
    position(3)=229;
    position(4)=719;
    set(hcontainer,  'Position', position);
    
    %заполнение второй таблицы
    html = html_first;
    for i = 1:managementDimension+2
        if i==1
            html = strcat(html, html_th_open,'№', html_th_close);
        else
            html = strcat(html, html_th_open,CName{i-1}, html_th_close);
        end
    end
    html = strcat(html, html_table_first);
    for i = 1:sizeT(1)
        for j = 1:managementDimension+2
            if j == 1
               html = strcat(html, num2str(j));
           else
               html = strcat(html, num2str(C(i,j-1)));
            end
           if j < managementDimension+2
               html = strcat(html,html_horiz);
           end
        end
        if mod(i,2) == 0
            html = strcat(html,html_vertic);
        else
            html = strcat(html,html_vertic_alt);
        end
    end
    html = strcat(html,html_last);
    hfig = handles.figres;
    jLabel = javaObjectEDT('javax.swing.JLabel',html);
    jp = javax.swing.JScrollPane(jLabel)
    [hcomponent, hcontainer] = javacomponent(jp, [], hfig);
    position = get (hcontainer, 'Position');
    position(1)=1050;
    position(2)=6;
    position(3)=291;
    position(4)=716;
    set(hcontainer,  'Position', position);
    
catch err
    disp(err.message)
    
    TrName = cell(1,trajectoryDimension+1); 
    CName = cell(1,managementDimension+1);
    Tr = [T X];
    C = [T U];
    TrName{1} = 'T';
    CName{1} = 'T';
    for i = 2:trajectoryDimension+1
        TrName{i} = sprintf('x%d',i-1);
    end
    for i = 2:managementDimension+1
        CName{i} = sprintf('u%d',i-1);
    end
    set(handles.trres,'ColumnName',TrName,'Data',Tr);
    set(handles.trres,'Visible','on');
    set(handles.ures,'ColumnName',CName,'Data',C);
    set(handles.ures,'Visible','on');
end

try
   redraw_Callback (0, 0, handles);
   redrawc_Callback(0, 0, handles);
catch e
    
end

closeWaitbar (waitbarTag());

function correctWaitbarPosition (handles)
position = get (handles.plotc, 'Position');
position(1)=410;
position(2)=697;
position(3)=228;
position(4)=24;
updateWaitbarPosition (position, waitbarTag());

function Zname_Callback(hObject, eventdata, handles)
% hObject    handle to Zname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Zname as text
%        str2double(get(hObject,'String')) returns contents of Zname as a double


% --- Executes during object creation, after setting all properties.
function Zname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Zname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function J_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to J_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on button press in redrawc.
function redrawc_Callback(hObject, eventdata, handles)
% hObject    handle to redrawc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global T U managementDimension;
global lineStyleControl lineWidthControl lineColorControl;
global SXU SYU;
set(gcf,'CurrentAxes',handles.plotc);
cla reset;
hold all;
m = floor(0.5*length(T));
tr = get(handles.uctrl,'Data');
    for i = 1:managementDimension
        if tr{i,1} == 1
            plot(T,U(:,i),strcat(lineStyleControl,lineColorControl),'LineWidth',lineWidthControl); 
            text(T(m),U(m,i),sprintf('u%d(t)',i));
        end
    end
if SXU ~= SYU
    Xl = get(gca,'XLim');
    Yl = get(gca,'YLim');
    xl1 = (Xl(1)+Xl(2))/2 - SYU*(Xl(2)-Xl(1))/(2*SXU);
    xl2 = (Xl(1)+Xl(2))/2 + SYU*(Xl(2)-Xl(1))/(2*SXU);
    yl1 = (Yl(1)+Yl(2))/2 - SYU*(Yl(2)-Yl(1))/(2*SXU);
    yl2 = (Yl(1)+Yl(2))/2 + SYU*(Yl(2)-Yl(1))/(2*SXU);
    xlim([xl1 xl2]);
    ylim([yl1 yl2]);
end

% --- Executes on selection change in dep.
function dep_Callback(hObject, eventdata, handles)
% hObject    handle to dep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dep contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dep
global depen;
depen = get(hObject,'Value');

% --- Executes during object creation, after setting all properties.
function dep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global trajectoryDimension depen;
Dep = cell(trajectoryDimension+1,1);
Dep{1,1} = 't';
for i=1:trajectoryDimension
    Dep{i+1,1} = sprintf('x%d',i);
end
set(hObject,'String',Dep);
set(hObject,'Value',1);
depen = 1;


% --- Executes on button press in redraw.
function redraw_Callback(hObject, eventdata, handles)
% hObject    handle to redraw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global T X;
global lineStyle lineWidth lineColor;
global trajectoryDimension depen;
global SX SY;
set(gcf,'CurrentAxes',handles.plotter);
cla reset;
hold all;
m = floor(0.5*length(T));
tr = get(handles.track,'Data');
if depen>1
    for i = 1:trajectoryDimension
        if tr{i,1} == 1
            plot(X(:,depen-1),X(:,i),strcat(lineStyle,lineColor),'LineWidth',lineWidth); 
            text(X(m,depen-1),X(m,i),sprintf('x%d(x%d)',i,depen-1));
        end
    end
else
    for i = 1:trajectoryDimension
        if tr{i,1} == 1
            plot(T,X(:,i),strcat(lineStyle,lineColor),'LineWidth',lineWidth); 
            text(T(m),X(m,i),sprintf('x%d(t)',i));
        end
    end
end
if SX ~= SY
    Xl = get(gca,'XLim');
    Yl = get(gca,'YLim');
    xl1 = (Xl(1)+Xl(2))/2 - SY*(Xl(2)-Xl(1))/(2*SX);
    xl2 = (Xl(1)+Xl(2))/2 + SY*(Xl(2)-Xl(1))/(2*SX);
    yl1 = (Yl(1)+Yl(2))/2 - SY*(Yl(2)-Yl(1))/(2*SX);
    yl2 = (Yl(1)+Yl(2))/2 + SY*(Yl(2)-Yl(1))/(2*SX);
    xlim([xl1 xl2]);
    ylim([yl1 yl2]);
end


function J_x_Callback(hObject, eventdata, handles)
% hObject    handle to J_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of J_x as text
%        str2double(get(hObject,'String')) returns contents of J_x as a double
global fx;
fx = parser(get(hObject,'String'));
fx = matlabFunction(sym(fx),'vars','x');


% --- Executes during object creation, after setting all properties.
function J_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to J_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global fx;
fx = matlabFunction(sym(0),'vars','x');

% --- Executes on button press in functional.
function functional_Callback(hObject, eventdata, handles)
% hObject    handle to functional (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global T X fx;
global lp rp;
if get(handles.int_func,'Value')
    li = find(T<=lp,1,'last');
    ri = find(T>=rp,1);
    J = zeros(ri-li+1,1);
    for i=li:ri
        J(i-li+1) = fx(X(i,:));
    end
    set(handles.func_val,'String',trapz(T(li:ri),J));
else
    y = interp1(T,X,lp);
    set(handles.func_val,'String',fx(y));   
end


function lpoint_Callback(hObject, eventdata, handles)
% hObject    handle to lpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lpoint as text
%        str2double(get(hObject,'String')) returns contents of lpoint as a double
global lp;
lp = str2double(get(hObject,'String'));
if isnan(lp)
    errordlg('Неправильный формат данных!','Ошибка!');
end

% --- Executes during object creation, after setting all properties.
function lpoint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global lp;
lp = 0;


function rpoint_Callback(hObject, eventdata, handles)
% hObject    handle to rpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rpoint as text
%        str2double(get(hObject,'String')) returns contents of rpoint as a double
global rp;
rp = str2double(get(hObject,'String'));
if isnan(rp)
    errordlg('Неправильный формат данных!','Ошибка!');
end

% --- Executes during object creation, after setting all properties.
function rpoint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global rp;
rp = 1;


function ScaleY_Callback(hObject, eventdata, handles)
% hObject    handle to ScaleY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ScaleY as text
%        str2double(get(hObject,'String')) returns contents of ScaleY as a double
global SY;
SY = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function ScaleY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ScaleY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global SY;
SY = 1;


function ScaleX_Callback(hObject, eventdata, handles)
% hObject    handle to ScaleX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ScaleX as text
%        str2double(get(hObject,'String')) returns contents of ScaleX as a double
global SX;
SX = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function ScaleX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ScaleX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global SX;
SX = 1;

% --- Executes on selection change in color_line.
function color_line_Callback(hObject, eventdata, handles)
global lineColor;
contents = cellstr(get(hObject,'String'));
lineColor = contents{get(hObject,'Value')};

% --- Executes during object creation, after setting all properties.
function color_line_CreateFcn(hObject, eventdata, handles)
global lineColor;
pList = getPropertyListFromFile ('Settings/colors.txt');
lineColor = pList{1};
set (hObject,'String', pList);
set (hObject,'Value', 1);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in style_line.
function style_line_Callback(hObject, eventdata, handles)
global lineStyle;
contents = cellstr(get(hObject,'String'));
lineStyle = contents{get(hObject,'Value')};

% --- Executes during object creation, after setting all properties.
function style_line_CreateFcn(hObject, eventdata, handles)
global lineStyle;
pList = getPropertyListFromFile ('Settings/lineStyles.txt');
lineStyle = pList{1};
set (hObject,'String', pList);
set (hObject,'Value', 1);


function width_line_Callback(hObject, eventdata, handles)
% hObject    handle to width_line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of width_line as text
%        str2double(get(hObject,'String')) returns contents of width_line as a double
global lineWidth;
contents = cellstr(get(hObject,'String'));
lineWidth = contents{get(hObject,'Value')};
lineWidth = str2double(lineWidth);

% --- Executes during object creation, after setting all properties.
function width_line_CreateFcn(hObject, eventdata, handles)
global lineWidth;
pList = getPropertyListFromFile ('Settings/lineWidths.txt');
lineWidth = pList{1};
lineWidth = str2double(lineWidth);
set (hObject,'String', pList);
set (hObject,'Value', 1);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function ScaleYu_Callback(hObject, eventdata, handles)
% hObject    handle to ScaleYu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ScaleYu as text
%        str2double(get(hObject,'String')) returns contents of ScaleYu as a double
global SYU;
SYU = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function ScaleYu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ScaleYu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
global SYU;
SYU = 1;
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ScaleXu_Callback(hObject, eventdata, handles)
% hObject    handle to ScaleXu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ScaleXu as text
%        str2double(get(hObject,'String')) returns contents of ScaleXu as a double
global SXU;
SXU = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function ScaleXu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ScaleXu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global SXU;
SXU = 1;


% --- Executes on selection change in color_line_c.
function color_line_c_Callback(hObject, eventdata, handles)
global lineColorControl;
contents = cellstr(get(hObject,'String'));
lineColorControl = contents{get(hObject,'Value')};

% --- Executes during object creation, after setting all properties.
function color_line_c_CreateFcn(hObject, eventdata, handles)
global lineColorControl;
pList = getPropertyListFromFile ('Settings/colors.txt');
lineColorControl = pList{1};
set (hObject,'String', pList);
set (hObject,'Value', 1);

% --- Executes on selection change in style_line_c.
function style_line_c_Callback(hObject, eventdata, handles)
global lineStyleControl;
contents = cellstr(get(hObject,'String'));
lineStyleControl = contents{get(hObject,'Value')};

% --- Executes during object creation, after setting all properties.
function style_line_c_CreateFcn(hObject, eventdata, handles)
global lineStyleControl;
pList = getPropertyListFromFile ('Settings/lineStyles.txt');
lineStyleControl = pList{1};
set (hObject,'String', pList);
set (hObject,'Value', 1);


function width_line_c_Callback(hObject, eventdata, handles)
% hObject    handle to width_line_c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of width_line_c as text
%        str2double(get(hObject,'String')) returns contents of width_line_c as a double
global lineWidthControl;
contents = cellstr(get(hObject,'String'));
lineWidthControl = contents{get(hObject,'Value')};
lineWidthControl = str2double(lineWidthControl);

% --- Executes during object creation, after setting all properties.
function width_line_c_CreateFcn(hObject, eventdata, handles)
global lineWidthControl;
pList = getPropertyListFromFile ('Settings/lineWidths.txt');
lineWidthControl = pList{1};
lineWidthControl = str2double(lineWidthControl);
set (hObject,'String', pList);
set (hObject,'Value', 1);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function track_CreateFcn(hObject, eventdata, handles)
% hObject    handle to track (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global trajectoryDimension;
Tr = cell(trajectoryDimension,2);
for i=1:trajectoryDimension
    Tr{i,1} = true;
    Tr{i,2} = sprintf('x%d',i);
end
set(hObject,'Data',Tr);


% --- Executes during object creation, after setting all properties.
function uctrl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uctrl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global managementDimension;
Tr = cell(managementDimension,2);
for i=1:managementDimension
    Tr{i,1} = true;
    Tr{i,2} = sprintf('u%d',i);
end
set(hObject,'Data',Tr);


% --- Executes when user attempts to close figres.
function figres_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes during object creation, after setting all properties.
function itnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to itnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function calctime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to calctime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function accur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to accur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when selected object is changed in func_type.
function func_type_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in func_type 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
if get(handles.int_func,'Value')
    set(handles.text23,'String','На отрезке');
    set(handles.rpoint,'Visible','on');
    set(handles.rpoint,'Enable','on');
else
    set(handles.text23,'String','В точке');
    set(handles.rpoint,'Visible','off');
    set(handles.rpoint,'Enable','off');
end


% --------------------------------------------------------------------
function Help_res_Callback(hObject, eventdata, handles)
% hObject    handle to Help_res (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
helpdlg({'В этом окне предоставляются результаты вычислений и возможность работы с ';...
         'ними. На левой координатной плоскости изображен график траектории, причем';... 
         'можно выбирать зависимость траектории от времени или от конкретной';...
         'координаты; на правой - управление. Справа от каждой плоскости';...
         'располагается панель пользовательских настроек графиков: цвет, тип и ';...
         'толщина линий, масштаб. Под ними - таблицы значений траектории и управления';...
         'на временной сетке, соответственно. Между таблицами панель со значением';...
         'функционала, количеством итераций и временем, потребовавшимися для расчета';...
         'задачи, точность, достигнутая относительно выбранных условий остановки.';...
         'В панели в правом нижнем углом можно посчитать функционал от найденных';...
         'траекторий. Для его расчета необходимо ввести временной отрезок (в случае';...
         'интеграла) или точку (для терминального), входящие в исходный временной';...
         'промежуток. Также имеется возможность сохранения и загрузки результатов.'},...
         'Помощь');


% --------------------------------------------------------------------
function Exit_menu_Callback(hObject, eventdata, handles)
close(gcf);


% --------------------------------------------------------------------
function Save_res_Callback(hObject, eventdata, handles)

defaultName = strcat ('Results/example', num2str(listSize + 1));
filename = uiputfile('Results/*.fig','Сохранить резудьтат как', defaultName);
if (filename == 0)
    return;
end
filename = strcat ('Results/', filename);
fid = fopen (filename, 'w');
fclose (fid);
saveas(gcf,filename);

% --------------------------------------------------------------------
function Open_res_Callback(hObject, eventdata, handles)
% hObject    handle to Open_res (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = uigetfile('Results/*.fig','Открыть результат');
if filename == 0
    return
end
filename = strcat ('Results/', filename);
close(gcf);
open(filename);

%warning use this to reach property lists
function propertyList = getPropertyListFromFile (filename)
fid_r = fopen(filename, 'r');
C = textscan(fid_r, '%s');
propertyList = C{1};
