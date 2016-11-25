%clear all
namestart='322p98to222p980p5Z_height_';
startnr=0;
endnr=199;
nameend='_ch1_bwd_';
zunit='nm';
dataunit='hz';
nam='test';

n=endnr-startnr+1;
for i=1:n
number=startnr+i-1;
if number<10
    numberstr=['00',num2str(number)];
else if number<100
    numberstr=['0',num2str(number)];
    else
        numberstr=num2str(number);
    end
end
filename=[namestart,numberstr,nameend]

[header,data]=readbcfr_fcn(filename);
hea=header;
datafull(:,:,i)=data(:,:);
end

data=datafull;

ejes.x_array=1:hea.nx;
ejes.y_array=1:hea.ny;
ejes.z_array=1:n;
ejes.xrange=[ejes.x_array(1),ejes.x_array(end)];
ejes.yrange=[ejes.y_array(1),ejes.y_array(end)];

ejes.xlabel='X position';
ejes.ylabel='Y position';
ejes.topolabel='Z topography';
ejes.zlabel='lets see';
ejes.datalabel='whatever';
ejes.xunit=hea.xunit;
ejes.yunit=hea.yunit;
ejes.zunit=zunit;
ejes.dataunit=hea.zunit; %to be done properly
Header=header;

savename=[nam,'.mat'];
save(savename,'data','ejes','Header');

clear all