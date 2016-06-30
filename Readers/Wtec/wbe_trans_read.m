function [T]=wbe_trans_read(fileID,pointer)
    fseek(fileID,pointer,'bof');
    T.unit_kind=fread(fileID,1,'uint64','l');
    a=ftell(fileID);
    T.data_units=wbe_data_info(fileID,a)
    b=a+24;
    fseek(fileID,b,'bof')
    T.type=fread(fileID,1,'uint64','l')
    T1_FP=fread(fileID,1,'uint64','l')
    if T.type==0
    T.data=wbe_data_info(fileID,T1_FP);
    end
    if T.type==1
    fseek(fileID,T1_FP,'bof')
    T.nr_dim=fread(fileID,1,'uint64','l')
    DAFP=fread(fileID,1,'uint64','l')
    BOFP=fread(fileID,1,'uint64','l')
    OFP=fread(fileID,1,'uint64','l')
    SMFP=fread(fileID,1,'uint64','l')
    RMFP=fread(fileID,1,'uint64','l')
    fseek(fileID,DAFP,'bof')
    T.dim_array=fread(fileID,3,'uint','l')
    fseek(fileID,BOFP,'bof')
    T.bin_origin=fread(fileID,3,'double','l')
    fseek(fileID,OFP,'bof')
    T.origin=fread(fileID,3,'double','l')
    fseek(fileID,SMFP,'bof')
    T.scale_matrix=fread(fileID,9,'double','l')
    fseek(fileID,RMFP,'bof')
    T.rot_matrix=fread(fileID,9,'double','l')
    end