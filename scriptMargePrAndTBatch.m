%% scriptMargePAnsTBatch loads the data, and simply give output
% No attempt is made to check due to time constrain
% Author: Md. Jamal Uddin Khan
% Created: 25.04.2016

% BUG: Shows dimension problem for some reason while processing 27CoxsBazar
% file.

%% File format
INFILE = '*.txt';

%% Start and End Date
startDate = [1948 01 01];
endDate = [2015 06 30];

%% Laoding data file location
prPathName = uigetdir([], 'Select file of precipitation data');
prFiles = dir(fullfile(prPathName, INFILE));
tmaxPathName = uigetdir([], 'Select file of tempMax data');
tmaxFiles = dir(fullfile(tmaxPathName, INFILE));
tminPathName = uigetdir([], 'Select file of tempMin data');
tminFiles = dir(fullfile(tminPathName, INFILE));

% Output Dir
outDir = uigetdir([], 'Select output folder');

%% Running loop
if length(prFiles) == length(tmaxFiles) && length(tmaxFiles) == length(tminFiles)
    for i = 1 : length(prFiles)
        prData = importdata(fullfile(prPathName, prFiles(i).name));
        tmaxData = importdata(fullfile(tmaxPathName, tmaxFiles(i).name));
        tminData = importdata(fullfile(tminPathName, tminFiles(i).name));

        % Running function
        margedResult = MargePrAndT(prData, tmaxData, tminData, startDate, endDate);

        % Output
        %outVar = margedResult(:, 2:end); %For RClimdex
        outVar = margedResult; % For database
        outFileNamei = textscan(prFiles(i).name, '%d%s.%s'); outFileName = outFileNamei{2};
        outFileDir = strsplit(outFileName{1}, '.'); outFileDir = outFileDir{1};
        mkdir(fullfile(outDir, outFileDir));
        csvwrite(fullfile(outDir, outFileDir, outFileName{1}), outVar);
        fprintf('Completed file - %s\n', outFileName{1});
    end
else
    error('Number of files mismatches in the directory.')
end