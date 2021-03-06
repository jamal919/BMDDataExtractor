function [ success ] = bmdStrWrite( fid, dataString, station_no, format )
%bmdStrWrite Write string data to file in year month day precipitation
%format
%   The string is in station name, year, month, daily data format. The data
%   string is first converted to suitable format for importing to the
%   databse and then write the to file given by variable fid.
% Author: Jamal Uddin Khan
% Email: jamal919@gmail.com

% format - *.csv, *.txt

success = 0;

% Check argument
if nargin == 3
    format = 'csv';
elseif nargin < 3
    error('Insufficient argument.')
elseif nargin > 4
    error('More Argument than required.');
end

if ~strcmp(format, 'rhcsv')
    year = dataString{2};
    month = dataString{3};
end
    
if strcmp(format, 'csv')
    % Write Data into csv format

    for day = 1 : length(dataString)-3
        fprintf(fid, '%d,%d,%d,%d,%.1f\r\n', station_no, year, month, day, dataString{day+3});
    end
    %6d%4d%8d%8d%8.1f\r\n
elseif strcmp(format, 'txt')
    % Write data into space delimited format
    for day = 1 : length(dataString)-3
        fprintf(fid, '%6d%6d%8d%8d%8.1f\r\n', station_no, year, month, day, dataString{day + 3});
        % Plus 3 is to account for the first three fields
    end
elseif strcmp(format, 'rclim')
    for day = 1 : length(dataString) - 3
        fprintf(fid, '%4d%8d%8d%8.1f\r\n', year, month, day, dataString{day + 3});
    end
elseif strcmp(format, 'db')
    for day = 1 : length(dataString) - 3
        datestr = [num2str(year, '%04i'), num2str(month, '%02i'), num2str(day, '%02i')];
        fprintf(fid, '%d,%6s,.1f\r\n', station_no, datestr, dataString{day + 3});
    end
elseif strcmp(format, 'rhcsv')
    % csv format for realtive humidity
    for day = 1 : length(dataString)
        fprintf(fid, '%4d,%d,%d,%2d,%2d,%2d,%2d,%2d,%2d,%2d,%2d\r\n', dataString(day, :)); 
    end
else
    error('Error with output format. Check Argument.');
end

success = 1;
end

