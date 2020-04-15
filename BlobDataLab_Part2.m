%% 0. Read in files with WOA decadal mean monthly climatological temperature
% I have written the code for this part for you, but I encourage you to
% read it to see what I have done - and you will also need to download the
% original data files so that the code will run.
% ***For this part to work, you will need to download and add to your path the
% original data files in the folder at: https://tinyurl.com/NEPacificWOAdata

% For your reference, the files provided at the link above were downloaded from
% https://data.nodc.noaa.gov/thredds/catalog/nodc/archive/data/0114815/public/temperature/netcdf/decav/1.00/catalog.html
% and subset to only include the North Pacific region

for i = 1:12

    if i < 10
        filename = ['woa13_decav_t0' num2str(i) '_01_NEPac.nc'];
    else
        filename = ['woa13_decav_t' num2str(i) '_01_NEPac.nc'];
    end
    if i == 1
        woa.T = ncread(filename,'t_an');
        woa.depth = ncread(filename,'depth');
        woa.lat = ncread(filename,'lat');
        woa.lon = ncread(filename,'lon');
    else
        woa.T(:,:,:,i) = ncread(filename,'t_an');
    end
end
%% 1. Extract the World Ocean Atlas (WOA) climatological mean data at Ocean Station Papa
%Use the "min" function to find the indices within the woa data for the
%latitude and longitude that match the location of the OOI flanking mooring B
%(the code I wrote later will only work if you name these indices "indlon"
%and "indlat")

[indlat, indloc] = (min(abs(woa.lat-lat))) %50.377
%[BATS_lat,BATS_latloc] = min(abs(latgrid-31.6));
[indlon, indlonloc] = min(abs(lon - woa.lon ))

%Determine the depth index within woa.depth that matches the depth of the
%temperature sensor on the OOI flanking mooring B (the code I wrote later
%will only work if you name this index "inddepth")

inddepth = find(woa.depth == 30)

%Now you will use the latitude, longitude, and depth indices from above to extract the
%annual climatology of temperature at the location where the OOI flanking
%mooring B data were collected

woa_papa = squeeze(woa.T(indlonloc,indlatloc,inddepth,:));

%% 2a. Create an extended version of the World Ocean Atlas 12-month climatology
% repeated over the entire timeline of which the OOI mooring data were collected
%I have done this step for you: it creates a timeline that you will use
%below to plot the WOA climatology, extending the 12-month seasonal cycle
%to cover the period from the beginning of 2013 through the end of March
%2020

woa_time = [datenum(2013,1:12,15) datenum(2014,1:12,15)...
    datenum(2015,1:12,15) datenum(2016,1:12,15) datenum(2017,1:12,15)...
    datenum(2018,1:12,15) datenum(2019,1:12,15) datenum(2020,1:3,15)];
woa_papa_rep = [repmat(woa_papa,7,1); woa_papa(1:3)];

%% 2b. Plot the WOA temperature time series along with the OOI temperature time series from Part 1
%confused
plot(tt_merged, SST_merged, "k-")
hold on 
plot (woa_time,  woa_papa_rep)
datetick('x', 23)

%% 3a. Interpolate WOA data onto the times where the OOI data were collected at Ocean Station Papa
% Use the "interp1" function to interplate the World Ocean Atlas
% temperature data over the extended timeline (woa_papa_rep) from the
% original extended monthly data (woa_time) onto the times when the OOI
% data were collected (from your Part 1 analysis)

interp_woa = interp1(woa_time, woa_papa_rep, tt_merged);

plot(tt_merged, interp_woa)

%% 3b. Calculate the temperature anomaly as the difference between the OOI mooring
% observations (using the smoothed data during good intervals) and the
% climatological data from the World Ocean Atlas interpolated onto those
% same timepoints
% -->

%% 4. Plot the time series of the T anomaly you have now calculated by combining the WOA and OOI data

%% 5. Now bring in the satellite data observed at Ocean Station Papa

%5a. Convert satellite time to MATLAB timestamp (following the same approach
%as in Part 1 step 2, where you will need to check the units on the satellite data
%timestamp and use the datenum function to make the conversion)
% -->

%5b. In order to extract the satellite SSTanom data from the grid cell
%nearest to OSP, calculate the indices of the longitude and latitude in the
%satellite data grid nearest to the latitude and longitude of Ocean Station
%Papa (as you did for the WOA data in Step 1 above)
% -->
% -->

%% 6. Plot the satellite SSTanom data extracted from Ocean Station Papa and
%the mooring-based temperature anomaly calculated by combining the OOI and
%WOA data together as separate lines on the same time-series plot (adding
%to your plot from step 4) so that you can compare the two records

