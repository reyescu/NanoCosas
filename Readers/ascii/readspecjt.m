%% Import data from text file.
% Script for importing data from the following text file:
%
%    /Users/reyes/Google Drive/0_CurrentProjects/Fit SC gap/S_160320_029_Pb.dat
%
% To extend the code to different selected data or a different text file,
% generate a function instead of a script.

% Auto-generated by MATLAB on 2017/03/04 19:06:30

%% Initialize variables.
filename = '/Users/reyes/Google Drive/0_CurrentProjects/Fit SC gap/S_160320_029_Pb.dat';
delimiter = '\t';
startRow = 17;

%% Format string for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
textscan(fileID, '%[^\n\r]', startRow-1, 'WhiteSpace', '', 'ReturnOnError', false);
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Allocate imported array to column variable names
BiascalcV = dataArray{:, 1};
CurrentA = dataArray{:, 2};
SRXV = dataArray{:, 3};
SRYV = dataArray{:, 4};
BiasV = dataArray{:, 5};
Zm = dataArray{:, 6};


%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;