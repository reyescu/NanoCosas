% Analysis of 3-d data GUI v0
% by Reyes Calvo
% Last updated Oct 2015
% Use data32_gui('example.mat')
% Opens a .mat file containing:
%   header cotaining miscellaneous information about the file
%           Header.data_units contains units for data
%   data matrix(xpos,ypos,zpos)
%   ejes structure containing axis labels, units, etc

function data3d_gui(filename)
 %% Object declarations
    % Create a window for the GUI
    window = figure('Color', [0.9255 0.9137 0.8471],...
                    'Name', '3D data analysis',...
                    'DockControl', 'off',...
                    'Units', 'Pixels',...
                    'Position', [100 50 800 600]);
 
    % Add axes on left side for time domain plot
    ax1 = axes('Parent', window,...
                    'Units', 'normalized',...
                    'Position', [0.07 0.37 0.40 0.58],...
                    'Fontsize',16);
 
    % Add axes on right side for frequency domain plot
    ax2 = axes('Parent', window,...
                    'Units', 'normalized',...
                    'Position', [0.55 0.37 0.40 0.58],...
                    'Fontsize',16);
 
    % Add "Frequency" slider control to window
    f_slider = uicontrol('Parent', window,...
                    'Style', 'slider',...
                    'Units', 'normalized',...
                    'Position', [0.18 0.2 0.6 0.08],...
                    'Min', 1,...
                    'Max', 1000,...
                    'Value', 532,...
                    'Callback', @fsliderCallback);
 
    % Add "Frequency" edit control to window
    f_edit = uicontrol('Parent', window,...
                    'Style', 'edit',...
                    'FontSize', 18,...
                    'Units', 'normalized',...
                    'Position', [0.82 0.22 0.16 0.08],...
                    'Callback',@feditCallback);
 
    % Add "Amplitude" edit control to window
%     A_edit = uicontrol('Parent', window,...
%                     'Style', 'edit',...
%                     'FontSize', 18,...
%                     'Units', 'normalized',...
%                     'Position', [0.82 0.12 0.16 0.08]);
 
    % Add "Frequency" label control to window
    f_label = uicontrol('Parent', window,...
                    'Style', 'text',...
                    'String', 'CCD pixel',...
                    'FontSize', 18,...
                    'Units', 'normalized',...
                    'Position', [0.02 0.26 0.12 0.04]);
 
    % Add "Amplitude" label control to window
%     A_label = uicontrol('Parent', window,...
%                     'Style', 'text',...
%                     'String', 'Amplitude:',...
%                     'FontSize', 18,...
%                     'Units', 'normalized',...
%                     'Position', [0.02 0.12 0.16 0.08]);
 
     %Add "Sin" button to window
      abutton = uicontrol('Parent', window,...
                    'Style', 'togglebutton',...
                    'String', 'hold on',...
                    'FontSize', 18,...
                    'Units', 'normalized',...
                    'Position', [0.3 0.12 0.16 0.08],...
                     'Callback', @holdCallback);
        profilebutton = uicontrol('Parent', window,...
                    'Style', 'togglebutton',...
                    'String', 'Linecut',...
                    'FontSize', 18,...
                    'Units', 'normalized',...
                    'Position', [0.1 0.12 0.16 0.08],...
                     'Callback', @LinecutCallback);
   %% data loading
    % Set up signal data
    fi=load(filename);
    header=fi.Header;
    da=fi.data;
    ejes=fi.ejes;
   
    set(f_slider,'Min',1);
    set(f_slider,'Max',length(ejes.z_array));
    set(f_slider,'Value',1);
    z_max=ejes.z_array(end);
    z_min=ejes.z_array(1);
    %x=1:length(da(1,1,:));
    % Set up plot titles and axis labels
    
 
    % Call the slider callback function once when the
    % program first runs to make sure that the plots
    % appear immediately (without any user click)
    lambda = get(f_slider, 'Value');
    z_value=ejes.z_array(lambda);
    set(f_edit, 'String', z_value);

    updateGraph();
    firstprofileclick=true;
    dcm_obj = datacursormode(window);
    datacursormode on;
    set(dcm_obj,'UpdateFcn', @myupdatefcn );
  
   %% function declarations 
     i=0; x1=0; x2=0; y1=0; y2=0;
    function txt=myupdatefcn(empty,event_obj)
     i=i+1;
     if i>3 & mod(i,2)==0
        pos=get(event_obj,'Position');
        plot(ax2, ejes.z_array, squeeze(da(pos(1),pos(2),:)));
        set(ax2,'FontSize',14);
        xlabel(ax2,[ejes.zlabel,'(',ejes.zunit,')'],'Fontsize',16);
        if get(abutton,'Value')
           scatter(ax1,pos(1),pos(2),'filled');
        end
        if get(profilebutton,'Value')
         %firstprofileclick;
           if firstprofileclick==true;
              x1=pos(1);
              y1=pos(2);
              firstprofileclick=false;
           else
              x2=pos(1);
              y2=pos(2);
              %class(x2)
              plottheline(x1,x2,y1,y2);
           end
        end
     end
    end
         function plottheline(x1,x2,y1,y2)
              
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
                 plot(ax1,xprof,yprof,'black','Linewidth',2);
                 for i=1:length(xprof);
                 eeeh(i,:)=squeeze(da(xprof(i),yprof(i),:));
                 end
                 eeeh(1,1);
                 size(eeeh);
                 hold(ax2,'off');
                 imagesc(eeeh','Parent',ax2);
                 firstprofileclick=true;
         end
    

    function LinecutCallback(hObj, event)
        button_state = get(hObj,'Value');
        updateGraph()
        if button_state==1
            set(abutton,'Value',0);
            firstprofileclick=true;
            hold(ax1,'on');
        else
             updateGraph();
             hold(ax1,'off');
        end
    end
    function holdCallback(hObj, event)
        button_state = get(hObj,'Value');
        if button_state==1
             hold(ax2,'on')
             hold(ax1,'on')
        else
             hold(ax2,'off')
             hold(ax1,'off')
             updateGraph()
        end
    end
 
    function feditCallback(hObj, event)
        z_value = str2double(get(f_edit, 'String'));
        if (z_value > z_max) 
            lambda=length(ejes.z_array);
            z_value=z_max;
        else if (z_value < z_min)
                lambda=1;
                z_value=z_min;
            else
            lambda = find(ejes.z_array > z_value,1);
            end
        end
        set(f_slider,'value', lambda);
        updateGraph()
        fsliderCallback();
    end

    function fsliderCallback(hObj,event)
        lambda =  round(get(f_slider, 'Value'));
        z_value = ejes.z_array(lambda);
        set(f_edit, 'String', z_value);
        updateGraph()
    end
    % Callback funuction for both slider controls
    function updateGraph(hObj, event)
      
        test=squeeze(da(:,:,lambda));
        imagesc(test','Parent',ax1);
        set(ax1,'YDir','normal');
        set(ax1,'Fontsize',14);
        xlabel(ax1,[ejes.xlabel,'(',ejes.xunit,')'],'Fontsize',16);
        ylabel(ax1,[ejes.ylabel,'(',ejes.yunit,')'],'Fontsize',16);

        % Update frequency and amplitude text
       
        %set(A_edit, 'String', A)
    end
 
end