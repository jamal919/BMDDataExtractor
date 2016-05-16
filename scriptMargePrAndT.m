%% scriptMargePAnsTSimple loads the data, and simply give output
% No attempt is made to check due to time constrain
% Author: Md. Jamal Uddin Khan
% Created: 25.04.2016

%% Start and End Date
startDate = [1948 01 01];
endDate = [2015 06 30];

%% Laoding data file
[prFileName, prPathName] = uigetfile({'*.txt; *.csv'}, 'Select file of precipitation data');
prData = importdata(fullfile(prPathName, prFileName));
[tmaxFileName, tmaxPathName] = uigetfile({'*.txt; *.csv'}, 'Select file of tempMax data');
tmaxData = importdata(fullfile(tmaxPathName, tmaxFileName));
[tminFileName, tminPathName] = uigetfile({'*.txt; *.csv'}, 'Select file of tempMin data');
tminData = importdata(fullfile(tminPathName, tminFileName));

%% Running function
margedResult = MargePrAndT(prData, tmaxData, tminData, startDate, endDate);

%% Output
outVar = margedResult(:, 2:end);
outFileDir = uigetdir();
csvwrite(fullfile(outFileDir, prFileName), outVar);
fprintf('Completed file - %s\n', prFileName);