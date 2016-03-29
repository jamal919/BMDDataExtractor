% Script for reading the BMD station data file. 
% Author: Jamal Uddin Khan
% Email: Md. Jamal Uddin Khan

% Bugs:
%   Check if station location was found correctly

% Clearing all
clc; close all;

[ofile, ofileloc] = uigetfile('*', 'Select BMD precipitation file');

T = readtable([ofileloc, ofile]);
db = 1; % Writing for Access database

saveto = uigetdir();

% loading station file
load tasStations;
% Variables
% station index -> An index of the stations
% station_names -> Indexed station names
% station_no -> Here sequential number

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
current_station = 0; % set to zero
nos = 0;
r = 0;
c = 0;
fid = -1; % -1 for conforming with the MATLAB notation of no file is open

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
        if length(linedata) >= 136
            % Reading as formatted text for 31 days
            tr = textscan(linedata, '%d %d %d %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f');
            % Check if it is the header using isempty function
            if isempty(tr{1})
                % When read the index file and others, it creates empty
                % matrix. No need to consider in the calculation.
                continue;
            end
            
            % Check for false positive by checking the last value 31st date
            % is empty
            if isempty(tr{34})
                tr = tr(1 : length(tr) - 1);
                % Else, do nothing
            end
            % tr becomes 30 days
            
            % False positive
            if isempty(tr{33})
                tr = tr(1 : length(tr) - 1);
                % Else, do nothing
            end
            % tr becomes 29 days
            
            % False positive
            if isempty(tr{32})
                tr = tr(1 : length(tr) - 1);
                % Else, do nothing
            end
            % becomes 28 days
            % This is the limit here.
        end
    end
    
    % Now separating the station_numbers
    % Set the name of the station to a temp_value
    if tr{1} == current_station
        % No need to change the fid
        % just call the function and write the data
        
        bmdCSVWrite(fid, tr, station_no(nos), db);  
    else
        % fclose current fid if not empty else create an fid
        if fid == -1 % no file is opened
            % keep an eye for invalid file here
            current_station = tr{1};
            [nos, ~] =  find(station_index == current_station);
            filename = [saveto, '\', num2str(station_no(nos)), station_names{nos}, '.txt'];
            fid = fopen(filename, 'a');
        else
			fprintf('%s written successfully.\n', filename);
            fclose(fid);
            % create filename
            current_station = tr{1};
            [nos, ~] = find(station_index == current_station);
            if nos <= length(station_no)
                filename = [saveto, '\', num2str(station_no(nos)), station_names{nos}, '.txt'];
                fid = fopen(filename, 'a');
            else
                % Do nothing
            end
        end
        % Write the data, calling the function
        bmdCSVWrite(fid, tr, station_no(nos), db);
    end
        
end

fprintf('Write Completed!\n')