# check if all .wea files have same format

hyp = lapply(wea, readLines, n=7)
true = c("place", "latitude", "longitude", "time_zone", "site_elevation",
         "weather_data_file_units")
all(sapply(hyp, function(x) all(substring(x[1:6], 1, nchar(true)) == true)))
# returns TRUE so we have the same structure in each file
sapply(hyp, function(x) identical(x[7], hyp[[1]][7]))
# are all the dates the same or is this a coincidence?

dd = lapply(wea, read.table, sep = " ", header = FALSE, skip = 6)
sapply(dd, nrow)
# each table has 8760 rows

identical(dd[[1]], dd[[2]])
# returns FALSE so the first rows are not the same

# readWEA =
#   function(file)
#   {
#     ans = read.table(file, sep = " ", header = FALSE, skip = 6)
#     names(ans) = c("month", "day", "time", "direct", "diffuse")
#     ans
#   }

rwea = lapply(wea, readWEA)
names(rwea) = basename(wea)

table(sapply(rwea, class))
sapply(rwea, dim)
sapply(rwea, names)

# put in a checkmark
stopifnot(all(sapply(rwea, is.data.frame)))
stopifnot(length(unique(sapply(rwea, nrow))) == 1)

summary(wea[[1]])

temp = with(wea[[1]], table(day, month))
temp

w = apply(temp, 1, function(x) any(x != 24))
temp[w,]

with(rwea[[1]], tapply(time, list(day, month), function(x) all(sort(x) == 1:24)))

all(sapply(rwea, function(x) identical(x[, 1:3], rwea[[1]][, 1:3])))

par(mfrow = c(1, 3))
with(rwea[[1]], plot(density(direct), xlim = range(direct), main = "direct"))
with(rwea[[1]], plot(density(diffuse), xlim = range(diffuse), main = "diffuse"))
with(rwea[[1]], plot(direct, diffuse, pch = "."))

par(mfrow = c(1, 2))
with(rwea[[1]], plot(time, direct, pch = "."))
with(rwea[[1]], plot(time, diffuse, pch = "."))

library(ggplot2)
ggplot(rwea[[1]], aes(x = time, y = direct, color = factor(month))) + geom_line()

tmp = with(rwea[[1]], tapply(direct, list(month, time), mean))
direct.avg = data.frame(direct = as.numeric(tmp),
                        month = rep(1:12, 24),
                        time = rep(1:24, each = 12))

tmp = with(rwea[[1]], tapply(diffuse, list(month, time), mean))
diffuse.avg = data.frame(diffuse = as.numeric(tmp),
                         month = rep(1:12, 24),
                         time = rep(1:24, each = 12))
ggplot(diffuse.avg, aes(x = time, y = diffuse, color = factor(month))) + geom_line()	

diffuse = lapply(rwea, function(df) tapply(df$diffuse, list(df$time, df$month), mean))
par(mfrow = c(2, 3))
invisible(mapply(function(d, name) 
  matplot(d, type = "l", main = name, ylab = "diffuse", xlab = "hour"),
  diffuse, names(diffuse)) )

byMonthAvg =
  function(df, var= "direct")
  {
    tmp = tapply(df[[var]], list(df$month, df$time), mean)
    ans = data.frame(diffuse = as.numeric(tmp),
                     month = factor(rep(1:12, 24)),
                     time = rep(1:24, each = 12))
    names(ans)[1] = var
    ans
  }

## codetools::findGlobals(byMonthAvg, FALSE)$variables
## [1] "mean"

## lapply(wea, function(df)
##      ggplot(byMonthAvg, aes(x = time, y = direct, color = month) +
## 			geom_line()))

tmp = lapply(rwea, byMonthAvg)
df = do.call(rbind, tmp)
df$location = factor(rep(names(rwea), sapply(tmp, nrow)))
ggplot(df, aes(x = time, y = direct, color = month)) + geom_line() + 
  facet_wrap(vars(location))

