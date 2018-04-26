function dxf_vertexrc(FID,vertex_array)
%DXF_OPEN Open DXF file.
%   Fid = DXF_OPEN(fname) opens DXF file for writing and writes the DXF 
%   file header. The function returns the matlab structure 'Fid' with 
%   various parameters used later by other drawing functions. One must 
%   use this structure in the subsequent calls to drawing routines.
%   
%   REMARKS
%     The assumed units are meters.
%   
%   See also DXF_CLOSE

%   Copyright 2010-2011 Grzegorz Kwiatek
%   $Revision: 1.1.4 $  $Date: 2011.11.15 $

%try
  
  %fid = fopen(fname,'w');

  % Setup default values.
  %FID.filename = fname;
  fid=FID.fid;
 %FID.show = false;
 % FID.dump = true;
  
  %FID.layer = 0;
  %FID.color = 255;
  %FID.textheight = 1;  
  %FID.textrotation = 0;  
%	FID.textthickness = 0;  
%	FID.textalignment = 0;  
%	FID.textvalignment = 0;  
%	FID.textextrusion = [0 0 1];  
%	FID.textobliqueangle = 0;  

% fprintf(fid,'0\nPOLYLINE\n');
% fprintf(fid,'8\n0\n10\n0\n20\n0\n30\n0\n70\n8\n0\n');

for i=1:length(vertex_array(:,1));

fprintf(fid,'VERTEX\r\n8\r\n0\r\n62\r\n255\r\n');

a=vertex_array(i,1);
b=vertex_array(i,2);

fprintf(fid,'10\r\n');
fprintf(fid,num2str(a));
fprintf(fid,'\r\n');
fprintf(fid,'20\r\n');
fprintf(fid,num2str(b));
fprintf(fid,'\r\n');

fprintf(fid,'30\r\n0\r\n70\r\n32\r\n0\r\n');
end

fprintf(fid,'SEQEND\r\n8\r\n0\r\n');


%   fprintf(fid,'2\nTABLES\n');
%   fprintf(fid,'0\nTABLE\n');
%   fprintf(fid,'2\nLAYER\n');
%   fprintf(fid,'70\n1\n');
%   fprintf(fid,'0\nLAYER\n');
%   fprintf(fid,'2\n0\n70\n0\n62\n7\n6\n');
%   fprintf(fid,'CONTINUOUS\n0\n');
%   fprintf(fid,'ENDTAB\n0\n');
%   fprintf(fid,'ENDSEC\n');
%   fprintf(fid,'0\nSECTION\n');
%   fprintf(fid,'2\nBLOCKS\n');
%   fprintf(fid,'0\nENDSEC\n');
%   fprintf(fid,'0\nSECTION\n');
%   

  %fprintf(fid,'9\n$ACADVER\n1\nAC1006\n'); % Default units: meters.
  %fprintf(fid,'9\n$INSUNITS\n70\n6\n'); % Default units: meters.
  %fprintf(fid,'0\nENDSEC\n');

  % Start entities or produce TABLE first.
  %if nargin ~= 1
  %  dxf_layertable(FID, varargin);
  %end
  
  % Dump entities section.
  %fprintf(FID.fid,'0\nSECTION\n');

 
  %fprintf(fid,'2\nENTITIES\n');

%catch exception
%  if FID.fid >= 0
%    fclose(FID.fid);
%  end
%  rethrow(exception);
end
