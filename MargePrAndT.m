function [ margedResult, startDateVec, endDateVec ] = MargePrAndT( prData, tMaxData, tMinData )
%MargePrAndT marge and returns the time indexed Precipitation, Maximum
%Temperature and Minimum Temperature
%   This function takes precipitation, maxmimum temperature and minimum
%   temperaute as the input argument and return the time indexed
%   margedResult as a matrics of columns - Year, Month, Day, Precipitation,
%   Maximum Temperature and Minimum temperature. This function also returns
%   the startDateVec and endDateVec as the range of the data set.
%
% Author: Jamal Uddin Khan
% Email: jamal919@gmail.com
% Created: 10/04/2016

% Constants
MISSING_VALUES = -99.9;

% Output values
margedResult = [];

%% Checking data length for prData (1), tMaxData (2), tMinData (3)
% Finding data with smallest data length
[~, startIndex] = max([datetime(prData(1, 2:4)), datetime(tMaxData(1, 2:4)), datetime(tMinData(1, 2:4))]);
[~, endIndex] = min([datetime(prData(end, 2:4)), datetime(tMaxData(end, 2:4)), datetime(tMinData(end, 2:4))]);

% Select start date by taking the max of starting dates
if startIndex == 1
    % prData is the smallest
    stDate = prData(1, 2:4);
elseif startIndex == 2
    % tMaxData is the smallest
    stDate = tMaxData(1, 2:4);
elseif startIndex == 3
    % tMinData is the smallest
    stDate = tMinData(1, 2:4);
end

% Select End Date
if endIndex == 1
    endDate = prData(end, 2:4);
elseif endIndex == 2
    endDate = tMaxData(end, 2:4);
elseif endIndex == 3
    endDate = tMinData(end, 2:4);
end

%% Finding unique year
uniqueYear = stDate(1) : endDate(1);

%% Now for each unique year, collect data and marge them constantly
for year = 1 : uniqueYear
    % Find where the data value is maximum
    prYear = length(prData(prData(:, 2) == uniqueYear(year), 2 : 4));
    tMaxYear = length(tMaxData(tMaxData(:, 2) == uniqueYear(year), 2 : 4));
    tMinYear = length(tMinData(tMinData(:, 2) == uniqueYear(year), 2 : 4));
    
    if length(prYear) == length(tMaxYear) && length(tMaxYear) == length(tMinYear)
       fprintf('MargePrAndT :: Data is OK');
    else
        fprintf('MargePrAndT :: Data mismatch');
    end
    
    rowSize = max([prYear, tMaxYear, tMinYear]);
    
    chunkData = ones(rowSize, 6) * MISSING_VALUES;
    
    chunkData(:, 1) = prData(prData(:, 2) == uniqueYear(year), 2);
    chunkData(:, 2) = prData(prData(:, 2) == uniqueYear(year), 3);
    chunkData(:, 3) = prData(prData(:, 2) == uniqueYear(year), 4);
    chunkData(:, 4) = prData(prData(:, 2) == uniqueYear(year), 5);
    chunkData(:, 4) = tMaxData(tMaxData(:, 2) == uniqueYear(year), 5);
    chunkData(:, 5) = tMinData(tMinData(:, 2) == uniqueYear(year), 5);
    
    margedResult = [margedResult; chunkData];
end

%% Other results
startDateVec = stDate;
endDateVec = endDate;
end

