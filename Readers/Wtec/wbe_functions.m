function [size,type,pointout,position]=wbe_read_data(fileID,pointer)
fseek(fileID,pointer);
size=fread(fileID,1,'uint64','l');
type=fread(fileID,1,'uint64','l');
pointout=fread(fileID,1,'uint64','l');
end