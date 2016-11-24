filename = '/Users/reyes/Downloads/Default.lut';
delimiter = '';
clear redss greenss blues
formatSpec = '%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

texto = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
texto=texto{1};

%% Close the text file.
clear slut slut2
fclose(fileID);
x=1:256;

for i=1:5
    start=4;
    a=findstr(texto{start+i},'(')
    b=findstr(texto{start+i},',')
    c=findstr(texto{start+i},')')
    reds(i,1)=str2double(texto{start+i}(a+1:b-1));
    reds(i,2)=str2double(texto{start+i}(b+1:c-1));
end
figure()
scatter(reds(:,1),reds(:,2),'filled','red')
hold on
yyred=interp1(reds(:,1),reds(:,2),x,'cubic');
plot(x,yyred,'red')

for i=1:7
    start=11;
   a=findstr(texto{start+i},'(')
    b=findstr(texto{start+i},',')
    c=findstr(texto{start+i},')')
    greenss(i,1)=str2double(texto{start+i}(a+1:b-1));
    greenss(i,2)=str2double(texto{start+i}(b+1:c-1));
end
hold on
scatter(greenss(:,1),greenss(:,2),'filled','green')
yygreen=interp1(greenss(:,1),greenss(:,2),x,'cubic');
plot(x,yygreen,'green')

for i=1:6
    start=28;
   a=findstr(texto{start+i},'(')
    b=findstr(texto{start+i},',')
    c=findstr(texto{start+i},')')
    blues(i,1)=str2double(texto{start+i}(a+1:b-1));
    blues(i,2)=str2double(texto{start+i}(b+1:c-1));
end
hold on
scatter(blues(:,1),blues(:,2),'filled','blue')
yyblue=interp1(blues(:,1),blues(:,2),x,'cubic');
plot(x,yyblue,'blue')
axis([0 255 0 255])
%% Clear temporary variablesfor i=1

slut(:,1)=yyred;
slut(:,2)=yygreen;
slut(:,3)=yyblue;
%slut2=[yyred, yygreen, yyblue];


clearvars filename delimiter formatSpec fileID dataArray ans;