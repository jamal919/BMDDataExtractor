function [ margedResult, startDateVec, endDateVec ] = MargePrAndT( prData, tMaxData, tMinData, stationPresent )
%%MargePrAndT marge and returns the time indexed Precipitation, Maximum
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

%% Constants
MISSING_VALUES = -99.9;

%% Iput Argument check
if nargin == 3
    stationPresent = true;
elseif nargin == 4
    % All parameters are present
    % Proceed
else
    error('Minimum 3 Argument is required');
end

%% Setting Start and end Date
% using datevec format [year month day]
startDate = [2014, 1, 1];
endDate = [2015, 6, 30];

%% Create output variables
dnStartDate = datenum(startDate);
dnEndDate = datenum(endDate);
outLength = dnEndDate - dnStartDate + 1; % +1 for first day
% Data format - [station, year, month, day, pr, tmax, tmin]
outVar = zeros(outLength, 7);
%% Iterate over date
% First day starts with zero
if stationPresent
    % Check if the station number are similar
    if prData(1, 1) == tMaxData(1, 1)
        if tMaxData(1, 1) == tMinData(1, 1)
            stationNumber = prData(1, 1);
        else
            fprintf('\t MargePrAndT WARNING: TMax and TMin station number is not same.\n');
        end
    else
        fprintf('\tMargePrAndT WARNING: Pr TMax station number is not same.\n');
        fprintf('\t\t\tUsing station number from Pr.\n');
        stationNumber = prData(1, 1);
    end
    
    % Now iteration
    for i = 0 : outLength - 1
        outVar(i + 1, 1) = stationNumber;
        dateVec = datevec(dnStartDate + i);
        outVar(i + 1, 2:4) = dateVec(1:3);
        outVar(i + 1, 5) = EmptyHandler(prData(prData(:, 2) == dateVec(1) & prData(:, 3) == dateVec(2) & prData(:, 4) == dateVec(3), 5), MISSING_VALUES);
        outVar(i + 1, 6) = EmptyHandler(tMaxData(tMaxData(:, 2) == dateVec(1) & tMaxData(:, 3) == dateVec(2) & tMaxData(:, 4) == dateVec(3), 5), MISSING_VALUES);
        outVar(i + 1, 7) = EmptyHandler(tMinData(tMinData(:, 2) == dateVec(1) & tMinData(:, 3) == dateVec(2) & tMinData(:, 4) == dateVec(3), 5), MISSING_VALUES);
    end
%% Returning the results

margedResult = outVar;
startDateVec = startDate;
endDateVec = endDate;
end
