function varargout = gui3dnew(varargin)
% GUI3DNEW MATLAB code for gui3dnew.fig
%      GUI3DNEW, by itself, creates a new GUI3DNEW or raises the existing
%      singleton*.
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

% Last Modified by GUIDE v2.5 02-Jul-2016 00:44:08

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
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui3dnew (see VARARGIN)

%initialize variables for linecut
handles.firstclick=1;
handles.pos2=[1,1];

% Choose default command line output for gui3dnew
handles.output = hObject;

%setup cursor
dcm_obj = datacursormode(gcf);
  datacursormode on;
  set(dcm_obj,'UpdateFcn', @myupdatefcn )
  handles.dcm_obj = datacursormode(hObject);
 set(handles.dcm_obj,'Enable','on','UpdateFcn',{@myupdatefcn,hObject});


% UIWAIT makes gui3dnew wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% Update handles structure
guidata(hObject, handles);


%% Load data and initialize graphs
% --- Executes on button press in bt_load.
function bt_load_Callback(hObject, eventdata, handles)
% hObject    handle to bt_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%load data
filename=get(handles.ed_filename,'String');
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
   %Initialize slider and z edits

set(handles.zarray_slider,'Min',1);
set(handles.zarray_slider,'Max',length(handles.Ejes.z_array));
set(handles.zarray_slider,'Value',1);

handles.zmax=handles.Ejes.z_array(end);
handles.zmin=handles.Ejes.z_array(1);
handles.zn = get(handles.zarray_slider, 'Value');
handles.zv =handles.Ejes.z_array(handles.zn);
set(handles.ed_zn, 'String',handles.zn);
set(handles.ed_zv, 'String', handles.zv);

% plot image
updateGraph(handles);
set(handles.axes1,'YDir','normal');
set(handles.axes1,'Fontsize',14);
xlabel(handles.axes1,[handles.Ejes.xlabel,'(',handles.Ejes.xunit,')'],'Fontsize',16);
ylabel(handles.axes1,[handles.Ejes.ylabel,'(',handles.Ejes.yunit,')'],'Fontsize',16);

%plot spec
handles.pos=[1,1];
UpdateGraph2(handles);
set(handles.axes2,'Fontsize',14);
xlabel(handles.axes2,[handles.Ejes.zlabel,'(',handles.Ejes.zunit,')'],'Fontsize',16);
ylabel(handles.axes2,[handles.Ejes.datalabel,'(',handles.Ejes.dataunit,')'],'Fontsize',16);

% Update handles structure
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = gui3dnew_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function zarray_slider_Callback(hObject, eventdata, handles)
% hObject    handle to zarray_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)   
handles.zn = round(get(hObject, 'Value'));
set(handles.ed_zn,'String',handles.zn);
   handles.zv = handles.Ejes.z_array(handles.zn);
   set(handles.ed_zv, 'String', handles.zv); 
   updateGraph(handles);



        

       % updateGraph()
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function zarray_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zarray_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end





function ed_zv_Callback(hObject, eventdata, handles)
% hObject    handle to ed_zv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_zv as text
%        str2double(get(hObject,'String')) returns contents of ed_zv as a double
   
handles.zv = str2double(get(hObject, 'String'));
        if (handles.zv > handles.zmax) 
            handles.zn=length(handles.Ejes.z_array);
            handles.zv=handles.zmax;
        else if (handles.zv < handles.zmin)
                handles.zn=1;
                handles.zv=handles.zmin;
            else
            handles.zn = find(handles.Ejes.z_array > handles.zv,1);
            end
        end
        set(handles.zarray_slider,'value', handles.zn);
        set(handles.ed_zn,'String',handles.zn);
        handles.zv = handles.Ejes.z_array(handles.zn);
        set(handles.ed_zv, 'String', handles.zv); 
        updateGraph(handles)
        
        
% --- Executes during object creation, after setting all properties.
function ed_zv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_zv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

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
 if get(handles.linecut_bt,'Value')==1
     set(handles.linecut_bt,'Value',0);
              updateGraph(handles);
 end



% --- Executes on button press in linecut_bt.
function linecut_bt_Callback(hObject, eventdata, handles)
% hObject    handle to linecut_bt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of linecut_bt
         updateGraph(handles);

if get(handles.holdon_bt,'Value')==1
    set(handles.holdon_bt,'Value',0);
end


function updateGraph(handles)
%global  Current
        test=squeeze(handles.Data(:,:,handles.zn));
        imagesc(test','Parent',handles.axes1);
         colorbar(handles.axes1);
        set(handles.axes1,'YDir','normal');
        set(handles.axes1,'Fontsize',14);
        xlabel(handles.axes1,[handles.Ejes.xlabel,'(',handles.Ejes.xunit,')'],'Fontsize',16);
        ylabel(handles.axes1,[handles.Ejes.ylabel,'(',handles.Ejes.yunit,')'],'Fontsize',16);
       
        % Update frequency and amplitude text
       
        %set(A_edit, 'String', A)



function ed_zn_Callback(hObject, eventdata, handles)
% hObject    handle to ed_zn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_zn as text
%        str2double(get(hObject,'String')) returns contents of ed_zn as a double
%global  Current   
handles.zn = round(str2double(get(hObject, 'String')));
set(handles.zarray_slider,'Value',handles.zn);
   handles.zv = handles.Ejes.z_array(handles.zn);
   set(handles.ed_zv, 'String', handles.zv); 
   updateGraph(handles);


% --- Executes during object creation, after setting all properties.
function ed_zn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_zn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function txt = myupdatefcn(~, event_obj,hFigure)
  %global  Current
  %axes(handles.axes1);
   hAxesParent  = get(get(event_obj,'Target'),'Parent');
   position = get(event_obj,'Position');
   handles=guidata(hFigure);
   if hAxesParent==handles.axes1
   %disp('hey') 
     if get(handles.linecut_bt,'Value') == 1
         updateGraph(handles);
      if handles.firstclick==1
          handles.pos = position;
          handles.firstclick=0;
          %disp('hey')
      else
          handles.pos2 = position;
          plottheline(handles);
          handles.firstclick=1;
        %  guidata(hFigure, handles);
         % disp('ho')
      end 

     else
   handles.pos = position;
   %plot(hand.axes2,handles.Ejes.z_array, squeeze(handles.Data(Current.pos(1),Current.pos(2),:)));
     UpdateGraph2(handles)
     end
   txt = [num2str(handles.pos(1)),',',num2str(handles.pos(2)),',',num2str(handles.Data(handles.pos(1),handles.pos(2),handles.zn))];
   %disp(['You clicked X:',num2str(Current.pos(1)),', Y:',num2str(Current.pos(2)),',Z:',num2str(Current.zn)]);

   else
      txt = [num2str(handles.pos(1)),',',num2str(handles.pos(2))];
   %disp(['You clicked X:',num2str(Current.pos(1)),', Y:',num2str(Current.pos(2))]);
   end
   if get(handles.holdon_bt,'Value') == 1
   hold(handles.axes1,'on')
   hold(handles.axes2,'on')
   scatter(handles.axes1,handles.pos(1),handles.pos(2),100,'filled')
   end
         guidata(hFigure, handles);

   %if 
   %        scatter(hand.axes1,pos(1),pos(2),'filled');
   %     end
%         if get(profilebutton,'Value')
%          %firstprofileclick;
%            if firstprofileclick==true;
%               x1=pos(1);
%               y1=pos(2);
%               firstprofileclick=false;
%            else
%               x2=pos(1);
%               y2=pos(2);
%               %class(x2)
%               plottheline(x1,x2,y1,y2);
%            end
%         end
%    end
  %end
 
 
    function UpdateGraph2(handles)
        %global  Current
        plot(handles.axes2,handles.Ejes.z_array, squeeze(handles.Data(handles.pos(1),handles.pos(2),:)));
        set(handles.axes2,'Fontsize',14);
        xlabel(handles.axes2,[handles.Ejes.zlabel,'(',handles.Ejes.zunit,')'],'Fontsize',16);
        ylabel(handles.axes2,[handles.Ejes.datalabel,'(',handles.Ejes.dataunit,')'],'Fontsize',16);

        
  function plottheline(handles)
     % global   Current
      x1=handles.pos(1);
      x2=handles.pos2(1);
      y1=handles.pos(2);
      y2=handles.pos2(2);
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
                    if y1>y2; yprof=y2:y1 ;
                    else yprof=y1:y2; end
                    xprof=x1+round(mm.*(yprof-yprof(1)));
      end
                 hold(handles.axes1,'on')
                 plot(handles.axes1,xprof,yprof,'black','Linewidth',2);
                 for i=1:length(xprof);
                 handles.eeeh(i,:)=squeeze(handles.Data(xprof(i),yprof(i),:));
                 end
                 %eeeh(1,1);
                 %size(eeeh);
                 %hold(handles.axes2,'off');
                 h=figure();
                 imagesc(handles.eeeh');
                 %Current.firstclick=true;
    



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
