clear all

%% version comments
%because labview routines do not save yet perfectly positions and some
%other parameters, the actual positions are not yet read

%% set name of file to convert and add info manually
filename='WSe2_45_cross_100x100_CCD_001.3ds';
Info.file=filename;
Info.date='17/01/2017';
Info.measurement='test CCD spatial map';
Info.sample='WSe2_ML_YIG';
Info.n_ax=3;
Info.n_sw=1;


%% open file
[path,nam,ext]=fileparts(filename);
fileID=fopen(filename);

%% Reads line to line the header storing the values
headerline=sscanf(fgetl(fileID),'%c');
while strcmp(headerline,':HEADER_END:')==false;
    k=strfind(headerline,'=');
    str1=headerline(1:k-1);
    str2=headerline(k+1:end);
    Header.(genvarname(str1))=str2;
    headerline=sscanf(fgetl(fileID),'%c');
end
clear str1 str2
Info.comments=Header;

%% Parse information from header
% Grid dimensions
a=strfind(Header.GridDim,' x ');
n1=str2num(Header.GridDim(2:a));
n2=str2num(Header.GridDim(a+3:end-1));

% Grid settings (I am not sure yet what is this useful for)
clear a ini
a=strfind(Header.GridSettings,';');
ini=1;
for i=1:length(a)
gridset(i)=str2num(Header.GridSettings(ini:a(i)));
ini=a(i)+1;
end
gridset(length(a)+1)=str2num(Header.GridSettings(ini:end));

%Sweep signal, axis3
a=strfind(Header.SweepSignal,'(');
ax{3}.parameter=Header.SweepSignal(2:a-2);
ax{3}.unit=Header.SweepSignal(a+1:end-2);

%Experiment parameters %This is done for the most general case in which the grid is done in
%position
b=strfind(Header.ExperimentParameters,'(');
c=strfind(Header.ExperimentParameters,')');

ax{1}.parameter='X position';
ax{2}.parameter='Y position';
ax{1}.unit=Header.ExperimentParameters(b(1)+1:c(1)-1);
ax{2}.unit=Header.ExperimentParameters(b(2)+1:c(2)-1);
topo.unit=Header.ExperimentParameters(b(3)+1:c(3)-1);
% I deal with topography later, since I will consider it a channel

% number of total parameters
npar=str2num(Header.x0x23Parameters0x284Byte0x29);

% Sweep points
n3=str2num(Header.Points);

% Channel names
clear a b c
a=strfind(Header.Channels,';');
n_ch=length(a)+1;
Info.n_ch=n_ch;
ini=2;
for i=1:n_ch
b=strfind(Header.Channels,'(');
c=strfind(Header.Channels,')');
ch{i}.parameter=Header.Channels(ini:b(i)-2);
ch{i}.unit=Header.Channels(b(i):c(i));
ini=c(i)+1;
end
ch{n_ch+1}.parameter='Topography';


%% Calculates size of the data matrix and reads it

% if n_ch>1
%     ini=2;
%     for i=1:(n_ch-1)
%     channel_info(i)=Header.Channels(ini:a(i));
%     ini=a(i)+2;
%     end
%     channel_info(n_ch)=Header.Channels(ini:end-1);
%     fprintf('Conversion of multiple channel files is not yet fully tested')
% else
%     channel_info=Header.Channels(2:end-1);
% end
ntot=npar+n_ch*n3;
n=n1*n2*ntot;

da=fread(fileID,n,'single','b');

if length(da)<n;
    da(length(da)+1:n)=0;
    fprintf('Warning: data is shorter than expected, zeros added\n')
end

fclose(fileID);

%% reshape and organize data
dat=reshape(da(1:n),[ntot,n1,n2]);
dat=permute(dat,[2 3 1]);

data=dat(:,:,(npar+1):end);

par1=squeeze(dat(:,:,1));
par2=squeeze(dat(:,:,2));
% if data is properly saved
%ax{3}.range=[par1(1,1),par2(1,1)];
%ax{3}.array=par1(1,1):(par2(1,1)-par1(1,1))./n3:par2(1,1)
% if data is properly saved, this is x positions
par3=squeeze(dat(:,:,3));
%ax{1}.s1=par3;
par4=squeeze(dat(:,:,4));
%ax{2}.s2=par4;

%topography
par5=squeeze(dat(:,:,5));
ch{n_ch+1}.s1=par5;

i=npar+1;
%if n_ch>1
for j=1:n_ch
ch{j}.s1=dat(:,:,i:i+n3-1);
i=i+n3;
end;
%end

%% to do: take here the actual positions and range of sweeps
ax{1}.array=1:n1;
ax{1}.s1=par1;
ax{2}.array=1:n2;
ax{2}.s1=par2;
ax{3}.array=1:n3;
for i=1:3
ax{i}.range=[ax{i}.array(1),ax{i}.array(end)];
end

savename=[nam,'.mat'];
save(savename,'Info','ch','ax');
% if n_ch>1
% for i=1:n_ch
%     load(savename);
%    data=squeeze(data(i,:,:,:));
%    savename2=[nam,'_ch',int2str(i),'.mat'];
%    save(savename2,'data','ejes','Header');
% end
% end
clear all
%% TODO: get names of channels and assign to ejes.datalabel

% suma=zeros(nx,ny);
% for i=1:nz
%     suma=suma+squeeze(data(:,:,i));
% end
% figure()
% imagesc(ejes.xrange,ejes.yrange,suma./nz)
% set(gca,'Fontsize',14);
% xlabel([ejes.xlabel,'(',ejes.xunit,')'])
% ylabel([ejes.ylabel,'(',ejes.yunit,')'])
% title(['Sum  ',ejes.zlabel,'(',ejes.dataunit,')'])
% colorbar