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

%% Constants
MISSING_VALUES = -99.9;

%% Setting Start and end Date
% using datevec format [year month day]
startDate = [1948, 1, 1];
endDate = [2015, 6, 30];

%% Create output variables
outLength = datenum(endDate) - datenum(startDate) + 1; % +1 for first day
outVar = zeros(); %TODO
%% Iterate over date

%% Returning the results
end

