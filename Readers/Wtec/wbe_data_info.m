function [output]=wbe_data_info(fileID,pointer)
fseek(fileID,pointer,'bof');
size=fread(fileID,1,'uint64','l');
type=fread(fileID,1,'uint64','l');
pointout=fread(fileID,1,'uint64','l');
fseek(fileID,pointout,'bof');
    if type==5242880
        output=char(fread(fileID,size,'uchar'))';
    end
    if type==3145728
    output=fread(fileID,size,'float','l');
    end
    if type==3145729
    output=fread(fileID,size,'double','l');
    end
end