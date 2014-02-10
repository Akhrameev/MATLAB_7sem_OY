function varargout = mainWindow(varargin)
% MAINWINDOW MATLAB code for mainWindow.fig
%      MAINWINDOW, by itself, creates a new MAINWINDOW or raises the existing
%      singleton*.
%
%      H = MAINWINDOW returns the handle to a new MAINWINDOW or the handle to
%      the existing singleton*.
%
%      MAINWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINWINDOW.M with the given input arguments.
%
%      MAINWINDOW('Property','Value',...) creates a new MAINWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mainWindow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mainWindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mainWindow

% Last Modified by GUIDE v2.5 26-Dec-2013 12:04:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mainWindow_OpeningFcn, ...
                   'gui_OutputFcn',  @mainWindow_OutputFcn, ...
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


% --- Executes just before mainWindow is made visible.
function mainWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mainWindow (see VARARGIN)

% Choose default command line output for mainWindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mainWindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global progressbarOK graphicsData currentExample;
progressbarOK = 0;
graphicsData = 0;
set (hObject, 'Name', 'Практикум. 7 семестр. Решение задач оптимального управления. Исходный код: https://github.com/Akhrameev/MATLAB_7sem_OY');
addPath ('Computing/');
addpath ('Computing/ComputingTmp/');
addpath ('JavaWaitbar/');
createWaitbar (handles.figure1, waitbarTag());
makeWaitbarContinious (waitbarTag());
correctWaitbarPosition (handles);
set(0,'DefaultFigurePaperPositionMode','auto');
initExample (currentExample, handles);

function tag = waitbarTag ()
tag = 'mainWindow';

%function to get Examples
function examplesList = getExamples ()
examplesList = getAllFiles ('Examples/'); 

% --- Outputs from this function are returned to the command line.
function varargout = mainWindow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function [examplesList] = updateExamplesList (handles)
examplesList = getExamples ();
popupMenuHandle = findobj(gcbf,'Tag','examplesPopupTag');
set(popupMenuHandle,'String', examplesList);


function correctWaitbarPosition (handles)
position = get (handles.optimalControlTaskTag, 'Position');
position(1)=12;
position(2)=20;
position(3)=489;
position(4)=24;
updateWaitbarPosition (position, waitbarTag());

function [ ] = initExample (file, handles) 
global rightEdgeFixed differentialSystem;
load (file);
sS = saveStructure;
fR = sS.fieldRecord;
pr = sS.property;
for i = 1 : 22
    fRi = correctNameForExistingElement(fR{i});
    if (fRi == 0)
        continue;
    end
    pri = pr(i);
    field = getfield(handles, fRi);
    set (field, 'Value',   pri.Value);
    if isequal('baseSolutionMethodTag', fRi)
        
    else
        set (field, 'String',  pri.String);
    end
    set (field, 'Enable',  pri.Enable);
    set (field, 'Visible', pri.Visible);
end
for i=23:length(fR)
    fRi = correctNameForExistingElement(fR{i});
	if (fRi == 0)
        continue;
    end
	pri = pr(i);
	field = getfield(handles, fRi);
	set (field, 'Data',    pri.Data);
	set (field, 'Enable',  pri.Enable);
    %set (field, 'BackGroundColor', [1,0.4,0.6]);
	set (field, 'Visible', pri.Visible);
end
trajectoryDimensionTag_Callback(0, 'init', handles);
timeFromTag_Callback(0, 0, handles);
timeToTag_Callback(0, 0, handles);
numberOfStepsTag_Callback(0, 0, handles);
directEpsilonTag_Callback(0, 0, handles);
connectedEpsilonTag_Callback(0, 0, handles);
directEpsilonTag_Callback(0, 0, handles);
connectedEpsilonTag_Callback(0, 0, handles);
directMethodTag_Callback(0, 0, handles);
connectedMethodTag_Callback(0, 0, handles);
baseSolutionMethodTag_Callback(0, 0, handles);
iterationsCountTag_Callback(0, 0, handles);
managementDimensionTag_Callback(0, 'init', handles);
penaltyKoefTag_Callback(0, 0, handles);
mppNodesCountTag_Callback(0, 0, handles);
mpgStepTag_Callback(0, 0, handles);
mpgBlendTag_Callback(0, 0, handles);
rightEdgeFixedTag_Callback(0, 0, handles);
if rightEdgeFixed
    differentialSystem = get(handles.optimalControlTaskWithRightEdgeTag,'Data');
else
    differentialSystem = get(handles.optimalControlTaskTag,'Data');
end

%mapping function
function [ existElement ] = correctNameForExistingElement (name)
switch (name)
    case 'sys_dim'
        existElement = 'trajectoryDimensionTag';
	case 'ctrl_dim'
		existElement = 'managementDimensionTag';
    case 'left_edge'
        existElement = 'timeFromTag';
    case 'right_edge'
        existElement = 'timeToTag';
    case 'meth_int'
        existElement = 'directMethodTag';
    case 'meth_ext'
        existElement = 'connectedMethodTag';
    case 'eps_ext'
        existElement = 'directEpsilonTag';
    case 'eps_int'
        existElement = 'connectedEpsilonTag';
    case 'Iter_num'
        existElement = 'iterationsCountTag';
    case 'tax'
        existElement = 'penaltyKoefTag';
    case 'step'
        existElement = 'numberOfStepsTag';
	case 'meth_zou'
		existElement = 'baseSolutionMethodTag';
	case 'mpg_blend'
		existElement = 'mpgBlendTag';
	case 'mpg_step'
		existElement = 'mpgStepTag';
	case 'mpp_net'
		existElement = 'mppNodesCountTag';
    case 'integr_func'
        existElement = 'integrationalFunctionTag';
    case 'term_func'
        existElement = 'terminalFunctionTag';
    case 'ball_rad'
        existElement = 'sphereRadiusTag';
    case 'ball_set'
        existElement = 'sphereRBTag';
    case 'break_set'
        existElement = 'rectangularRBTag';
    case 'break_bord'
        existElement = 'rectangularBoundsTag';
    case 'ball_centre'
        existElement = 'sphereCenterTag';
    case 'ctrl0'
        existElement = 'defaultPointTag';
    case 'Zname'
        existElement = 'nameContainerTag';
    case 'zou'
        existElement = 'optimalControlTaskTag';
    case 'zou2'
        existElement = 'optimalControlTaskWithRightEdgeTag';
    case 'halt_cond'
        existElement = 'haltConditionsTag';
    case 'r_edge'
        existElement = 'rightEdgeFixedTag';
    otherwise
        existElement = name;
end

function [ method ] = setMethod (state)
switch (state)
    case 1.0
        method = @ode45;
    case 2.0
        method = @ode23;
    case 3.0
        method = @ode113;
    case 4.0
        method = @ode15s;
    otherwise
        method = @ode45;
end

function trajectoryDimensionTag_Callback(hObject, eventdata, handles)
global trajectoryDimension;
n = str2double(get(handles.trajectoryDimensionTag,'String'));
if n <= 0 || isnan(n) || floor(n) < n
    errordlg('Неправильный формат данных!','Ошибка!');
else
	trajectoryDimension = n;
    if isequal (eventdata, 'init')
        
    else
        expandOrCollapseDataInTable_Height(handles.optimalControlTaskTag, trajectoryDimension, {'' ''});
        expandOrCollapseDataInTable_Height(handles.optimalControlTaskWithRightEdgeTag, trajectoryDimension, {'' '' ''});
    end
end

function expandOrCollapseDataInTable_Height(hObject, newHeight, appendWith)
d = get (hObject, 'Data');
dSize = size (d);
if (dSize(1) > newHeight)
    d = d (1:newHeight,:);
elseif (dSize(1) < newHeight)
    while (dSize(1) < newHeight)
        d = cat (1, d, appendWith);
        dSize = size (d);
    end
end
set (hObject, 'Data', d);

% --- Executes during object creation, after setting all properties.
function trajectoryDimensionTag_CreateFcn(hObject, eventdata, handles)
global trajectoryDimension;
trajectoryDimension = 1;
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function timeFromTag_Callback(hObject, eventdata, handles)
global timeFrom;
t0 = str2double(get(handles.timeFromTag,'String'));
if isnan(t0)
    errordlg('Неправильный формат данных!','Ошибка!');
else
	timeFrom = t0;
end
% --- Executes during object creation, after setting all properties.
function timeFromTag_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function timeToTag_Callback(hObject, eventdata, handles)
global timeTo;
t1 = str2double (get (handles.timeToTag, 'String'));
if isnan(t1)
    errordlg('Неправильный формат данных!','Ошибка!');
else
	timeTo = t1;
end
% --- Executes during object creation, after setting all properties.
function timeToTag_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function numberOfStepsTag_Callback(hObject, eventdata, handles)
global numberOfSteps;
step = str2double(get(handles.numberOfStepsTag,'String'));
if step<=0 || isnan(step) || floor(step)<step
    errordlg('Неправильный формат данных!','Ошибка!');
else
	numberOfSteps = step;
end
% --- Executes during object creation, after setting all properties.
function numberOfStepsTag_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function directEpsilonTag_Callback(hObject, eventdata, handles)
global directEpsilon;
eps_x = str2double(get(handles.directEpsilonTag,'String'));
if eps_x<=0 || isnan(eps_x)
    errordlg('Неправильный формат данных!','Ошибка!');
else
	directEpsilon = eps_x;
end
% --- Executes during object creation, after setting all properties.
function directEpsilonTag_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function connectedEpsilonTag_Callback(hObject, eventdata, handles)
global connectedEpsilon;
eps_psi = str2double(get(handles.connectedEpsilonTag,'String'));
if eps_psi<=0 || isnan(eps_psi)
    errordlg('Неправильный формат данных!','Ошибка!');
else
	connectedEpsilon = eps_psi;
end
% --- Executes during object creation, after setting all properties.
function connectedEpsilonTag_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function iterationsCountTag_Callback(hObject, eventdata, handles)
global iterationsCount;
iter = str2double(get(handles.iterationsCountTag,'String'));
if iter<=0 || isnan(iter) || floor(iter)<iter
    errordlg('Неправильный формат данных!','Ошибка!');
else
	iterationsCount = iter;
end
% --- Executes during object creation, after setting all properties.
function iterationsCountTag_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function managementDimensionTag_Callback(hObject, eventdata, handles)
global managementDimension;
r = str2double(get(handles.managementDimensionTag,'String'));
if r <= 0 || isnan(r) || floor(r) < r
    errordlg('Неправильный формат данных!','Ошибка!');
else  
	managementDimension = r;  
    if isequal (eventdata, 'init')
        
    else
        expandOrCollapseDataInTable_Height(handles.sphereCenterTag, managementDimension, {''});
        expandOrCollapseDataInTable_Height(handles.rectangularBoundsTag, managementDimension, {'' ''});
        expandOrCollapseDataInTable_Height(handles.defaultPointTag, managementDimension, {''});
    end
end    
% --- Executes during object creation, after setting all properties.
function managementDimensionTag_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function penaltyKoefTag_Callback(hObject, eventdata, handles)
global penaltyKoef;
betta = str2double (get (handles.penaltyKoefTag, 'String'));
if betta < 0 || isnan(betta)
    errordlg('Неправильный формат данных!','Ошибка!');
else
	penaltyKoef = betta;
end
% --- Executes during object creation, after setting all properties.
function penaltyKoefTag_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in examplesPopupTag.
function examplesPopupTag_Callback(hObject, eventdata, handles)
global currentExample;
contents = cellstr(get(hObject,'String'));
currentExample = contents{get(hObject,'Value')};
initExample (currentExample, handles);


% --- Executes during object creation, after setting all properties.
function examplesPopupTag_CreateFcn(hObject, eventdata, handles)
global currentExample;
examplesList = updateExamplesList (handles);
currentExample = examplesList{1};
popupMenuHandle = findobj(gcbf,'Tag','examplesPopupTag');
set (popupMenuHandle, 'Value', 1);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rightEdgeFixedTag.
function rightEdgeFixedTag_Callback(hObject, eventdata, handles)
global rightEdgeFixed;
rightEdgeFixed = get(handles.rightEdgeFixedTag,'Value');
if rightEdgeFixed
    set(handles.optimalControlTaskTag,'Enable','off');
    set(handles.optimalControlTaskTag,'Visible','off');
    set(handles.optimalControlTaskWithRightEdgeTag,'Enable','on');
    set(handles.optimalControlTaskWithRightEdgeTag,'Visible','on');
    set(handles.penaltyKoefTag,'Enable','on');
else
    set(handles.penaltyKoefTag,'Enable','off');
    set(handles.optimalControlTaskWithRightEdgeTag,'Enable','off');
    set(handles.optimalControlTaskWithRightEdgeTag,'Visible','off');
    set(handles.optimalControlTaskTag,'Enable','on');
    set(handles.optimalControlTaskTag,'Visible','on');
end

% --------------------------------------------------------------------
function FileMenuItem_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function OpenExampleMenuItem_Callback(hObject, eventdata, handles)
global currentExample;
filename = uigetfile ('Examples/*mat', 'Открыть пример');
if (filename == 0)
    return;
end
filename = strcat ('Examples/', filename);
examplesList = updateExamplesList (handles);
index = strmatch (filename, examplesList, 'exact');
if isempty(index)
    alertError ('Файл не был найден в списке примеров. Воспользуйтесь списком для загрузки примера.');
    return;
end
currentExample = filename;
popupMenuHandle = findobj(gcbf,'Tag','examplesPopupTag');
set (popupMenuHandle, 'Value', index);
initExample (currentExample, handles);


% --------------------------------------------------------------------
function SaveMenuItem_Callback(hObject, eventdata, handles)
fieldRecord = {'trajectoryDimensionTag','timeFromTag',...
				'timeToTag','numberOfStepsTag',...
				'directEpsilonTag','connectedEpsilonTag',...
				'iterationsCountTag','managementDimensionTag',...
				'penaltyKoefTag',...
				'connectedMethodTag','directMethodTag',...
				'baseSolutionMethodTag'...
				'integrationalFunctionTag','terminalFunctionTag',...
				'rightEdgeFixedTag',...
				'sphereRBTag','rectangularRBTag',...
				'sphereRadiusTag',...
				'mpgStepTag','mpgBlendTag','mppNodesCountTag',...
				'nameContainerTag',...
				'optimalControlTaskTag','optimalControlTaskWithRightEdgeTag',...
				'sphereCenterTag','rectangularBoundsTag','defaultPointTag',...
				'haltConditionsTag'};
saveStructure.fieldRecord = fieldRecord;
for i=1:22
    property(i).Value = get(getfield(handles,fieldRecord{i}),'Value');
    property(i).Enable = get(getfield(handles,fieldRecord{i}),'Enable');
    property(i).String = get(getfield(handles,fieldRecord{i}),'String');
    property(i).Visible = get(getfield(handles,fieldRecord{i}),'Visible');
end
%сохранение данных таблиц
for i=23:length(fieldRecord)
    property(i).Data = get(getfield(handles,fieldRecord{i}),'Data');
    property(i).Enable = get(getfield(handles,fieldRecord{i}),'Enable');
    property(i).Visible = get(getfield(handles,fieldRecord{i}),'Visible');
end
saveStructure.property = property;
examplesList = getExamples ();
listSize = size(examplesList);
listSize = listSize(2);
defaultName = strcat ('Examples/example', num2str(listSize + 1));
filename = uiputfile('Examples/*.mat','Сохранить пример', defaultName);
if (filename == 0)
    return;
end
filename = strcat ('Examples/', filename);
fid = fopen (filename, 'w');
fclose (fid);
save(filename,'saveStructure');
updateExamplesList (handles);


% --- Executes on selection change in directMethodTag.
function directMethodTag_Callback(hObject, eventdata, handles)
global directMethod;
directMethod = get (handles.directMethodTag, 'Value');
directMethod = setMethod (directMethod);
% --- Executes during object creation, after setting all properties.
function directMethodTag_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in connectedMethodTag.
function connectedMethodTag_Callback(hObject, eventdata, handles)
global connectedMethod;
connectedMethod = get (handles.connectedMethodTag, 'Value');
connectedMethod = setMethod (connectedMethod);
% --- Executes during object creation, after setting all properties.
function connectedMethodTag_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in baseSolutionMethodTag.
function baseSolutionMethodTag_Callback(hObject, eventdata, handles)
global baseSolutionMethod;
switch get(handles.baseSolutionMethodTag,'Value')
    case 1.0
        set(handles.textMpgBlendTag,'Visible','on');
        set(handles.textMpgStepTag, 'Visible','on');
        set(handles.mpgStepTag,'Visible','on');
        set(handles.mpgStepTag,'Enable','on');
        set(handles.mpgBlendTag,'Visible','on');
        set(handles.mpgBlendTag,'Enable','on');
        set(handles.mppNodesCountTag,'Visible','off');
        set(handles.mppNodesCountTag,'Enable','off');
        set(handles.textMppNodesCountTag,'Visible','off');
        baseSolutionMethod = @mpg;
    case 2.0
        set(handles.textMpgBlendTag,'Visible','off');
        set(handles.textMpgStepTag, 'Visible','off');
        set(handles.mpgStepTag,'Visible','off');
        set(handles.mpgStepTag,'Enable','off');
        set(handles.mpgBlendTag,'Visible','off');
        set(handles.mpgBlendTag,'Enable','off');
        set(handles.mppNodesCountTag,'Visible','on');
        set(handles.mppNodesCountTag,'Enable','on');
        set(handles.textMppNodesCountTag,'Visible','on');
        baseSolutionMethod = @mpp;
end


% --- Executes during object creation, after setting all properties.
function baseSolutionMethodTag_CreateFcn(hObject, eventdata, handles)
global baseSolutionMethod;
baseSolutionMethod = @mpg;
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mpgStepTag_Callback(hObject, eventdata, handles)
global mpgStep;
a = get(handles.mpgStepTag,'String');
mpgStep = matlabFunction(sym(a),'vars','n');
% --- Executes during object creation, after setting all properties.
function mpgStepTag_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mppNodesCountTag_Callback(hObject, eventdata, handles)
global mppNodesCount;
m = str2double(get(handles.mppNodesCountTag,'String'));
if m<=0 || isnan(m) || floor(m)<m
    errordlg('Неправильный формат данных!','Ошибка!');
else
	mppNodesCount = m;
end

% --- Executes during object creation, after setting all properties.
function mppNodesCountTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mppNodesCountTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mpgBlendTag_Callback(hObject, eventdata, handles)
global mpgBlend;
lambda = str2double(get(handles.mpgBlendTag,'String'));
if lambda<=0 || isnan(lambda)
    errordlg('Неправильный формат данных!','Ошибка!');
else
	mpgBlend = lambda;
end

% --- Executes during object creation, after setting all properties.
function mpgBlendTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mpgBlendTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function integrationalFunctionTag_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function integrationalFunctionTag_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function terminalFunctionTag_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function terminalFunctionTag_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function sphereRadiusTag_Callback(hObject, eventdata, handles)
% hObject    handle to sphereRadiusTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sphereRadiusTag as text
%        str2double(get(hObject,'String')) returns contents of sphereRadiusTag as a double


% --- Executes during object creation, after setting all properties.
function sphereRadiusTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sphereRadiusTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nameContainerTag_Callback(hObject, eventdata, handles)
% hObject    handle to nameContainerTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nameContainerTag as text
%        str2double(get(hObject,'String')) returns contents of nameContainerTag as a double


% --- Executes during object creation, after setting all properties.
function nameContainerTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nameContainerTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function haltConditionsTag_CreateFcn(hObject, eventdata, handles)
row = {'Изменение функционала','Изменение управления','Величина градиента'};
set(hObject,'RowName',row);
d = zeros(3,3);
d(:,1) = 0.01*ones(3,1);
d(:,2) = ones(3,1);
c = cell(3,3);
for i=1:9
    c{i} = d(i);
end
set(hObject,'Data',c);

% --- Executes when entered data in editable cell(s) in haltConditionsTag.
function haltConditionsTag_CellEditCallback(hObject, eventdata, handles)
d = get(hObject,'Data');
d{eventdata.Indices(1),eventData.Indices(2)} = eventdata.EditData;
set(hObject,'Data',d);

% --- Executes when selected object is changed in managementBoundsRBsTag.
function managementBoundsRBsTag_SelectionChangeFcn(hObject, eventdata, handles)
if eventdata.NewValue > eventdata.OldValue
    set(handles.sphereCenterTag,'Enable','off');
    set(handles.sphereCenterTag,'Visible','off');
    set(handles.sphereRadiusTag,'Enable','off');
    set(handles.sphereRadiusTag,'Visible','off');
    set(handles.rectangularBoundsTag,'Enable','on');
    set(handles.rectangularBoundsTag,'Visible','on');
else
    set(handles.sphereCenterTag,'Enable','on');
    set(handles.sphereCenterTag,'Visible','on');
    set(handles.sphereRadiusTag,'Enable','on');
    set(handles.sphereRadiusTag,'Visible','on');
    set(handles.rectangularBoundsTag,'Enable','off');
    set(handles.rectangularBoundsTag,'Visible','off');
end

% --- Executes on button press in solveTaskTag.
function solveTaskTag_Callback(hObject, eventdata, handles)
global trajectoryDimension managementDimension timeFrom timeTo numberOfSteps;
global differentialSystem T U X baseSolutionMethod;
global J_int J_term penaltyKoef;
global directEpsilon connectedEpsilon;
global solvingIterationCurrent;
set(handles.resultsTag,'Enable','off');
set(handles.resultsTag,'Visible','off');
solvingIterationCurrent = 0;
showWaitbar (waitbarTag());
tic;
u0 = get(handles.defaultPointTag,'Data');
uh = matlabFunction(sym(u0),'vars','t');
T = linspace(timeFrom,timeTo,numberOfSteps);
u = zeros(numberOfSteps,managementDimension);
for i=1:numberOfSteps
    u(i,:)=uh(T(i));
end
if isinset(handles,u)==0
    warndlg('Неправильное начальное приближение!','Предупреждение!');
    return;
end
try
    if get(handles.rightEdgeFixedTag,'Value')
        differentialSystem = get(handles.optimalControlTaskWithRightEdgeTag,'Data');
    else
        differentialSystem = get(handles.optimalControlTaskTag,'Data');
    end
    xk = sym('x',[1 trajectoryDimension]);
    p = sym('p',[1 trajectoryDimension]);
    uk = sym('u',[1 managementDimension]);
    J_int = get(handles.integrationalFunctionTag,'String');
    J_term = get(handles.terminalFunctionTag,'String');
    if get(handles.rightEdgeFixedTag,'Value')
        J_term = strcat(J_term,'+',num2str(penaltyKoef),'*((x1-',differentialSystem{1,3},')^2');
        for i=2:trajectoryDimension
            ps = sprintf('+(x%d-%s)^2',i,differentialSystem{i,3});
            J_term = strcat(J_term,ps);
        end
        J_term = strcat(J_term,')');
    end
    if strcmp(J_int,'0')
        H = p*differentialSystem(:,1);
    else
        H = strcat('-1*(',J_int,')') + p*differentialSystem(:,1);
    end
    x0 = zeros(trajectoryDimension,1);
    for i=1:trajectoryDimension
        x0(i) = str2double(differentialSystem{i,2});
    end
    createDifferentialSystemAsFile('-1'*jacobian(H,xk),jacobian(H,uk),H,trajectoryDimension,managementDimension);
    optx = odeset('RelTol',directEpsilon);
    optp = odeset('RelTol',connectedEpsilon);
    createF_I_Fx('-1'*jacobian(J_term,xk),J_int,J_term,trajectoryDimension);
    [U,X,j,i,eps] = baseSolutionMethod(u,x0,optx,optp,handles);
    fid = fopen('Settings/fin.txt','w');
    clear('Settings/fin.txt');
    t = toc;
	%сохранение статистики для отображения в окне результатов
    fprintf(fid,'%f\n%d\n%f\n',j,i,eps);
    fprintf(fid,'%f\n',t);
    fprintf(fid,'%s',get(handles.nameContainerTag,'String'));
    fclose(fid);
    closeWaitbar (waitbarTag());
    set(handles.resultsTag,'Enable','on');
    set(handles.resultsTag,'Visible','on');
catch e
    warndlg(e.message, 'Ошибка!');
    closeWaitbar (waitbarTag());
    set(handles.resultsTag,'Enable','off');
    set(handles.resultsTag,'Visible','off');
end

% --- Executes on button press in resultsTag.
function resultsTag_Callback(hObject, eventdata, handles)
res;

% --- Executes during object creation, after setting all properties.
function optimalControlTaskWithRightEdgeTag_CreateFcn(hObject, eventdata, handles)
set(hObject,'Data',cell(1,3));

% --- Executes when entered data in editable cell(s) in optimalControlTaskWithRightEdgeTag.
function optimalControlTaskWithRightEdgeTag_CellEditCallback(hObject, eventdata, handles)
d = get(hObject,'Data');
d{eventdata.Indices(1),eventdata.Indices(2)} = eventdata.EditData;
set(hObject,'Data',d);

% --- Executes during object creation, after setting all properties.
function rectangularBoundsTag_CreateFcn(hObject, eventdata, handles)
set(hObject,'Data',cell(1,2));

% --- Executes when entered data in editable cell(s) in rectangularBoundsTag.
function rectangularBoundsTag_CellEditCallback(hObject, eventdata, handles)
d = get(hObject,'Data');
d{eventdata.Indices(1),eventdata.Indices(2)} = eventdata.EditData;
set(hObject,'Data',d);

% --- Executes during object creation, after setting all properties.
function defaultPointTag_CreateFcn(hObject, eventdata, handles)
set(hObject,'Data',cell(1,1));

% --- Executes when entered data in editable cell(s) in defaultPointTag.
function defaultPointTag_CellEditCallback(hObject, eventdata, handles)
d = get(hObject,'Data');
d{eventdata.Indices(1),eventdata.Indices(2)} = eventdata.EditData;
set(hObject,'Data',d);

% --- Executes during object creation, after setting all properties.
function optimalControlTaskTag_CreateFcn(hObject, eventdata, handles)
set(hObject,'Data',cell(1,2));

% --- Executes when entered data in editable cell(s) in optimalControlTaskTag.
function optimalControlTaskTag_CellEditCallback(hObject, eventdata, handles)
d = get(hObject,'Data');
d{eventdata.Indices(1),eventdata.Indices(2)} = eventdata.EditData;
set(hObject,'Data',d);

% --- Executes when entered data in editable cell(s) in sphereCenterTag.
function sphereCenterTag_CellEditCallback(hObject, eventdata, handles)
d = get(hObject,'Data');
d{eventdata.Indices(1),eventdata.Indices(2)} = eventdata.EditData;
set(hObject,'Data',d);

% --- Executes during object creation, after setting all properties.
function sphereCenterTag_CreateFcn(hObject, eventdata, handles)
set(hObject,'Data',cell(1,1));

function [f] = isinset(handles,e)
global sphereRadius numberOfSteps T managementDimension;
if get(handles.sphereRBTag,'Value')
    O = get(handles.sphereCenterTag,'Data');
    oh = matlabFunction(sym(O),'vars','t');
    O = zeros(numberOfSteps,managementDimension);
    for i=1:numberOfSteps
        O(i,:) = oh(T(i));
        if norm(O(i,:)-e(i,:))>sphereRadius
            f = 0;
            return;
        end
    end
    f = 1;
else
    P = get(handles.rectangularBoundsTag,'Data');
    pl = matlabFunction(sym(P(:,1)),'vars','t');
    pr = matlabFunction(sym(P(:,2)),'vars','t');
    Pl = zeros(numberOfSteps,managementDimension);
    Pr = zeros(numberOfSteps,managementDimension);
    for i=1:numberOfSteps
        Pl(i,:) = pl(T(i));
        Pr(i,:) = pr(T(i));
        if e(i,:)<Pl(i,:) || e(i,:)>Pr(i,:)
            f = 0;
            return;
        end
    end
    f = 1;
end

function [uk,xk,j,k,eps] = mpp( u0,x0,optx,optp,handles)
global mppNodesCount iterationsCount;
global i1 i2 i3;
uk = u0;
i1 = 0; i2 = 0; i3 = 0;
h = -1;
for k=1:iterationsCount
    showCustomWaitbar(k, iterationsCount, waitbarTag());
    [xk,pk] = sol_zk(x0,optx,optp,uk);
    v = u_max(handles,uk,xk,pk);
    [ju,~] = J(uk,x0);
    vmin = uk;
    jmin = ju;    
    for i=0:mppNodesCount-1
        w = (i*uk + (mppNodesCount-i)*v)/mppNodesCount;
        [jw,~] = J(w,x0);
        if jw < jmin
           vmin = w;
           jmin = jw;
        end
    end
    [h,eps] = halt_c(handles,uk,vmin,ju,jmin,x0,optx,optp);
    uk = vmin;
    if h>=0
        break;
    end
end
[j,xk] = J(uk,x0);

function [ uk ] = u_max(handles,u,x,p)
global numberOfSteps T;
uk = u;
vk = zeros(size(u));
for j=1:5
    for i=1:numberOfSteps
        tmp(i,:) = 0.25*Hu(x(i,:),T(i),uk(i,:),p(i,:));
        vk(i,:) = uk(i,:) + tmp(i);
        %vk(i,:) = uk(i,:) + 0.25*Hu(x(i,:),T(i),uk(i,:),p(i,:));
    end
    vk = proj(handles,vk);
    if norm(uk - vk)<0.01
        return;
    end
    for i=1:numberOfSteps
        if H(x(i,:),T(i),vk(i,:),p(i,:)) > H(x(i,:),T(i),uk(i,:),p(i,:))
            uk(i,:) = vk(i,:);
        end
    end
end

function [p] = proj(handles,h)
global sphereRadius T numberOfSteps managementDimension;
p = h;
if get(handles.sphereRBTag,'Value')
    O = get(handles.sphereCenterTag,'Data');
    oh = matlabFunction(sym(O),'vars','t');
    O = zeros(numberOfSteps,managementDimension);
    for i=1:numberOfSteps
        O(i,:) = oh(T(i));
        if norm(O(i,:)-h(i,:))>sphereRadius
            p(i,:) = sphereRadius*(h(i,:) - O(i,:))/norm(h(i,:) - O(i,:)) + O(i,:);
        end
    end
else
    P = get(handles.rectangularBoundsTag,'Data');
    pl = matlabFunction(sym(P(:,1)),'vars','t');
    pr = matlabFunction(sym(P(:,2)),'vars','t');
    Pl = zeros(numberOfSteps,managementDimension);
    Pr = zeros(numberOfSteps,managementDimension);
    for i=1:numberOfSteps
        Pl(i,:) = pl(T(i));
        Pr(i,:) = pr(T(i));
        if h(i,:)<Pl(i,:)
            p(i,:) = Pl(i,:);
        elseif h(i,:)>Pr(i,:)
            p(i,:) = Pr(i,:);
        end
    end
end

function [res,eps] = halt_c(handles,u,v,ju,jv,x0,optx,optp)
global i1 i2 i3;
halt = get(handles.haltConditionsTag,'Data');
res = -1;
eps = -1;
if halt{1,3}==1
    eps = abs(ju-jv);
    if eps<halt{1,1}
        i1 = i1+1;
        if i1 == halt{1,2}
            res = eps;
            return;
        end
    else
        i1 = 0;
    end
end
if halt{2,3}==1
    eps = norm(v-u,'fro');
    if eps<halt{2,1}
        i2 = i2+1;
        if i2 == halt{2,2}
            res = eps;
            return;
        end
    else
        i2 = 0;
    end
end
if halt{3,3}==1
    eps = norm(J_grad(x0,optx,optp,v));
    if eps<halt{3,1}
        i3 = i3+1;
        if i3 == halt{3,2}
            res = eps;
            return;
        end
    else
        i3 = 0;
    end
end

function [u,x,j,i,eps] = mpg( uk,x0,optx,optp,handles)
%MPG Summary of this function goes here
%   Detailed explanation goes here
global mpgStep mpgBlend iterationsCount;
global i1 i2 i3;
u = uk;
b = 1;
eps = -1;
i1 = 0; i2 = 0; i3 = 0;
for i=1:iterationsCount
    showCustomWaitbar(i, iterationsCount, waitbarTag());
    a = b*mpgStep(i);
    g = J_grad(x0,optx,optp,u);
    v = u - a*g;
    v = proj(handles,v);
    [ju,~] = J(u,x0);
    [jv,~] = J(v,x0);        
    [h,eps] = halt_c(handles,u,v,ju,jv,x0,optx,optp);   
    if jv >= ju
        b = mpgBlend*b;
        if b<0.0001
            b=1;
        end
    else
        u = v;
    end   
    if h>=0
        break;
    end
end
[j,x] = J(u,x0);

% --- Executes during object creation, after setting all properties.
function resultsTag_CreateFcn(hObject, eventdata, handles)

function askOnExit()
answer = questdlg(sprintf(...
         'Вы уверены, что хотите выйти из программы? \n Все несохраненные данные будут потеряны.'),...
         'Выход','Да', 'Нет','Нет');
if isequal(answer, 'Да')
    delete(gcf);
end

% --------------------------------------------------------------------
function ExitMenuItem_Callback(hObject, eventdata, handles)
askOnExit();

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
askOnExit();


% --------------------------------------------------------------------
function HelpMainMenuItem_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function HelpMenuItem_Callback(hObject, eventdata, handles)
helpdlg({'Данная программа позволяет решать задачи оптимального управления.';...
         'При запуске автоматически подгрузится первый пример и';...
         'Вы можете сразу приступить к решению задачи!';...
         'Для этого нажмите на кнопку "Решить".';...
         'Для просмотра результата нажмите кнопку "Результат".';...
         '';...
         'Для работы с приложением необходимо заполнить параметры задачи';...
         'и в таблицу записать (по столбцам)';...
         ' - правую часть системы дифференциаьных уравнений';...
         'в формате f(t,x1,...,xn,u1,...ur);';...
         ' - вектор х0 начальных условий;';...
         ' - вектор х1 конечных условий (для задачи с закрепленным концом);';...
         'Выбрать методы для решения задачи и дополнительные параметры к ним.';...
         'Доступны 2 метода: проекция градиента и последовательные приближения.';...
         'Ниже ввести интегральную и терминальную части критерия качества.';...
         'Еще ниже укажите область управления. Доступны 2 опции: шар и параллелепипед.';...
         'В случае щара нужно ввести координаты центра и его радиус.';...
         'В случае параллелепипеда - координаты нижней и верхней границ.';...
         'В таблице ниже определить условия останова.'},'Помощь');


% --------------------------------------------------------------------
function AboutMenuItem_Callback(hObject, eventdata, handles)
about;
