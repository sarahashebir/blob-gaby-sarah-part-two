%% 1. Explore and extract data from one year of OOI mooring data

myFolder = 'myFolder';
filePattern = fullfile (myFolder,'*.nc');
theFiles = dir(filePattern);

for i=1:5
baseFileName = theFiles(i).name;
filename=baseFileName;

ncdisp(filename);

theFiles(i).lat = ncreadatt(filename,'/','lat');
theFiles(i).lon = ncreadatt(filename,'/','lon');

theFiles(i).time = ncread(filename,'time');
 
theFiles(i).SST = ncread(filename,'ctdmo_seawater_temperature');

theFiles(i).pressure = ncread(filename,'pressure');

theFiles(i).tt=datenum(1900,1,1,0,0,theFiles(i).time);

theFiles(i).diff= diff(theFiles(i).tt);
%% Figure Not needed for final

theFiles(i).diff_tt=diff(theFiles(i).tt)
theFiles(i).interval=1/theFiles(i).diff_tt(1,1)

tt_merged = ([theFiles(1).tt; theFiles(2).tt; theFiles(3).tt; theFiles(4).tt; theFiles(5).tt])
SST_merged= ([theFiles(1).SST; theFiles(2).SST; theFiles(3).SST; theFiles(4).SST; theFiles(5).SST])
plot(tt_merged, SST_merged)
datetick('x', 23)
%% Figure Not needed for final

theFiles(i).smooth_SST= movmean(theFiles(i).SST,theFiles(i).interval)

smooth_SST_merged= ([theFiles(1).smooth_SST; theFiles(2).smooth_SST; theFiles(3).smooth_SST; theFiles(4).smooth_SST; theFiles(5).smooth_SST])

plot(tt_merged,smooth_SST_merged, "r-")
datetick('x', 23)

%% Figure Not needed for final
% 4b. Use the movstd function to calculate the 1-day moving standard
% deviation of the data.

theFiles(i).movstd_SST= movstd(theFiles(i).SST,theFiles(i).interval)

movstd_SST_merged = ([theFiles(1).movstd_SST; theFiles(2).movstd_SST; theFiles(3).movstd_SST; theFiles(4).movstd_SST; theFiles(5).movstd_SST])

plot(tt_merged,movstd_SST_merged, "r-")
datetick('x', 23)
%% Figure Not Needed for Final 
% A plot of the 1-day moving mean on the same plot as the original raw data

plot(tt_merged, SST_merged)
datetick('x', 23)

hold on 
plot(tt_merged,smooth_SST_merged, "r-")
datetick('x', 23)
hold off
%% Figure Needed for Final 
%5b. A plot of the 1-day moving standard deviation, on a separate plot
%underneath, but with the same x-axis (hint: you can put two plots in the
%same figure by using "subplot" and you can specify

figure (1);

subplot (2,1,2)
plot(tt_merged,movstd_SST_merged, "r-")
datetick('x', 23)

subplot (2,1,1)
plot(tt_merged, SST_merged)
datetick('x', 23)

hold on 
plot(tt_merged,smooth_SST_merged, "r-")
datetick('x', 23)
hold off



%% 6. Identifying data to exclude from analysis
% Based on the plot above, you can see that there are time periods when the
% data are highly variable - these are time periods when the raw data won't
% be suitable for use to use in studying the Blob.

%6a. Based on your inspection of the data, select a cutoff value for the
%1-day moving standard deviation beyond which you will exclude the data
%from your analysis. Note that you will need to justify this choice in the
%methods section of your writeup for this lab.
%cut off at .025 STD
theFiles(i).cut_off=.025
theFiles(i).new_STD= find(theFiles(i).movstd_SST<=theFiles(i).cut_off)

theFiles(i).cut_off_SST= theFiles(i).SST(theFiles(i).new_STD)
theFiles(i).cut_off_tt= theFiles(i).tt(theFiles(i).new_STD)

cut_tt_merge=([theFiles(1).cut_off_tt; theFiles(2).cut_off_tt; theFiles(3).cut_off_tt; theFiles(4).cut_off_tt; theFiles(5).cut_off_tt])
cut_SST_merge=([theFiles(1).cut_off_SST; theFiles(2).cut_off_SST; theFiles(3).cut_off_SST; theFiles(4).cut_off_SST; theFiles(5).cut_off_SST])
%% Needed for final
%6c. Update your figure from #5 to add the non-excluded data as a separate
%plotted set of points (i.e. in a new color) along with the other data you
%had already plotted.

figure(2);

subplot (2,1,2)
plot(tt_merged,movstd_SST_merged, "b-")
datetick('x', 23)

subplot (2,1,1)
plot(tt_merged, SST_merged, "k-")
datetick('x', 23)

hold on 
plot(tt_merged,smooth_SST_merged, "m-")
datetick('x', 23)

hold on
plot(cut_tt_merge, cut_SST_merge, "c")

hold off
end