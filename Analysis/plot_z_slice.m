%loads a .mat 3d data file and extracts a zvalue slice


function plot_z_slice(file,zvalue)
load(file);
zarray=ejes.z_array;
index=find (zarray>zvalue,1);
figure()
imagesc(ejes.xrange,ejes.yrange,squeeze(data(:,:,index)))
set(gca,'Fontsize',14);
xlabel([ejes.xlabel,'(',ejes.xunit,')'])
ylabel([ejes.ylabel,'(',ejes.yunit,')'])
title([ejes.datalabel,'(',ejes.dataunit,')@',ejes.zlabel,'=',num2str(zvalue),ejes.zunit])
colorbar
end