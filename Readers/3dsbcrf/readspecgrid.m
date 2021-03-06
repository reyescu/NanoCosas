clear all

%% version comments
%because labview routines do not save yet perfectly positions and some
%other parameters, the actual positions are not yet read

%% set name of file to convert and add info manually
filename='A170304.001754.specgrid';
Info.file=filename;
Info.date='16/12/2016';
Info.measurement='test';
Info.sample='test';
Info.n_ax=3;
Info.n_sw=1;


%% open file
[path,nam,ext]=fileparts(filename);
fileID=fopen(filename);

header=fread(fileID,1024);
Info.comments=header;

n1=header(77)
n2=header(85)
n_ch=header(57) % not sure about this being the nr of channels
%specL_pure=header(47)
%specL=header(29);
%This needs to be set by hand
n3=1200;
da=fread(fileID,Inf,'single');

fclose(fileID);

bias=da(1:2:2*n3);
zeta=da(2:2:2*n3);
data=da(2*n3+1:end);

for i=1:n_ch
ch2{i}=permute(reshape(data(i:n_ch:end),[n3,n1,n2]),[2 3 1]); 
ch{i}.s1=ch2{i}(:,:,100:1100);
clear ch2;
end
ch{1}.parameter='Current';
ch{2}.parameter='Current';
ch{3}.parameter='di/dv';

ch{4}.parameter='di/dv';
ch{1}.unit='(V dac)';
ch{2}.unit='(V dac)';
ch{3}.unit='(a.u.)';
ch{4}.unit='(a.u.)';

ax{1}.parameter='X position';
ax{1}.unit='(tbd)';
ax{1}.array=1:n1;
%ax{1}.s1=zeros(n1,n2,n3);
ax{1}.s1=repmat(ax{1}.array',1,n2,n3);
ax{2}.parameter='Y position';
ax{2}.unit='(tbd)';
ax{2}.array=1:n2;
ax{2}.s1=repmat(ax{2}.array,n1,1,n3);
ax{3}.parameter='V bias';
ax{3}.unit='mV';
ax{3}.array=bias(100:1100);
ax{3}.s1=permute(repmat(ax{3}.array,1,n1,n2),[2 3 1]);

savename=[nam,'.mat'];
save(savename,'Info','ch','ax');
clear all
% % if n_ch>1
% % for i=1:n_ch
% %     load(savename);
% %    data=squeeze(data(i,:,:,:));
% %    savename2=[nam,'_ch',int2str(i),'.mat'];
% %    save(savename2,'data','ejes','Header');
% % end
% % end
% clear all
% %% TODO: get names of channels and assign to ejes.datalabel
% 
% % suma=zeros(nx,ny);
% % for i=1:nz
% %     suma=suma+squeeze(data(:,:,i));
% % end
% % figure()
% % imagesc(ejes.xrange,ejes.yrange,suma./nz)
% % set(gca,'Fontsize',14);
% % xlabel([ejes.xlabel,'(',ejes.xunit,')'])
% % ylabel([ejes.ylabel,'(',ejes.yunit,')'])
% % title(['Sum  ',ejes.zlabel,'(',ejes.dataunit,')'])
% % colorbar