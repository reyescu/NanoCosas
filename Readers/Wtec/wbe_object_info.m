function [pointout,nextobject,type]=wbe_object_info(fileID,pointer)
fseek(fileID,pointer,'bof');
    type=fread(fileID,1,'uint64','l');
    pointout=fread(fileID,1,'uint64','l');
    nextobject=fread(fileID,1,'uint64','l');
end