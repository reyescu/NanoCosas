%% Import data from text file.
clear all
%% Initialize variables.
start_filename = 'ML_WSe2_paral-circular_';
end_filename='.asc';
start_n=0;
end_n=360;
step=10;
n=round((end_n-start_n)/step)+1;
delimiter = '\t';

hh=4.135667516E-15;
cc=299792458;

formatSpec = '%s%s%[^\n\r]';

for i=1:n
    angle(i)=start_n+(i-1)*step;
    filename=[start_filename,num2str(angle(i)),end_filename];
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric strings to numbers.
% Replace non-numeric strings with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2]
    % Converts strings in the input cell array to numbers. Replaced non-numeric
    % strings with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric strings to numbers.
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end


%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

%% Allocate imported array to column variable names
lambda(i,:) = cell2mat(raw(:, 1));
intensity(i,:) = cell2mat(raw(:, 2));

end
%% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me R end_filename start_filename end_n start_n i j n step;
figure
angle_sc=[angle(1) angle(end)];
lambda=lambda(:,1:1024);
intensity=intensity(:,1:1024);
lambda_sc=[lambda(1,1) lambda(1,end)];
energy=hh.*cc./(lambda(1,:).*1E-9);
energy_sc=[energy(1) energy(end)];

imagesc(lambda_sc,angle_sc,imresize(intensity,5));
set(gca,'YDir','normal');
set(gca,'FontSize',18);
xlabel('Wavelength (nm)','FontSize',20);
ylabel('Angle (degrees)','FontSize',20);
colorbar
colormap('jet');
title('Intensity (counts)')

figure
for i=1:19
plot(energy,intensity(i,:))
hold on
end

figure
plot(energy,intensity(3,:),'Linewidth',2)
hold on
plot(energy,intensity(7,:),'Linewidth',2)
set(gca,'FontSize',18);
xlabel('Energy (eV)','FontSize',20);
ylabel('Intensity (counts)','FontSize',20);
plus=smooth(intensity(3,:),5);
minus=smooth(intensity(7,:),5);
figure
plot(energy,abs((plus-minus)./(plus+minus)))

set(gca,'FontSize',18);
xlabel('Energy (eV)','FontSize',20);
ylabel('Pol degree','FontSize',20);