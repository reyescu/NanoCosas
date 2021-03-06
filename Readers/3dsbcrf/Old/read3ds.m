clear all
filename='WSe2_45_parallel_CCD_001.3ds';
[path,nam,ext]=fileparts(filename);
fileID=fopen(filename);


%%Reads line to line the header storing the values
headerline=sscanf(fgetl(fileID),'%c');
while strcmp(headerline,':HEADER_END:')==false;
    k=strfind(headerline,'=');
    str1=headerline(1:k-1);
    str2=headerline(k+1:end);
    Header.(genvarname(str1))=str2;
    headerline=sscanf(fgetl(fileID),'%c');
end
%Calculates size of the data matrix and reads it
a=strfind(Header.GridDim,' x ');
nx=str2num(Header.GridDim(2:a));
ny=str2num(Header.GridDim(a+3:end-1));
npar=str2num(Header.x0x23Parameters0x284Byte0x29);
nz=str2num(Header.Points);
b=strfind(Header.Channels,';');
if length(b)~=0
    n_channels=length(b)+1;
else
    n_channels=1;
end
ntot=npar+n_channels*nz;
n=nx*ny*ntot;

da=fread(fileID,n,'single','b');

if length(da)<n;
    da(length(da)+1:n)=0;
    fprintf('Warning: data is shorter than expected, zeros added\n')

end

fclose(fileID);
dat=reshape(da(1:n),[ntot,nx,ny]);
dat=permute(dat,[2 3 1]);
topo=squeeze(dat(:,:,5));
data=dat(:,:,6:end);
parstart=squeeze(dat(:,:,1));
parend=squeeze(dat(:,:,2));
xpos=squeeze(dat(:,:,3));
ypos=squeeze(dat(:,:,4));

i=npar+1;
if n_channels>1
for j=1:n_channels
data(j,:,:,:)=dat(:,:,i:i+nz-1);
i=i+nz;
end;
end

ejes.x_array=1:nx;
ejes.x_grid=xpos;
ejes.y_array=1:ny;
ejes.y_grid=ypos;
ejes.z_array=1:nz;
ejes.xrange=[ejes.x_array(1),ejes.x_array(end)];
ejes.yrange=[ejes.y_array(1),ejes.y_array(end)];

a=strfind(Header.SweepSignal,'(');
b=strfind(Header.ExperimentParameters,'(');
c=strfind(Header.ExperimentParameters,')');

ejes.xlabel='X position';
ejes.ylabel='Y position';
ejes.topolabel='Z topography';
ejes.zlabel=Header.SweepSignal(2:a-2);
ejes.xunit=Header.ExperimentParameters(b(1)+1:c(1)-1);
ejes.yunit=Header.ExperimentParameters(b(2)+1:c(2)-1);
ejes.topounit=Header.ExperimentParameters(b(3)+1:c(3)-1);
ejes.zunit=Header.SweepSignal(a+1:end-2);
ejes.datalabel=Header.Channels;
ejes.dataunit=''; %to be done properly

savename=[nam,'.mat'];
save(savename,'data','topo','ejes','Header');
if n_channels>1
for i=1:n_channels
    load(savename);
   data=squeeze(data(i,:,:,:));
   savename2=[nam,'_ch',int2str(i),'.mat'];
   save(savename2,'data','topo','ejes','Header');
end
end
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