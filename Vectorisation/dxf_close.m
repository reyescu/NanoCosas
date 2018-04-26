function dxf_close(FID)
%DXF_CLOSE Close DXF file.
%   DXF_CLOSE(FID) closes the DXF file opened with DXF_OPEN command.
%   
%   See also DXF_OPEN

%   Copyright 2010-2011 Grzegorz Kwiatek
%   $Revision: 1.1.2 $  $Date: 2011.08.25 $

try
  fprintf(FID.fid,'0\r\nENDSEC\r\n0\r\nEOF');
  fclose(FID.fid);
catch exception
  if FID.fid >= 0
    fclose(FID.fid);
  end
  rethrow(exception);
end