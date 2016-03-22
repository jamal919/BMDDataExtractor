% Script for reading the BMD station data file. 
% Author: Jamal Uddin Khan
% Email: Md. Jamal Uddin Khan

% Clearing all
clc; close all;

openfile = uigetfile('*', 'Select BMD precipitation file');

T = readtable(openfile);
db = 1; % Writing for Access database

saveto = uigetdir();

% Three types of data line here
% Daily Total rainfall - Length 46
% Line with 30 days - Length 140
% Line with 31 days - Length 144
% Line with 28 days - Length 132
% Line with 29 days - Length 136
% TODO - READ for the values and set as required

% To read table data need a row column cell indexing
% read like - T{row, column}{1} 
% Last {1} is for reading the data from cell.
% To read table need a row column normal indexing

% Data modification
% All null data were *** previously which is converted to -99.9 for
% convenience. 

% Data format
% Sample data
% Dhaka        1953  1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
% <Station name> <year> <month> <day number vector>
% To be written as StationName_Pr.txt

% To Extract station first a line is taken, station number is selected,
% then fopen is used to open a file name based on that station. For second
% line, station variable is checked if they are same. If not then old file
% is closed and new file is opened to write the data. Similarly proceed for
% all the data rows. Station name and latitude longitude is to be found
% later. 
% for 31 days - j = textscan(c, '%s %d %d %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f
% %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f');

% Size of Table
[trow, tcol] = size(T);
current_station = [];
station_no = 0;
fid = [];

% Now running loop over #1 to #trow
for row = 1 : trow
    % reading the line #row
    % read as text
    linedata = T{row, 1}{1};
    if length(linedata) < 136
        % These are not any kind of data. Just information.
        % Proceeding further with other line.
        continue;
    else
        if length(linedata) >= 144
            % 2 possibilities here
            % A 31 days data or a table header file.
            % Check and work the line correctly
            
            % Reading as formatted text for 31 days, 144 
            tr = textscan(linedata, '%s %d %d %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f');
            % Check if it is the header using strcmp function
            if strcmp(tr{1}{1}, 'Station')
                continue;
            else
                % TODO
                % Set data to a variable.
            end
        elseif length(linedata) >= 140 && length(linedata) <= 143
            % Reading formatted text for 30 days, 140 - 143 charecter,
            % always data
            tr = textscan(linedata, '%s %d %d %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f');
        elseif length(linedata) >= 132 && length(linedata) <= 135
            % Reading formatted text for 28 days, 132 to 135
            % Always data
            tr = textscan(linedata, '%s %d %d %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f');
        elseif length(linedata) >= 136 && length(linedata) <= 139
            % Reading formatted text for 29 days, 136 to 139
            % Always data
            tr = textscan(linedata, '%s %d %d %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f');
        end
    end
    
    % Set the name of the station to a temp_value
    if strcmp(tr{1}{1}, current_station)
        % No need to change the fid
        % just call the function and write the data
        bmdStrWrite(fid, tr, station_no, db);  
    else
        % fclose current fid if not empty else create an fid
        if isempty(fid)
            current_station = tr{1}{1};
            station_no = station_no + 1;
            filename = [saveto, '\', num2str(station_no), tr{1}{1}, '.txt'];
            fid = fopen(filename, 'a');
        else
			fprintf('%s.txt written successfully.\n', filename);
            fclose(fid);
            % create filename
            station_no = station_no + 1;
            current_station = tr{1}{1};
            filename = [saveto, '\', num2str(station_no), tr{1}{1}, '.txt'];
            fid = fopen(filename, 'a');
        end
        % Write the data, calling the function
        bmdStrWrite(fid, tr, station_no, db);
    end
        
end

fprintf('Write Completed!')