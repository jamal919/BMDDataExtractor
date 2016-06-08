% rh_Extract.m
% Script for reading the BMD station data file for relative humidity. 
% Author: Jamal Uddin Khan
% Email: jamal919@gmail.com

% Bugs:
%   Check if station location was found correctly
%   Doesnot check if there is problem in input data
%   Total errors in 2015 input file: 

% Clearing all
clc; close all; fclose('all');

[oFile, oFileLoc] = uigetfile('*', 'Select BMD Relative Humidity file');

ofid = fopen(fullfile(oFileLoc, oFile));
% db = 0; % Writing for Access database
outFormat = 'rhcsv'; % Writing for Relative Humidity in csv format

saveto = uigetdir();

%% loading station file
load tasStations;
% Variables
% station index -> An index of the stations
% station_names -> Indexed station names
% station_no -> Here sequential number

%% On Data format
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
% <Station name> <year> <month> <hour> <day number vector>
% To be written as StationName.txt

% To Extract station first a line is taken, station number is selected,
% then fopen is used to open a file name based on that station. For second
% line, station variable is checked if they are same. If not then old file
% is closed and new file is opened to write the data. Similarly proceed for
% all the data rows. Station name and latitude longitude is to be found
% later. 
% for 31 days - j = textscan(c, '%s %d %d %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f
% %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f');

% Initialization
currentStation = 0; % set to zero
nos = 0;
r = 0;
c = 0;
fid = -1; % -1 for conforming with the MATLAB notation of no file is open

% Variable Declarations;
currentYear = [];
currentMonth = [];
currentTime = [];
monthHolder = [];
monthComplete = 0;
scriptRunning = true;

% Now running loop over #1 to #trow
while scriptRunning
    % reading the line #row
    % read as text
    linedata = fgetl(ofid);
    
    if length(linedata) >= 100
        % Reading as formatted text for 31 days
        tr = textscan(linedata, '%d %d %d %d %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f');
        % Check if it is the header using isempty function
        if isempty(tr{1})
            % When read the index file and others, it creates empty
            % matrix. No need to consider in the calculation.
            continue;
        end

        % Check for false positive by checking the last value 31st date
        % is empty
        if isempty(tr{35})
            tr = tr(1 : length(tr) - 1);
            % Else, do nothing
        end
        % tr becomes 30 days

        % False positive
        if isempty(tr{34})
            tr = tr(1 : length(tr) - 1);
            % Else, do nothing
        end
        % tr becomes 29 days

        % False positive
        if isempty(tr{33})
            tr = tr(1 : length(tr) - 1);
            % Else, do nothing
        end
        % becomes 28 days
        % This is the limit here.

        % Now based on the length of tr, create a matrix to hold the data for
        % the synoptic relative humidity.
        % Matrix format <year> <months> <day> <0> <3> <6> <9> <12> <15> <18>
        % <21> 
        % length(tr) - 4 by 11 matrix

        % Initial case currentMonth is empty
        if isempty(currentMonth)
            % Initialize with month value and month value holder
            currentMonth = tr{3};
            monthHolder = ones(length(tr)-4, 11) * -99;
        end
        % Other cases, where currentMonth is not empty
        if currentMonth == tr{3}
            % in current month, place data accordingly
            monthHolder(:, 1) = repmat(tr{2}, [length(tr)-4, 1]);
            monthHolder(:, 2) = repmat(tr{3}, [length(tr)-4, 1]);
            monthHolder(:, 3) = reshape(1:length(tr)-4, [length(tr)-4, 1]);
            monthHolder(:, (tr{4}./3)+4) = reshape([tr{5:end}], [length(tr(5:end)), 1]);

            if tr{4} == 21
                monthComplete = 1; % Go for writing the file
            else
                monthComplete = 0; % For security reason
            end
            
            %% Writing data to file
            if monthComplete % is true
                % Now separating the station_numbers
                % Set the name of the station to a temp_value
                if tr{1} == currentStation
                    % No need to change the fid
                    % just call the function and write the data

                    bmdStrWrite(fid, monthHolder, station_no(nos), outFormat);  
                else
                    % fclose current fid if not empty else create an fid
                    if fid == -1 % no file is opened
                        % keep an eye for invalid file here
                        currentStation = tr{1};
                        [nos, ~] =  find(station_index == currentStation); % bmdStringWrite compatibility
                        filename = fullfile(saveto, [station_names{station_index == currentStation}, '.txt']);
                        fid = fopen(filename, 'a');
                    else
                        fprintf('%s written successfully.\n', filename);
                        fclose(fid);
                        % create filename
                        currentStation = tr{1};
                        [nos, ~] = find(station_index == currentStation); % bmdStringWriteCompatibilty
                        if nos <= length(station_no)
                            filename = fullfile(saveto, [station_names{station_index == currentStation}, '.txt']);
                            fid = fopen(filename, 'a');
                        else
                            % Do nothing
                        end
                    end
                    % Write the data, calling the function
                    bmdStrWrite(fid, monthHolder, station_no(nos), outFormat);
                end
            else
                % Month is not complete, continue with the operation
                continue;
            end
        
        elseif currentMonth ~= tr{3}
            % new month started
            currentMonth = tr{3};
            monthHolder = ones(length(tr)-4, 11) * -99;
        end
        
    elseif linedata == -1
        scriptRunning = false;
    end
        
end
% closing all opened file
fclose('all');
fprintf('Write Completed!\n')