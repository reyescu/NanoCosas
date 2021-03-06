function varargout = gui2d(varargin)
% GUI2D MATLAB code for gui2d.fig
%      GUI2D, by itself, creates a new GUI2D or raises the existing
%      singleton*.
%
%      H = GUI2D returns the handle to a new GUI2D or the handle to
%      the existing singleton*.
%
%      GUI2D('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI2D.M with the given input arguments.
%
%      GUI2D('Property','Value',...) creates a new GUI2D or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui2d_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui2d_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui2d

% Last Modified by GUIDE v2.5 24-Jul-2016 21:11:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui2d_OpeningFcn, ...
                   'gui_OutputFcn',  @gui2d_OutputFcn, ...
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


% --- Executes just before gui2d is made visible.
function gui2d_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui2d (see VARARGIN)

% Choose default command line output for gui2d
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui2d wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui2d_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function ed_load_Callback(hObject, eventdata, handles)
% hObject    handle to ed_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_load as text
%        str2double(get(hObject,'String')) returns contents of ed_load as a double


% --- Executes during object creation, after setting all properties.
function ed_load_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bt_load.
function bt_load_Callback(hObject, eventdata, handles)
% hObject    handle to bt_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=get(handles.ed_load,'String');
   %fi=load('14BR_C.mat');
   fi=load(filename);
%Load data: change to text field plus load button, then move all the
%initialization to load button callback
%global Header Data Ejes
%fi=load('14BR_C.mat');
%global Current
   handles.Header=fi.Header;
   handles.Data=fi.data;
   handles.Ejes=fi.ejes;
   imagesc(handles.Ejes.xrange,handles.Ejes.yrange,handles.Data','Parent',handles.axes1);
         colorbar(handles.axes1);
        set(handles.axes1,'YDir','normal');
        set(handles.axes1,'Fontsize',14);
        xlabel(handles.axes1,[handles.Ejes.xlabel,'(',handles.Ejes.xunit,')'],'Fontsize',16);
        ylabel(handles.axes1,[handles.Ejes.ylabel,'(',handles.Ejes.yunit,')'],'Fontsize',16);
        
        set(handles.ed_xmax,'String',handles.Ejes.xrange(1));
        set(handles.ed_xmin,'String',handles.Ejes.xrange(2));
        set(handles.ed_ymax,'String',handles.Ejes.yrange(1));
        set(handles.ed_ymin,'String',handles.Ejes.yrange(2));
        set(handles.ed_zmax,'String',max(max(handles.Data)));
        set(handles.ed_zmin,'String',min(min(handles.Data)));
       guidata(hObject, handles);



function ed_xmax_Callback(hObject, eventdata, handles)
% hObject    handle to ed_xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_xmax as text
%        str2double(get(hObject,'String')) returns contents of ed_xmax as a double


% --- Executes during object creation, after setting all properties.
function ed_xmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ed_xmin_Callback(hObject, eventdata, handles)
% hObject    handle to ed_xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_xmax as text
%        str2double(get(hObject,'String')) returns contents of ed_xmax as a double


% --- Executes during object creation, after setting all properties.
function ed_xmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function ed_ymin_Callback(hObject, eventdata, handles)
% hObject    handle to ed_ymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_ymin as text
%        str2double(get(hObject,'String')) returns contents of ed_ymin as a double


% --- Executes during object creation, after setting all properties.
function ed_ymin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_ymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bt_axes.
function bt_axes_Callback(hObject, eventdata, handles)
% hObject    handle to bt_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%axis([])
caxis(handles.axes1,[str2double(get(handles.ed_zmin,'String')),str2double(get(handles.ed_zmax,'String'))])
xmin=str2double(get(handles.ed_xmin,'String'));
xmax=str2double(get(handles.ed_xmax,'String'));
ymin=str2double(get(handles.ed_ymin,'String'));
ymax=str2double(get(handles.ed_ymax,'String'));
axis(handles.axes1,[xmin xmax ymin ymax]);




function ed_ymax_Callback(hObject, eventdata, handles)
% hObject    handle to ed_ymax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_ymax as text
%        str2double(get(hObject,'String')) returns contents of ed_ymax as a double


% --- Executes during object creation, after setting all properties.
function ed_ymax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_ymax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to ed_ymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_ymin as text
%        str2double(get(hObject,'String')) returns contents of ed_ymin as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_ymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_zmax_Callback(hObject, eventdata, handles)
% hObject    handle to ed_zmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_zmax as text
%        str2double(get(hObject,'String')) returns contents of ed_zmax as a double


% --- Executes during object creation, after setting all properties.
function ed_zmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_zmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_zmin_Callback(hObject, eventdata, handles)
% hObject    handle to ed_zmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_zmin as text
%        str2double(get(hObject,'String')) returns contents of ed_zmin as a double


% --- Executes during object creation, after setting all properties.
function ed_zmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_zmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in tb_log.
function tb_log_Callback(hObject, eventdata, handles)
% hObject    handle to tb_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tb_log
if get(hObject,'Value')==0
    imagesc(handles.Ejes.xrange,handles.Ejes.yrange,handles.Data','Parent',handles.axes1);
         colorbar(handles.axes1);
         set(handles.axes1,'YDir','normal');
        set(handles.axes1,'Fontsize',14);
        xlabel(handles.axes1,[handles.Ejes.xlabel,'(',handles.Ejes.xunit,')'],'Fontsize',16);
        ylabel(handles.axes1,[handles.Ejes.ylabel,'(',handles.Ejes.yunit,')'],'Fontsize',16);
        
else
    logdata=sign(handles.Data).*log10(abs(handles.Data));
imagesc(handles.Ejes.xrange,handles.Ejes.yrange,logdata','Parent',handles.axes1);
         colorbar(handles.axes1);
         set(handles.axes1,'YDir','normal');
        set(handles.axes1,'Fontsize',14);
        xlabel(handles.axes1,[handles.Ejes.xlabel,'(',handles.Ejes.xunit,')'],'Fontsize',16);
        ylabel(handles.axes1,[handles.Ejes.ylabel,'(',handles.Ejes.yunit,')'],'Fontsize',16);
        
end

function ed_cmap_Callback(hObject, eventdata, handles)
% hObject    handle to ed_cmap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_cmap as text
%        str2double(get(hObject,'String')) returns contents of ed_cmap as a double


% --- Executes during object creation, after setting all properties.
function ed_cmap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_cmap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bt_cmap.
function bt_cmap_Callback(hObject, eventdata, handles)
% hObject    handle to bt_cmap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colormap(handles.axes1,get(handles.ed_cmap,'String'));
