function varargout = guessandfitnpeaks(varargin)
% GUESSANDFITNPEAKS MATLAB code for guessandfitnpeaks.fig
%      GUESSANDFITNPEAKS, by itself, creates a new GUESSANDFITNPEAKS or raises the existing
%      singleton*.
%
%      H = GUESSANDFITNPEAKS returns the handle to a new GUESSANDFITNPEAKS or the handle to
%      the existing singleton*.
%
%      GUESSANDFITNPEAKS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUESSANDFITNPEAKS.M with the given input arguments.
%
%      GUESSANDFITNPEAKS('Property','Value',...) creates a new GUESSANDFITNPEAKS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guessandfitnpeaks_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guessandfitnpeaks_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guessandfitnpeaks

% Last Modified by GUIDE v2.5 14-Jan-2019 11:07:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guessandfitnpeaks_OpeningFcn, ...
                   'gui_OutputFcn',  @guessandfitnpeaks_OutputFcn, ...
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

% --- Executes just before guessandfitnpeaks is made visible.
function guessandfitnpeaks_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guessandfitnpeaks (see VARARGIN)

% Choose default command line output for guessandfitnpeaks
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using guessandfitnpeaks.


% UIWAIT makes guessandfitnpeaks wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guessandfitnpeaks_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in bt_bounds.
function bt_bounds_Callback(hObject, eventdata, handles)
% hObject    handle to bt_bounds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.txt_user,'String','Select range of data to fit')
ajsj=ginputax(handles.axes1,2);
hold on
scatter(ajsj(:,1),ajsj(:,2),'red','fill');

je=find(handles.aa>ajsj(1,1),1);
ja=find(handles.aa>ajsj(2,1),1);
handles.x_ini=je;
handles.x_end=ja;

[handles.xData, handles.yData] = prepareCurveData( handles.aa (je:ja), handles.bb (je:ja) );

set(handles.txt_user,'String','Pick offset starting value')
offstart=ginputax(handles.axes1,1);
handles.ofset=offstart(2);

handles.n=str2num(get(handles.ed_peaks,'String'))
n=handles.n
for i=1:n
set(handles.txt_user,'String',['Select limits for Peak ',num2str(i)])
eee=ginputax(handles.axes1,3)

wid(i)=eee(3,1)-eee(1,1);
hei(i)=eee(2,2);
cen(i)=eee(2,1);

end
% Set up fittype and options.
%ft = fittype( 'gauss1' );
ty='g';
ofset=handles.ofset;

stringmodel='';
for i=1:n
nn=num2str(i);
if ty=='l'
stringmodel=[stringmodel,'a',nn,'./((x-b',nn,').^2+c',nn,')+'];
else if ty=='g'
        stringmodel=[stringmodel,'a',nn,'*exp(-((x-b',nn,')/c',nn,')^2)+'];
    else
        printf('no model')
    end
end
end
stringmodel=[stringmodel,'d']
handles.stringmodel=stringmodel;

%ft = fittype('a1*exp(-((x-b1)/c1)^2)+a2*exp(-((x-b2)/c2)^2)+d', 'independent', 'x', 'dependent', 'y' );
ft = fittype(stringmodel, 'independent', 'x', 'dependent', 'y' );
handles.ft=ft;

opts = fitoptions( 'Method', 'NonlinearLeastSquares' );

opts.Display = 'Off';
loweramp=[]; lowercen=[]; lowerwid=[];
upperamp=[]; uppercen=[]; upperwid=[];
startamp=[]; startcen=[]; startwid=[];
for i=1:n
loweramp = [loweramp hei(i)/2];
upperamp = [upperamp hei(i)*2];
lowercen = [lowercen cen(i)-wid(i)/4];
lowerwid = [lowerwid wid(i)*0.5];
uppercen = [uppercen cen(i)+wid(i)/4];
upperwid = [upperwid wid(i)];
startamp = [startamp hei(i)-ofset];
startcen = [startcen cen(i)];
startwid = [startwid wid(i)];
end
opts.Lower = [loweramp lowercen lowerwid 0.9*ofset]
opts.Upper = [upperamp uppercen upperwid 1.1*ofset]
opts.StartPoint = [startamp startcen startwid ofset]

handles.opts=opts;


x=[opts.Lower; opts.StartPoint; opts.Upper]';
handles.bounds=x;
set(handles.table_data,'Data',x)
guidata(hObject, handles);

%popup_sel_index = get(handles.popupmenu1, 'Value');
%switch popup_sel_index
%    case 1
        %plot(rand(5));

        %case 2
        %plot(sin(1:0.01:25.99));
    %case 3
        %bar(1:.5:10);
    %case 4
        %plot(membrane);
    %case 5
        %surf(peaks);
%end


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});



function ed_peaks_Callback(hObject, eventdata, handles)
% hObject    handle to ed_peaks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_peaks as text
%        str2double(get(hObject,'String')) returns contents of ed_peaks as a double


% --- Executes during object creation, after setting all properties.
function ed_peaks_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_peaks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bt_fit.
function bt_fit_Callback(hObject, eventdata, handles)
% hObject    handle to bt_fit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.fitresult, handles.gof] = fit( handles.xData, handles.yData, handles.ft, handles.opts );
n=handles.n;
c=coeffvalues(handles.fitresult);
handles.c=c;
gof=handles.gof;
set(handles.ed_gof,'String',num2str(gof.rsquare));
%'a',nn,'./((x-b',nn,').^2+c',nn,')+
% Plot fit with data.
%figure( 'Name', 'untitled fit 1' );
%h = plot( fitresult, xData, yData );
%legend( h, 'bbb vs. aaa', 'untitled fit 1', 'Location', 'NorthEast' );
% Label axes
%xlabel aaa
%ylabel bbb
%grid on
l=handles.opts.Lower;
u=handles.opts.Upper;
s=[];
for i=1:3*n
   if c(i)==l(i)
     s=[s,' c',num2str(i),' bound lower']
   end
   if c(i)==u(i)
    s=[s,' c',num2str(i),' bound upper']
   end
end
set(handles.txt_warning,'String',s)


hold off
plot(handles.fitresult, handles.xData, handles.yData );
set(handles.txt_fit,'String',num2str(c'))

hold on

for i=1:n
yy=c(i).*exp(-((handles.xData-c(n+i))./c(2*n+i)).^2)+c(3*n+1);
%for i=1:n
plot(handles.axes1,handles.xData,yy)
end
guidata(hObject, handles);



% --- Executes on button press in bt_plot.
function bt_plot_Callback(hObject, eventdata, handles)
% hObject    handle to bt_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.aa=evalin('base',get(handles.ed_varx,'String'))
handles.bb=evalin('base',get(handles.ed_vary,'String'))
%get(handles.ed_varx)
hold off
scatter(handles.aa,handles.bb)
guidata(hObject, handles);



function ed_varx_Callback(hObject, eventdata, handles)
% hObject    handle to ed_varx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_varx as text
%        str2double(get(hObject,'String')) returns contents of ed_varx as a double


% --- Executes during object creation, after setting all properties.
function ed_varx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_varx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_vary_Callback(hObject, eventdata, handles)
% hObject    handle to ed_vary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_vary as text
%        str2double(get(hObject,'String')) returns contents of ed_vary as a double


% --- Executes during object creation, after setting all properties.
function ed_vary_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_vary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bt_range.
function bt_range_Callback(hObject, eventdata, handles)


guidata(hObject, handles);


% --- Executes on button press in bt_off.
function bt_off_Callback(hObject, eventdata, handles)

guidata(hObject, handles);


% --- Executes when entered data in editable cell(s) in table_data.
function table_data_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to table_data (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );

datt=(get(handles.table_data,'Data'))
opts.Lower=datt(:,1)
opts.StartPoint=datt(:,2)
opts.Upper=datt(:,3)
handles.opts=opts;

guidata(hObject, handles);


% --- Executes on button press in bt_export.
function bt_export_Callback(hObject, eventdata, handles)
% hObject    handle to bt_export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%set(handles.txt_fit,'String',get(handles.table_data,'Data'))
stringmodel=handles.stringmodel;
opts=handles.opts;
nout=handles.n;
x_ini=handles.x_ini;
x_end=handles.x_end;
xData=handles.xData;
yData=handles.yData;
cc=handles.c;
fitresult=handles.fitresult;
save(get(handles.ed_filename,'String'),'stringmodel','opts','nout','xData','yData','x_ini','x_end','fitresult','cc')



function ed_filename_Callback(hObject, eventdata, handles)
% hObject    handle to ed_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_filename as text
%        str2double(get(hObject,'String')) returns contents of ed_filename as a double


% --- Executes during object creation, after setting all properties.
function ed_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_rebounds.
function pb_rebounds_Callback(hObject, eventdata, handles)
% hObject    handle to pb_rebounds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
opts=handles.opts;
n=handles.n;
c=handles.c;
opts.Startpoint=c;
%lo=opts.Lower;
%up=opts.Upper;
adjamp=str2num(get(handles.ed_adjamp,'String'));
adjpos=str2num(get(handles.ed_adjpos,'String'));
adjwid=str2num(get(handles.ed_adjwid,'String'));
adjoff=str2num(get(handles.ed_adjoff,'String'));

for i=1:n
    lo(i)=c(i)*(1-adjamp/100);
    up(i)=c(i)*(1+adjamp/100);
end
for i=n+1:2*n
    lo(i)=c(i)*(1-adjpos/100);
    up(i)=c(i)*(1+adjpos/100);
end
   for i=2*n+1:3*n;
    lo(i)=c(i)*(1-adjwid/100);
    up(i)=c(i)*(1+adjwid/100);
   end 
   lo(3*n+1)=c(3*n+1)*(1-adjoff/100);
   up(3*n+1)=c(3*n+1)*(1+adjoff/100);

opts.Lower=lo;
opts.Upper=up;


handles.opts=opts;

x=[opts.Lower; opts.StartPoint; opts.Upper]';
handles.bounds=x;
set(handles.table_data,'Data',x);

guidata(hObject, handles);



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


% --- Executes on button press in pb_loadpar.
function pb_loadpar_Callback(hObject, eventdata, handles)
% hObject    handle to pb_loadpar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dd=load(get(handles.ed_load,'String'));
opts=dd.opts;
stringmodel=dd.stringmodel;
n=dd.nout;
handles.stringmodel=stringmodel;
handles.n=n;
handles.c=opts.Startpoint;
handles.x_ini=dd.x_ini;
handles.x_end=dd.x_end;
[handles.xData, handles.yData] = prepareCurveData( handles.aa (handles.x_ini:handles.x_end), handles.bb (handles.x_ini:handles.x_end) );
set(handles.ed_peaks,'String',num2str(n));
handles.opts=dd.opts;
x=[opts.Lower; opts.StartPoint; opts.Upper]';
handles.bounds=x;
set(handles.table_data,'Data',x);
ft = fittype(stringmodel, 'independent', 'x', 'dependent', 'y' );
handles.ft=ft;
handles.fitresult=dd.fitresult;
c=dd.cc;

hold off
plot(handles.fitresult, handles.xData, handles.yData );
set(handles.txt_fit,'String',num2str(c'))

hold on

for i=1:n
yy=c(i).*exp(-((handles.xData-c(n+i))./c(2*n+i)).^2)+c(3*n+1);
%for i=1:n
plot(handles.axes1,handles.xData,yy)
end
guidata(hObject, handles);



function ed_adjamp_Callback(hObject, eventdata, handles)
% hObject    handle to ed_adjamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_adjamp as text
%        str2double(get(hObject,'String')) returns contents of ed_adjamp as a double


% --- Executes during object creation, after setting all properties.
function ed_adjamp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_adjamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_adjpos_Callback(hObject, eventdata, handles)
% hObject    handle to ed_adjpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_adjpos as text
%        str2double(get(hObject,'String')) returns contents of ed_adjpos as a double


% --- Executes during object creation, after setting all properties.
function ed_adjpos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_adjpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_adjwid_Callback(hObject, eventdata, handles)
% hObject    handle to ed_adjwid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_adjwid as text
%        str2double(get(hObject,'String')) returns contents of ed_adjwid as a double


% --- Executes during object creation, after setting all properties.
function ed_adjwid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_adjwid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_adjoff_Callback(hObject, eventdata, handles)
% hObject    handle to ed_adjoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_adjoff as text
%        str2double(get(hObject,'String')) returns contents of ed_adjoff as a double


% --- Executes during object creation, after setting all properties.
function ed_adjoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_adjoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_gof_Callback(hObject, eventdata, handles)
% hObject    handle to ed_gof (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_gof as text
%        str2double(get(hObject,'String')) returns contents of ed_gof as a double


% --- Executes during object creation, after setting all properties.
function ed_gof_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_gof (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
