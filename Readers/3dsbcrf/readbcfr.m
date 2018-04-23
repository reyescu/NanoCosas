%clear all
fileID=fopen('SC_015-Topography-bwd.bcrf');
headersize=2048;
%[a,count]=fread(fileID,2048,'uchar');
%Header=char(a);
headerline=fgetl(fileID);

while headerline(1:2)~='  ';
    k=strfind(headerline,'=');
    str1=headerline(1:k-1);
    str2=headerline(k+2:end);
    header.(genvarname(str1))=str2;
    headerline=fgetl(fileID);
end

nx=str2num(header.xpixels);
ny=str2num(header.ypixels);
xrange=[str2num(header.xoffset) str2num(header.xoffset)+str2num(header.xlength)];
yrange=[str2num(header.yoffset) str2num(header.yoffset)+str2num(header.ylength)];
data=fread(fileID,[nx ny],'single','b');
fclose(fileID);
figure()
imagesc(xrange,yrange,data)
set(gca,'Fontsize',14);
xlabel(header.xunit,'Fontsize',16);
ylabel(header.yunit,'Fontsize',16);
colorbar
title(header.zunit,'Fontsize',16);