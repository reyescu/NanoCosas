function varargout = gui3dnew(varargin)
% GUI3DNEW MATLAB code for gui3dnew.fig
%     
%      H = GUI3DNEW returns the handle to a new GUI3DNEW or the handle to
%      the existing singleton*.
%
%      GUI3DNEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI3DNEW.M with the given input arguments.
%
%      GUI3DNEW('Property','Value',...) creates a new GUI3DNEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui3dnew_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui3dnew_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui3dnew

% Last Modified by GUIDE v2.5 26-Jan-2017 15:02:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui3dnew_OpeningFcn, ...
                   'gui_OutputFcn',  @gui3dnew_OutputFcn, ...
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


%% --- Executes just before gui3dnew is made visible.
function gui3dnew_OpeningFcn(hObject, eventdata, handles, varargin)

%initialize variables for linecut
handles.firstclick=1;
handles.pos1=[1,1];
handles.pos2=[1,1];

% Choose default command line output for gui3dnew
handles.output = hObject;

%setup cursor
dcm_obj = datacursormode(gcf);
  datacursormode on;
  set(dcm_obj,'UpdateFcn', @myupdatefcn )
  handles.dcm_obj = datacursormode(hObject);
 set(handles.dcm_obj,'Enable','on','UpdateFcn',{@myupdatefcn,hObject});

% Update handles structure
guidata(hObject, handles);

%% Load data and initialize graphs
% --- Executes on button press in bt_load.
function bt_load_Callback(hObject, eventdata, handles)

%load data
filename=get(handles.ed_filename,'String');
   %fi=load('14BR_C.mat');
   fi=load(filename);
   ch=str2num(get(handles.edit_ch,'String'));
   ch2=str2num(get
   handles.Data=fi.ch{ch};
   handles.Axis=fi.ax;
   %Initialize slider and z edits

set(handles.zarray_slider,'Min',1);
l=length(handles.Axis{3}.array);
set(handles.zarray_slider,'Max',l);
set(handles.zarray_slider,'SliderStep',[1/(l-1),10/(l-1)]);
set(handles.zarray_slider,'Value',1);

fin=handles.Axis{3}.array(end);
start=handles.Axis{3}.array(1);
if fin>start
handles.zmax=handles.Axis{3}.array(end);
handles.zmin=handles.Axis{3}.array(1);
else
    handles.zmax=handles.Axis{3}.array(1);
handles.zmin=handles.Axis{3}.array(end);
end

handles.slider_n = get(handles.zarray_slider, 'Value');
handles.slider_v =handles.Axis{3}.array(handles.slider_n);
set(handles.ed_zn, 'String',handles.slider_n);
set(handles.ed_zv, 'String', handles.slider_v);

% plot image
updateGraph(handles);
set(handles.axes1,'YDir','normal');
set(handles.axes1,'Fontsize',14);
xlabel(handles.axes1,[handles.Axis{1}.parameter,'(',handles.Axis{1}.unit,')'],'Fontsize',16);
ylabel(handles.axes1,[handles.Axis{2}.parameter,'(',handles.Axis{2}.unit,')'],'Fontsize',16);

%plot spec
handles.pos=[1,1];
UpdateGraph2(handles);
set(handles.axes2,'Fontsize',14);
xlabel(handles.axes2,[handles.Axis{3}.parameter,'(',handles.Axis{3}.unit,')'],'Fontsize',16);
ylabel(handles.axes2,[handles.Data.parameter,'(',handles.Data.unit,')'],'Fontsize',16);

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = gui3dnew_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;

%% Slider functions
% --- Executes on slider movement.
function zarray_slider_Callback(hObject, eventdata, handles)
% hObject    handle to zarray_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)   
handles.slider_n = round(get(hObject, 'Value'));
set(handles.ed_zn,'String',handles.slider_n);
   handles.slider_v = handles.Axis{3}.array(handles.slider_n);
   set(handles.ed_zv, 'String', handles.slider_v); 
   updateGraph(handles);

% --- Executes during object creation, after setting all properties.
function zarray_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zarray_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%% edit box functions
function ed_filename_Callback(hObject, eventdata, handles)
% hObject    handle to ed_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function ed_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

    
function ed_zn_Callback(hObject, eventdata, handles)
% hObject    handle to ed_zn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_zn as text
%        str2double(get(hObject,'String')) returns contents of ed_zn as a double
%global  Current   
handles.slider_n = abs(round(str2double(get(hObject, 'String'))));
if handles.slider_n > length(handles.Axis{3}.array)
    handles.slider_n=length(handles.Axis{3}.array);
end
set(handles.ed_zn, 'String', handles.slider_n); 
set(handles.zarray_slider,'Value',handles.slider_n);
   handles.slider_v = handles.Axis{3}.array(handles.slider_n);
   set(handles.ed_zv, 'String', handles.slider_v); 
   updateGraph(handles);

function ed_zn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_zn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ed_zv_Callback(hObject, eventdata, handles)
% hObject    handle to ed_zv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_zv as text
%        str2double(get(hObject,'String')) returns contents of ed_zv as a double
   

handles.slider_v = str2double(get(hObject, 'String'));
handles.zmax
handles.zmin
        if (handles.slider_v > handles.zmax) 
            handles.slider_n=length(handles.Axis{3}.array);
            handles.slider_v=handles.zmax;
        else if (handles.slider_v < handles.zmin)
                handles.slider_n=1;
                handles.slider_v=handles.zmin;
            else
            handles.slider_n = find(~(handles.Axis{3}.array-handles.slider_v),1)
            end
        end
        set(handles.zarray_slider,'value', handles.slider_n);
        set(handles.ed_zn,'String',handles.slider_n);
        handles.slider_v = handles.Axis{3}.array(handles.slider_n);
        set(handles.ed_zv, 'String', handles.slider_v); 
        updateGraph(handles)
                
function ed_zv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_zv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%% Buttons functions
% --- Executes on button press in holdon_bt.
function holdon_bt_Callback(hObject, eventdata, handles)
% hObject    handle to holdon_bt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of holdon_bt
 if hObject.Value== 0
     hObject.String='Hold Off';
     hold(handles.axes1,'off');
     hold(handles.axes2,'off');
     updateGraph(handles);
 else
     hObject.String='Hold on';
     
 end
 %if get(handles.linecut_bt,'Value')==1
 %    set(handles.linecut_bt,'Value',0);
 %             updateGraph(handles);
 %end

% --- Executes on button press in linecut_bt.
function linecut_bt_Callback(hObject, eventdata, handles)
% hObject    handle to linecut_bt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of linecut_bt
         

if get(handles.holdon_bt,'Value')==1
    set(handles.holdon_bt,'Value',0);

end
if get(handles.linecut_bt,'Value')==0
    set(handles.linecut_bt,'String','Linecut Off')
    
else
     set(handles.linecut_bt,'String','Linecut On')
end
handles.firstclick=1;
%updateGraph(handles);

%%  Graphs refresh and plot
function updateGraph(handles)
%global  Current
        test=squeeze(handles.Data.s1(:,:,handles.slider_n));
       % test=imresize(test,3);
       % imagesc(handles.Axis{1}.range,handles.Axis{2}.range,test','Parent',handles.axes1);
        imagesc(test','Parent',handles.axes1);
        auto=get(handles.cb_autoscale,'Value');
        colorbar(handles.axes1);
        set(handles.axes1,'YDir','normal');
        set(handles.axes1,'equal');
        set(handles.axes1,'Fontsize',14);
        xlabel(handles.axes1,[handles.Axis{1}.parameter,'(',handles.Axis{1}.unit,')'],'Fontsize',16);
        ylabel(handles.axes1,[handles.Axis{2}.parameter,'(',handles.Axis{2}.unit,')'],'Fontsize',16);
       
        if auto==1
            caxis(handles.axes1,'auto');
        end
        if auto==0
            max=str2num(get(handles.ed_caxismax,'String'));
            min=str2num(get(handles.ed_caxismin,'String'));
            if min>max
                maxx=max;
                max=min;
                min=maxx;
            end   
        caxis(handles.axes1,[min max]);
        end
        
function UpdateGraph2(handles)
        %global  Current
        
        plot(handles.axes2,handles.Axis{3}.array, squeeze(handles.Data.s1(handles.pos(1),handles.pos(2),:)));
        set(handles.axes2,'Fontsize',14);
        xlabel(handles.axes2,[handles.Axis{3}.parameter,'(',handles.Axis{3}.unit,')'],'Fontsize',16);
        ylabel(handles.axes2,[handles.Data.parameter,'(',handles.Data.unit,')'],'Fontsize',16);
  
%% Executes when cursor click on figures
function txt = myupdatefcn(~, event_obj,hFigure)
   % Am I clicking in axes 1 or axes 2?
  hAxesParent  = get(get(event_obj,'Target'),'Parent');
   % get cursor position
  position = get(event_obj,'Position');
   % load gui data
  handles=guidata(hFigure);
  if hAxesParent==handles.axes1
    % code for linecut mode 
       if get(handles.linecut_bt,'Value') == 1
         % updateGraph(handles);
          if handles.firstclick==1
          handles.pos=position;
          handles.pos1 = position;
          handles.firstclick=0;
          UpdateGraph2(handles)

          else
          handles.pos=position;    
          handles.pos2 = position
          handles.firstclick=1;
          plottheline(handles)
          UpdateGraph2(handles)

          end 
   
       else
           if get(handles.holdon_bt,'Value') == 1
           hold(handles.axes1,'on')
           hold(handles.axes2,'on')
           scatter(handles.axes1,handles.pos(1),handles.pos(2),100,'filled')
           end
       handles.pos = position;
       UpdateGraph2(handles)
       end
   txt = [num2str(handles.pos(1)),',',num2str(handles.pos(2)),',',num2str(handles.Data.s1(handles.pos(1),handles.pos(2),handles.slider_n))];
   %disp(['You clicked X:',num2str(Current.pos(1)),', Y:',num2str(Current.pos(2)),',Z:',num2str(Current.zn)]);

   else
   handles.pos = position;
   txt = [num2str(handles.pos(1)),',',num2str(handles.pos(2))];
   %disp(['You clicked X:',num2str(Current.pos(1)),', Y:',num2str(Current.pos(2))]);
   end
   
   % update gui data
   guidata(hFigure, handles);

   
 
 
   %% Function for linecuts      
  function plottheline(handles)
     % global   Current
      x1=handles.pos1(1)
      x2=handles.pos2(1)
      y1=handles.pos1(2)
      y2=handles.pos2(2)
      if abs(x2-x1)>abs(y2-y1)
       mm=(y2-y1)./(x2-x1);
                    if x1>x2; 
                        xprof=x2:x1;
                    else
                        xprof=x1:x2;
                    end
                    
                    yprof=y1+round(mm.*(xprof-xprof(1)));
                 else
                     mm=(x2-x1)./(y2-y1);
                    if y1>y2; yprof=y2:y1;
                    else yprof=y1:y2;
                    end
                    xprof=x1+round(mm.*(yprof-yprof(1)));
      end
                 hold(handles.axes1,'on')
                 plot(handles.axes1,xprof,yprof,'black','Linewidth',2);
                 for i=1:length(xprof);
                 handles.eeeh(i,:)=squeeze(handles.Data.s1(xprof(i),yprof(i),:));
                 end
                 %eeeh(1,1);
                 %size(eeeh);
                 %hold(handles.axes2,'off');
                 h=figure();
                 imagesc(handles.eeeh');
                 
                 g=figure()
                 hold on
                 for i=1:length(xprof)
                 plot(handles.eeeh(i,:))
                 end
                 
                 f=figure()
                 hold on
                 handles.slider_n
                 for i=1:length(handles.Axis{3}.array)
                 plot(handles.eeeh(:,i))
                 end
                 
                 %Current.firstclick=true;



function edit_ch_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ch as text
%        str2double(get(hObject,'String')) returns contents of edit_ch as a double


% --- Executes during object creation, after setting all properties.
function edit_ch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_resize_Callback(hObject, eventdata, handles)
% hObject    handle to ed_resize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_resize as text
%        str2double(get(hObject,'String')) returns contents of ed_resize as a double


% --- Executes during object creation, after setting all properties.
function ed_resize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_resize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_autoscale.
function cb_autoscale_Callback(hObject, eventdata, handles)
% hObject    handle to cb_autoscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_autoscale



function ed_caxismax_Callback(hObject, eventdata, handles)
% hObject    handle to ed_caxismax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_caxismax as text
%        str2double(get(hObject,'String')) returns contents of ed_caxismax as a double


% --- Executes during object creation, after setting all properties.
function ed_caxismax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_caxismax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_caxismin_Callback(hObject, eventdata, handles)
% hObject    handle to ed_caxismin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_caxismin as text
%        str2double(get(hObject,'String')) returns contents of ed_caxismin as a double


% --- Executes during object creation, after setting all properties.
function ed_caxismin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_caxismin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
