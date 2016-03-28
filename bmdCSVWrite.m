function [ success ] = bmdCSVWrite( fid, dataString, station_no, db )
%bmdStrWrite Write string data to file in year month day precipitation
%format
%   The string is in station name, year, month, daily data format. The data
%   string is first converted to suitable format for importing to the
%   databse and then write the to file given by variable fid.
success = 0;

year = dataString{2};
month = dataString{3};

if db == 0
    % Write data for rClimDex directly

    for day = 1 : length(dataString)-3
        linestr = [];
        datestr = [num2str(year, '%04i'), num2str(month, '%02i'), num2str(day, '%02i')];
        linestr = [];
    end
    
elseif db == 1
    % Write data for database
    % date in yyyymmdd format
    for day = 1 : length(dataString)-3
        datestr = [num2str(year, '%04i'), '/', num2str(month, '%02i'), '/', num2str(day, '%02i')];
        fprintf(fid, '%s,%s,%s\n', num2str(station_no), datestr, num2str(dataString{day + 3}));
        % Plus 3 is to account for the first three fields
    end
end

success = 1;
end
