# Reading Tabular Data
### This repository contains the R implementation of reading and analyzing tabular/rectangular data from [this database](https://climate.onebuilding.org/WMO_Region_4_North_and_Central_America/USA_United_States_of_America/index.html).

<strong>Overview: </strong>Read solar and climate-related data from a variety of locations in California. The data is related to solar performance for buildings and simulation models for understanding this solar performance.</li>
#### For this project, we will focus on 5 zip files: 

<ul>
  <li>USA_CA_Point.Reyes.Lighthouse.724959_TMYx.2007-2021</li>
  <li>USA_CA_Fairfield-San.Francisco.Bay.Reserve.998011_TMYx.2007-2021</li>
  <li>USA_CA_Napa.County.AP.724955_TMYx.2007-2021</li>
  <li>USA_CA_Marin.County.AP-Gnoss.Field.720406_TMYx.2007-2021</li>
  <li>USA_CA_UC-Davis-University.AP.720576_TMYx.2007-2021</li>
</ul>


### Task
For the 5 zip files, read data from
<ul>
  <li>.wea file</li>
  <li>.pvsyst file</li>
  <li>.stat file</li>
</ul>
For the .stat file, read the tables for
<ul>
  <li>Monthly Statistics for Dry Bulb temperatures</li>
  <li>Monthly Statistics for Dew Point temperatures</li>
  <li>Average Hourly Statistics for Dry Bulb temperatures</li>
  <li>Average Hourly Statistics for Dew Point temperatures</li>
  <li>Average Hourly Relative Humidity</li>
  <li>Monthly Wind Direction (Interval 11.25 deg from displayed deg)</li>
  <li>Average Hourly Statistics for Direct Normal Solar Radiation</li>
  <li>Monthly Statistics for Wind Speed</li>
  <li>Average Hourly Statistics for Wind Speed</li>
</ul>
For the monthly data sets:
<ul>
  <li>Verify that the max hour and min hour are correct</li>
  <li>Convert the data so that the rows corresponding to measured variables and dates (e.g. maximum, minimum, daily avg, ...) are columns and the columns corresponding to months are rows</li>
  <li>Convert the Day:Hour values to a time (POSIXct).</li>
  <li>Convert the measurements for other variables to numbers</li>
</ul>
For the hourly data sets:
<ul>
  <li>Convert each to a data.frame with 3 columns:</li>
  <ol>
    <li>Convert the month-hour pairs to rows with the single variable as a column</li>
    <li>One column for the month</li>
    <li>One column for the hour </li>
  </ol>
</ul>
Finally, combine the average hourly tables into a single data frame with a column for each variable. For each variable, plot the values against the hour for each month.
