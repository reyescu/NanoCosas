
filename = '14BR_D_Spec18.txt';

delimiter = '\t';
formatSpec = '%f%f%[^\n\r]';
fileID = fopen(filename,'r');

dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
fclose(fileID);


Wl = dataArray{:, 1};
Int = dataArray{:, 2};


%% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans;
plot(Wl,Int)
xlabel('Raman Shift (cm^{-1})','FontSize',16)
ylabel('Intensity (a.u.)','FontSize',16)
set(gca,'FontSize',14)