%% MargePAnsTSimple loads the data, and simply give output
% No attempt is made to check due to time constrain
% Author: Md. Jamal Uddin Khan
% Created: 25.04.2016

%% Laoding data file
[prFileName, prPathName] = uigetfile({'*.txt; *.csv'}, 'Select file of precipitation data');
prData = importdata(fullfile(prPathName, prFileName));
[prR, prC] = size(prData);
[tmaxFileName, tmaxPathName] = uigetfile({'*.txt; *.csv'}, 'Select file of tempMax data');
tmaxData = importdata(fullfile(tmaxPathName, tmaxFileName));
[tmaxR, tmaxC] = size(tmaxData);
[tminFileName, tminPathName] = uigetfile({'*.txt; *.csv'}, 'Select file of tempMin data');
tminData = importdata(fullfile(tminPathName, tminFileName));
[tminR, tminC] = size(tminData);

%% Displaying information
fprintf('Now processing -- %s\n', prFileName);
fprintf('prData   -   %d by %d\n', prR, prC);
fprintf('tmaxData -   %d by %d\n', tmaxR, tmaxC);
fprintf('tminData -   %d by %d\n', tminR, tminC);

%% Marging
outVar = ones(length(prData), 7);

outVar(:, 1:5) = prData(:, 1 : 5);
outVar(:, 6) = tmaxData(:, 5);
outVar(:, 7) = tminData(:, 5);

%% Output
outFileDir = uigetdir();
csvwrite(fullfile(outFileDir, prFileName), outVar);
fprintf('Completed file - %s\n', prFileName);