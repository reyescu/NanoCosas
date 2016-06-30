clear all
filename='L65_50-50_CP45_Paralel_CCD_040.3ds';
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
ntot=npar+nz;
n=nx*ny*ntot;

da=fread(fileID,n,'single','b');
fclose(fileID);
dat=reshape(da(1:n),[ntot,nx,ny]);
dat=permute(dat,[2 3 1]);
topo=squeeze(dat(:,:,5));
data=dat(:,:,6:end);

%%This parts creates the arrays necessary for 3d plotting
%%Needs to be done properly for this kind of file so that it reads all this
%%from the header


ejes.x_array=1:nx;
ejes.y_array=1:ny;
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

savename=[nam,'.mat'];
save(savename,'data','topo','ejes','Header');


suma=zeros(nx,ny);
for i=1:nz
    suma=suma+squeeze(data(:,:,i));
end
figure()
imagesc(ejes.xrange,ejes.yrange,suma./nz)
set(gca,'Fontsize',14);
xlabel([ejes.xlabel,'(',ejes.xunit,')'])
ylabel([ejes.ylabel,'(',ejes.yunit,')'])
title(['Sum  ',ejes.zlabel,'(',ejes.dataunit,')'])
colorbar