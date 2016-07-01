% Jan 28th 2016, finally we got the documentation from Wtec.
% mreyescalvo@gmail.com 

% This are the specs for the different kinds of structures
% Data info structure (read with wbe_data_info)
%                   3 x int64: size, type, pointer
%                type 5242880 is 'uchar', 
% Object structure (read with function wbe_object_info.m)
%              3 x int64: type, pointer, nextobjecpointer (0 no more)
% WitecData structure (TO DO: function to load directly data)
%              int64 pointer for transformation
%              int64 unit kind (distance, spec, etc..., not clear yet)
%              Datainfostructure for unit (3 x int64: size, type, pointer)
%              Datainfostructure for data (....)
%              Datainfostructure for metastringdata (...)
% The structure of our typical wbe files is the following
% Bytes 0-7: Identifier ('uchar')
% Bytes 8-15: Version ('uint64')
% Bytes 16-39: Data info structure: size, type, pointer
% Bytes 40-47: Pointer for the first object (PFO)
% @ PFO: object: type (0), pointer (OFP1), next (0)
% @ OFP1: witecdata: pointtrans (TOIP1), ukind, datainfo unit, datainfo data, datainfo meta
% 
%


function readwbe(filename,filenameoutput)
  %clear all
    %[path,nam,ext]=fileparts(filename);
    fileID=fopen(filename);
%% First lets read the header
    Header.Originalfiletype='wbe';
    Header.Identifier=char(fread(fileID,8,'uchar'))'
    Header.Version=fread(fileID,1,'uint64','l')
    Header.FileInfo=wbe_data_info(fileID,16);
    
%% Lets go for the first object (I assume there are no more objects)
% in the future it could be necessary to do properly this part with a loop
% or so to account for more objects
    fseek(fileID,40,'bof');
    PFO=fread(fileID,1,'uint64','l')
    [OFP1,OFP2,OFP1_type]=wbe_object_info(fileID,PFO)
    if OFP2~=0 
        print('Warning: there seems to be more than 1 data objects to read!!')
    end
    fseek(fileID,OFP1,'bof');
    %get transformation pointer
    tran=fread(fileID,1,'uint64','l');
    % get data info and data
    data_unit_kind=fread(fileID,1,'uint64','l');
    a=ftell(fileID)
    Header.data_units=wbe_data_info(fileID,a)
    b=a+24;
    dat=wbe_data_info(fileID,b);
    d=b+24;
    Header.data_info=wbe_data_info(fileID,d);

 %% obtain transformations
    % again I assume here there are only 2, code can be adapted for more
    [TOIP1,TOIP2,TOIP1_type]=wbe_object_info(fileID,tran)
    [TOIP2,TOIP3,TOIP2_type]=wbe_object_info(fileID,TOIP2)
    if TOIP3~=0 
        print('Warning: there seems to be more than 2 transformations to read!!')
    end
   fseek(fileID,TOIP2,'bof')
   T1=wbe_trans_read(fileID,TOIP1);
   T2=wbe_trans_read(fileID,TOIP2);



    nx=T2.dim_array(1);
    ny=T2.dim_array(2);
    np=size(T1.data);
    np=np(1);
ejes.x_array=(1:nx).*T2.scale_matrix(1)+T2.origin(1);
ejes.y_array=(1:ny).*T2.scale_matrix(5)+T2.origin(2);
ejes.z_array=T1.data;
ejes.xrange=[ejes.x_array(1),ejes.x_array(end)];
ejes.yrange=[ejes.y_array(1),ejes.y_array(end)];
ejes.zrange=[ejes.z_array(1),ejes.z_array(end)]

data=reshape(dat,[np,nx,ny]);

data=permute(data,[2 3 1]);
fclose(fileID);

suma=zeros(nx,ny);
for i=1:np
    suma=suma+squeeze(data(:,:,i));
end

ejes.xlabel='X position';
ejes.ylabel='Y position';
ejes.zlabel='Wavelength';
ejes.dataunit=Header.data_units;
ejes.datalabel='Intensity';
ejes.xunit=T2.data_units;
ejes.yunit=T2.data_units;
ejes.zunit=T1.data_units;

savename=[filenameoutput,'.mat'];
save(savename,'Header','data','ejes');

figure()
imagesc(ejes.xrange,ejes.yrange,suma./np)
set(gca,'Fontsize',14);
xlabel([ejes.xlabel,'(',ejes.xunit,')'])
ylabel([ejes.ylabel,'(',ejes.yunit,')'])
title(['Sum  ',ejes.zlabel,'(',ejes.dataunit,')'])
colorbar

end

