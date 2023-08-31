
titles = c(DryBulbTemp = "Monthly Statistics for Dry Bulb temperatures",
           DewPointTemp = "Monthly Statistics for Dew Point temperatures",
           HourlyDryBulbTemp = "Average Hourly Statistics for Dry Bulb temperatures",
           HourlyDewPointTemp = "Average Hourly Statistics for Dew Point temperatures",
           HourlyRelHumidity = "Average Hourly Relative Humidity",
           WindDirection = "Monthly Wind Direction {Interval 11.25 deg from displayed deg)",
           HourlyRadiation = "Average Hourly Statistics for Global Horizontal Solar Radiation",
           WindSpeed = "Monthly Statistics for Wind Speed",
           HourlyWindSpeed = "Average Hourly Statistics for Wind Speed"
)

titles = titles[order(titles)]


# Encoding issues
if(FALSE) {
  o = lapply(titles, readStatTable)
  names(o) = titles
  
  w = grepl("Monthly", titles)
  
  o2 = o
  o2[w] = lapply(o[w], transformVars)
  o2[!w] = lapply(o[!w], transformHourlyData)
  
  sol.rad = readStatTable("Average Hourly Statistics for Global Horizontal Solar Radiation")
}

titles = c("Monthly Statistics for Dry Bulb temperatures",
           "Monthly Statistics for Dew Point temperatures",
           "Average Hourly Statistics for Dry Bulb temperatures",
           "Average Hourly Statistics for Dew Point temperatures",
           "Average Hourly Relative Humidity",
           "Monthly Wind Direction {Interval 11.25 deg from displayed deg)",
           "Average Hourly Statistics for Global Horizontal Solar Radiation",
           "Monthly Statistics for Wind Speed",
           "Average Hourly Statistics for Wind Speed"
)

lines = readLines(stat[1], encoding = "latin1")

# getTableLines =
#   function(tableTitle, ll)
#   {
#     i = grep(tableTitle, ll, fixed = TRUE)
#     if(length(i) == 0) 
#       stop("Can't find table ", tableTitle, " in ", file)
#     
#     ll2 = ll[-(1:i)]
#     ww = substring(ll2, 1, 4) == "   -" | substring(ll2, 1, 2) == " -"
#     end = min(which(ww))
#     
#     ll3 = ll2[1:(end - 1L)]
#     
#     ll3[ ll3 != ""]
#   }

tbls1 = lapply(titles, getTableLines, lines)

class(tbls1)
length(tbls1)
sapply(tbls1, class)
sapply(tbls1, length)

titles = sort(titles)
tbls1 = lapply(titles, getTableLines, lines)
names(tbls1) = titles
isHourly = grepl("Hourly", titles)
split(sapply(tbls1, length), isHourly)

sapply(tbls1, function(x) all(grep("\t", x)))

tmp = unique(sapply(tbls1, `[`, 1))
length(unique(tmp))
unique(tmp)

source("../../Data/Solar/myFuns.R")

readStatTable

temp = lapply(titles, readStatTable, file = statFiles[1])
names(temp) = titles
table(sapply(temp, class))
table(sapply(temp, ncol))
sapply(temp, nrow)

names(temp[[1]])

temp[[1]]

maxHour = temp[[1]][25, -1]

vals = temp[[1]][- c(25:26), -1]
valid = mapply(function(col, index) col[index] == max(col),
               vals, maxHour)
stopifnot( all(valid) )

sapply(temp[isHourly], function(tbl) {
  maxHour = tbl[25, -1]
  vals = tbl[- c(25:26), -1]
  all(mapply(function(col, index) 
    col[index] == max(col),
    vals, maxHour))
})

sapply(temp[isHourly], function(tbl) {
  minHour = tbl[25, -1]
  vals = tbl[- c(25:26), -1]
  all(mapply(function(col, index) 
    col[index] == max(col),
    vals, minHour))
})

temp[isHourly] = lapply(temp[isHourly], function(x) x[1:24,])

transformHourlyData

mkHourlyTimeStamp

h1 = transformHourlyData(tmp[[1]])
tm = mkHourlyTimeStamp(h1$month, h1$hour)

all(format(tm, "%b") == h1$month)
all(as.integer(format(tm, "%H")) == h1$hour)

tm2 = as.POSIXlt(tm)
stopifnot(all(tm2$hour == h1$hour))
stopifnot(all(month.abb[tm2$mon + 1L] == h1$month))

df = tmp[!isHourly][[1]]
df

cvtDayHour

stats = lapply(stat,
               function(stat) {
                 
                 tbls = mapply(readStatTable, 
                               titles, names(titles), 
                               MoreArgs = list(file = stat), SIMPLIFY = FALSE)
                 names(tbls) = titles
                 
                 w = grepl("Monthly", titles)
                 
                 tbls[w] = lapply(tbls[w], transformVars)
                 tbls[!w] = lapply(tbls[!w], transformHourlyData)
                 
                 tbls
               })
names(stats) = gsub(".stat", "", basename(stat))

sapply(stats, length)

unname(sapply(stats, function(x) sapply(x, nrow)))

z = stats[[1]]
isHourly = grepl("Hourly", names(z))
vars = lapply(z[isHourly], `[`, 1)
hourly = as.data.frame(vars)
hourly$timestamp = mkHourlyTimeStamp( z[isHourly][[1]]$month, z[isHourly][[1]]$hour)

combineHourly

statcom = lapply(stats, combineHourly)

sapply(statcom, length)
sapply(statcom, class)
sapply(statcom, names)
unname(sapply(statcom, function(x) sapply(x, nrow)))

par(mfrow = c(5, 5), mar = c(3, 3, 1, 0))
mapply(function(z, showVar) {
  h = z$hourly
  vars = names(h)[-ncol(h)]
  lapply(vars, function(v) plot(as.POSIXlt(h$timestamp)$hour, h[[v]], main = if(showVar) v else ""))
}, statcom, seq_along(statc) == 1)

par(mfrow = c(5, 5), mar = c(3, 3, 1, 0))
mapply(function(z, showVar) {
  h = z$hourly
  vars = names(h)[-ncol(h)]
  lapply(vars, function(v) plot(as.POSIXlt(h$timestamp)$mon, h[[v]], main = if(showVar) v else ""))
}, statcom, seq_along(statc) == 1)

matplot(stat[[1]][[6]]$MaximumTime, stat[[1]][[6]][, c("Maximum", "Minimum", "Daily Avg")], type = "b")

monthlyDailyAvg = c("Monthly Statistics for Dew Point temperatures", "Monthly Statistics for Dry Bulb temperatures", 
                    "Monthly Statistics for Wind Speed")

locations = gsub("USA_CA_|.720576_TMYx.2007-2021", "", names(stat))
locations = gsub("[0-9]+.*", "", locations)
locations = gsub(".", " ", locations, fixed = TRUE)

par(mfrow = c(5, 3), mar = c(4, 2, 1, 0))
invisible(mapply(function(x, id, row) {
  mapply(function(df, pos) {
    matplot(df$MaximumTime, df[, c("Maximum", "Minimum", "Daily Avg")], type = "b",
            xlab = if(row == 1) gsub("Monthly Statistics for ", "", monthlyDailyAvg[pos]) else "",
            main = if(pos == 1) id else "")
  }, x[monthlyDailyAvg], seq_along(x[monthlyDailyAvg]))
}, stats, locations, seq_along(stats)))
