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

% Last Modified by GUIDE v2.5 01-Jul-2016 18:14:06

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


% --- Executes just before gui3dnew is made visible.
function gui3dnew_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui3dnew (see VARARGIN)
%global da ejes
%Load data: change to text field plus load button, then move all the
%initialization to load button callback
%global Header Data Ejes
fi=load('14BR_C.mat');
global Header Data Ejes Current
   Header=fi.Header;
   Data=fi.data;
   Ejes=fi.ejes;
    
%Initialize slider and z edits

set(handles.zarray_slider,'Min',1);
set(handles.zarray_slider,'Max',length(Ejes.z_array));
set(handles.zarray_slider,'Value',1);

Current.zmax=Ejes.z_array(end);
Current.zmin=Ejes.z_array(1);
Current.zn = get(handles.zarray_slider, 'Value');
Current.zv =Ejes.z_array(Current.zn_now);
set(handles.ed_zn, 'String',Current.zn_now);
set(handles.ed_zv, 'String', Current.zv_now);

% plot image
updateGraph(handles);
set(handles.axes1,'YDir','normal');
set(handles.axes1,'Fontsize',14);
xlabel(handles.axes1,[Ejes.xlabel,'(',Ejes.xunit,')'],'Fontsize',16);
ylabel(handles.axes1,[Ejes.ylabel,'(',Ejes.yunit,')'],'Fontsize',16);

%plot spec
%Current.pos=[1,1];
%UpdateGraph2(handles);
%set(handles.axes2,'YDir','normal');
set(handles.axes2,'Fontsize',14);
xlabel(handles.axes2,[Ejes.zlabel,'(',Ejes.zunit,')'],'Fontsize',16);
ylabel(handles.axes2,[Ejes.datalabel,'(',Ejes.dataunit,')'],'Fontsize',16);


handles.output = hObject;


%setup cursor
dcm_obj = datacursormode(gcf);
  datacursormode on;
  set(dcm_obj,'UpdateFcn', @myupdatefcn )
  handles.dcm_obj = datacursormode(hObject);
 set(handles.dcm_obj,'Enable','on','UpdateFcn',{@myupdatefcn,hObject});




% Choose default command line output for gui3dnew

% Update handles structure
guidata(hObject, handles);




% UIWAIT makes gui3dnew wait for user response (see UIRESUME)
% uiwait(handles.figure1);


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
global Ejes Current   
Current.zn = round(get(hObject, 'Value'));
set(handles.ed_zn,'String',Current.zn);
   Current.zv = Ejes.z_array(Current.zn);
   set(handles.ed_zv, 'String', Current.zv); 
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
global Ejes Current   
Current.zv = str2double(get(hObject, 'String'));
        if (Current.zv > Current.zmax) 
            Current.zn=length(Ejes.z_array);
            Current.zv=Current.zmax;
        else if (Current.zv < Current.zmin)
                Current.zn=1;
                Current.zv=Current.zmin;
            else
            Current.zn = find(Ejes.z_array > Current.zv,1);
            end
        end
        set(handles.zarray_slider,'value', Current.zn);
        set(handles.ed_zn,'String',Current.zn);
        Current.zv = Ejes.z_array(Current.zn);
        set(handles.ed_zv, 'String', Current.zv); 
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
 global Data Ejes Current
  axes(handles.axes2);
        plot(Ejes.z_array, squeeze(Data(Current.pos(1),Current.pos(2),:)));



% --- Executes on button press in linecut_bt.
function linecut_bt_Callback(hObject, eventdata, handles)
% hObject    handle to linecut_bt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of linecut_bt

function updateGraph(handles)
global Data Ejes Current
        test=squeeze(Data(:,:,Current.zn));
        imagesc(test','Parent',handles.axes1);
         colorbar(handles.axes1);
        set(handles.axes1,'YDir','normal');
        set(handles.axes1,'Fontsize',14);
        xlabel(handles.axes1,[Ejes.xlabel,'(',Ejes.xunit,')'],'Fontsize',16);
        ylabel(handles.axes1,[Ejes.ylabel,'(',Ejes.yunit,')'],'Fontsize',16);
       
        % Update frequency and amplitude text
       
        %set(A_edit, 'String', A)



function ed_zn_Callback(hObject, eventdata, handles)
% hObject    handle to ed_zn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_zn as text
%        str2double(get(hObject,'String')) returns contents of ed_zn as a double
global Ejes Current   
Current.zn = round(str2double(get(hObject, 'String')));
set(handles.zarray_slider,'Value',Current.zn);
   Current.zv = Ejes.z_array(Current.zn);
   set(handles.ed_zv, 'String', Current.zv); 
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
  global Ejes Data Current
  %axes(handles.axes1);
   hAxesParent  = get(get(event_obj,'Target'),'Parent');
   pos = get(event_obj,'Position');
   hand=guidata(hFigure);
   if hAxesParent==hand.axes1
   %disp('hey') 
   Current.pos = pos;
   %plot(hand.axes2,Ejes.z_array, squeeze(Data(Current.pos(1),Current.pos(2),:)));
   UpdateGraph2(hand)
   txt = [num2str(pos(1)),',',num2str(pos(2)),',',num2str(Data(pos(1),pos(2),Current.zn))];
   %disp(['You clicked X:',num2str(Current.pos(1)),', Y:',num2str(Current.pos(2)),',Z:',num2str(Current.zn)]);

   else
      txt = [num2str(pos(1)),',',num2str(pos(2))];
   %disp(['You clicked X:',num2str(Current.pos(1)),', Y:',num2str(Current.pos(2))]);
   end
   if get(hand.holdon_bt,'Value') == 1
   hold(hand.axes1,'on')
   hold(hand.axes2,'on')
   scatter(hand.axes1,pos(1),pos(2),100,'filled')
   end
   
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
        global Data Ejes Current
        plot(handles.axes2,Ejes.z_array, squeeze(Data(Current.pos(1),Current.pos(2),:)));
        set(handles.axes2,'Fontsize',14);
        xlabel(handles.axes2,[Ejes.zlabel,'(',Ejes.zunit,')'],'Fontsize',16);
        ylabel(handles.axes2,[Ejes.datalabel,'(',Ejes.dataunit,')'],'Fontsize',16);
