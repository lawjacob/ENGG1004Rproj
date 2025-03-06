The r code does these things:
1. extract csv files from cowin.hku.hk and store in temp data set
2. filter incorrect data
3. erase irrelevent column
4. creating new dataset where it stores those records with saem date but different observation points
5. sort in ascending and descendign oreder
6. analysise sd/max/min/mean
7. boxplot generation and curve fitting code
To use the code,
first, plese download the file from https://cowin.hku.hk/english/downloadbulk.html from 2012 to 2022. unzip them and put all the folders in a folder named "weather"
the folder structure is like this: .../weather/2022,2021,2020.......2012
then open the.r file, put the path to weather folder in PUT_YOUR_PATH_HERE in first line: setwd("PUT_YOUR_PATH_HERE/weather")
,click "run form source" and wait for it to load, it will work.
The boxplot is downloaded automatically named Rplot1.jpg in the weather folder if you set it correctly as stated. You can view it by the rstudio plot window or viewing the file directly
